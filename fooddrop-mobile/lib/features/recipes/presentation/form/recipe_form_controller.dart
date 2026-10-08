import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/media/media_providers.dart';
import '../../../parser/data/parser_providers.dart';
import '../../../parser/data/photo_picker.dart';
import '../../data/ingredient_catalog.dart';
import '../../data/recipe_providers.dart';
import '../../data/step_photo_uploader.dart';
import '../../domain/recipe_draft.dart';
import '../../domain/recipe_draft_validation.dart';
import '../../domain/recipe_unit.dart';
import 'recipe_form_state.dart';

part 'recipe_form_controller.g.dart';

/// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
/// controller so the screen holds no state beyond its text controllers.
@riverpod
class RecipeFormController extends _$RecipeFormController {
  int _nextUid = 0;

  @override
  RecipeFormState build(String? recipeId) {
    final recipe = recipeId == null ? null : ref.read(recipeProvider(recipeId)).value;
    // A new recipe may start from an import; the form screen clears it once shown.
    final imported = recipeId == null ? ref.read(importedDraftProvider) : null;
    final initial = recipe != null
        ? RecipeDraft.fromRecipe(recipe)
        : imported ?? const RecipeDraft();
    return RecipeFormState(
      draft: initial.copyWith(
        steps: [for (final step in initial.steps) step.copyWith(uid: _nextUid++)],
        ingredients: [for (final row in initial.ingredients) row.copyWith(uid: _nextUid++)],
      ),
    );
  }

  RecipeDraft get _draft => state.draft;

  void _edit(RecipeDraft draft) {
    state = state.copyWith(draft: draft, errors: state.errors == null ? null : validateDraft(draft));
  }

  void setTitle(String value) => _edit(_draft.copyWith(title: value));
  void setDescription(String value) => _edit(_draft.copyWith(description: value));
  void setTotalMinutes(String value) => _edit(_draft.copyWith(totalMinutes: int.tryParse(value.trim()) ?? 0));
  void setServings(String value) => _edit(_draft.copyWith(baseServings: int.tryParse(value.trim()) ?? 0));
  void setDifficulty(int value) => _edit(_draft.copyWith(difficulty: value));

  void toggleTag(int tagId) {
    final next = {..._draft.tagIds};
    if (!next.remove(tagId)) next.add(tagId);
    _edit(_draft.copyWith(tagIds: next));
  }

  // ---- Ingredients --------------------------------------------------------------------------

  void addIngredient(IngredientOption option) {
    final row = DraftIngredient(uid: _nextUid++, ingredientId: option.id, name: option.name, aisle: option.aisle);
    _edit(_draft.copyWith(ingredients: [..._draft.ingredients, row]));
  }

  void updateIngredient(int uid, {String? quantity, String? unitCode, String? note}) => _edit(
        _draft.copyWith(
          ingredients: [
            for (final row in _draft.ingredients)
              row.uid == uid ? row.copyWith(quantityText: quantity, unitCode: unitCode, note: note) : row,
          ],
        ),
      );

  /// Adds every named-but-unmatched row (typically from an import) to the shared catalog in one go.
  Future<void> addUnresolvedIngredientsToCatalog() async {
    final pending = _draft.ingredients.where((row) => row.ingredientId.isEmpty && row.name.trim().isNotEmpty).toList();
    if (pending.isEmpty) return;
    state = state.copyWith(addingIngredients: true);
    final catalog = ref.read(ingredientCatalogProvider);
    final units = ref.read(unitsProvider).value ?? const <RecipeUnit>[];
    try {
      for (final row in pending) {
        final option = await catalog.ensure(row.name, defaultUnit: defaultUnitForRowUnit(row.unitCode, units));
        if (!ref.mounted) return;
        _edit(
          _draft.copyWith(
            ingredients: [
              for (final item in _draft.ingredients)
                item.uid == row.uid ? item.copyWith(ingredientId: option.id, name: option.name, aisle: option.aisle) : item,
            ],
          ),
        );
      }
      state = state.copyWith(addingIngredients: false);
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(
          addingIngredients: false,
          ingredientError: 'Không thêm được một số nguyên liệu. Kiểm tra mạng rồi thử lại.',
        );
      }
    }
  }

  void removeIngredient(int uid) =>
      _edit(_draft.copyWith(ingredients: _draft.ingredients.where((row) => row.uid != uid).toList()));

  // ---- Steps --------------------------------------------------------------------------------

  void addStep() => _edit(_draft.copyWith(steps: [..._draft.steps, DraftStep(uid: _nextUid++)]));

  void updateStepName(int uid, String name) => _editStep(uid, (step) => step.copyWith(name: name));

  void updateStepText(int uid, String text) => _editStep(uid, (step) => step.copyWith(text: text));

  void removeStepImage(int uid, String key) =>
      _editStep(uid, (step) => step.copyWith(images: step.images.where((image) => image.key != key).toList()));

  /// Picks one or more photos and uploads each straight to storage (needs a connection); the
  /// recipe itself stays offline-first and only carries the storage keys.
  Future<void> addStepPhotos(int uid, PhotoSource source) async {
    final current = _draft.steps.where((step) => step.uid == uid).firstOrNull;
    final room = maxStepImages - (current?.images.length ?? 0);
    if (current == null || room <= 0) return;

    final List<PickedPhoto> photos;
    try {
      photos = await ref.read(photoPickerProvider).pickMany(source, limit: room);
    } catch (_) {
      state = state.copyWith(imageError: 'Không mở được máy ảnh hoặc thư viện ảnh.');
      return;
    }
    if (photos.isEmpty || !ref.mounted) return;

    state = state.copyWith(uploadingSteps: {...state.uploadingSteps, uid});
    final result = await uploadStepPhotos(photos, ref.read(mediaUploaderProvider));
    if (!ref.mounted) return;
    // Read the latest step: other edits may have landed while the photos were in flight.
    _editStep(uid, (step) => step.copyWith(images: [...step.images, ...result.images]));
    state = state.copyWith(uploadingSteps: {...state.uploadingSteps}..remove(uid), imageError: result.error);
  }

  void updateStepTimer(int uid, String minutes) {
    final value = int.tryParse(minutes.trim());
    _editStep(uid, (step) => step.copyWith(timerMinutes: () => value != null && value > 0 ? value : null));
  }

  void removeStep(int uid) => _edit(_draft.copyWith(steps: _draft.steps.where((step) => step.uid != uid).toList()));

  void moveStep(int uid, int delta) {
    final steps = [..._draft.steps];
    final from = steps.indexWhere((step) => step.uid == uid);
    final to = from + delta;
    if (from < 0 || to < 0 || to >= steps.length) return;
    steps.insert(to, steps.removeAt(from));
    _edit(_draft.copyWith(steps: steps));
  }

  void _editStep(int uid, DraftStep Function(DraftStep) change) => _edit(
        _draft.copyWith(steps: [for (final step in _draft.steps) step.uid == uid ? change(step) : step]),
      );

  // ---- Submit -------------------------------------------------------------------------------

  /// Validates and saves locally. Returns the saved recipe id, or null when invalid or failed.
  Future<String?> submit() async {
    final errors = validateDraft(_draft);
    if (!errors.isEmpty) {
      state = state.copyWith(errors: errors);
      return null;
    }
    state = state.copyWith(saving: true);
    try {
      final id = await ref.read(recipeActionsProvider).save(_draft, id: recipeId);
      if (ref.mounted) state = state.copyWith(saving: false);
      return id;
    } catch (_) {
      if (ref.mounted) state = state.copyWith(saving: false, saveError: 'Không lưu được công thức. Thử lại nhé.');
      return null;
    }
  }
}
