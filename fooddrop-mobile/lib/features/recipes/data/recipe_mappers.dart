import 'package:drift/drift.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/db/app_database.dart';
import '../domain/rarity.dart';
import '../domain/recipe.dart';
import '../domain/recipe_draft.dart';
import '../domain/recipe_unit.dart';
import 'step_codec.dart';

/// Companion rows for one recipe, ready to write in a transaction.
class RecipeRows {
  const RecipeRows({required this.recipe, required this.ingredients, required this.tagIds});

  final RecipesCompanion recipe;
  final List<RecipeIngredientsCompanion> ingredients;
  final List<int> tagIds;
}

RecipeRows rowsFromDetail(api.RecipeDetail detail) {
  final steps = [...detail.steps]..sort((a, b) => a.order.compareTo(b.order));
  return RecipeRows(
    recipe: RecipesCompanion.insert(
      id: detail.id,
      title: detail.title,
      description: Value(detail.description),
      imageUrl: Value(detail.imageUrl),
      sourceUrl: Value(detail.sourceUrl),
      baseServings: detail.baseServings,
      totalMinutes: detail.totalMinutes,
      difficulty: detail.difficulty,
      rarity: detail.rarity.value,
      stepsJson: Value(
        encodeSteps(
          steps.map(
            (s) => RecipeStep(
              name: s.name,
              text: s.text,
              images: [for (final image in s.images) RecipeStepImage(key: image.key, url: image.url)],
              timerSeconds: s.timerSeconds,
              timerLabel: s.timerLabel,
            ),
          ),
        ),
      ),
      createdAt: detail.createdAt,
    ),
    ingredients: [
      for (final (index, item) in detail.ingredients.indexed)
        RecipeIngredientsCompanion.insert(
          recipeId: detail.id,
          ingredientId: item.ingredient.id,
          name: item.ingredient.name,
          aisle: item.ingredient.aisle.value,
          quantity: Value(item.quantity?.toDouble()),
          unit: Value(item.unit?.code),
          unitNameVi: Value(item.unit?.nameVi),
          unitNameEn: Value(item.unit?.nameEn),
          unitKind: Value(item.unit?.kind.value),
          note: Value(item.note),
          sortOrder: index,
          baseQuantity: Value(item.base_.quantity.toDouble()),
          baseUnit: Value(item.base_.unit.value),
        ),
    ],
    tagIds: detail.tags.map((tag) => tag.id).toList(),
  );
}

/// Summary rows leave `stepsJson` out so a previously synced detail is never overwritten.
RecipesCompanion companionFromSummary(api.RecipeListItemsInner item) => RecipesCompanion.insert(
      id: item.id,
      title: item.title,
      description: Value(item.description),
      imageUrl: Value(item.imageUrl),
      baseServings: item.baseServings,
      totalMinutes: item.totalMinutes,
      difficulty: item.difficulty,
      rarity: item.rarity.value,
      createdAt: item.createdAt,
    );

/// Rows for a recipe written on this device. Rarity is computed locally until the server answers,
/// and the grocery base stays empty until then (converting units is the backend's job).
RecipeRows rowsFromDraft(String id, RecipeDraft draft, {required DateTime createdAt, List<RecipeUnit> units = const []}) {
  final steps = draft.steps.map(
    (step) => RecipeStep(
      name: _blankToNull(step.name),
      text: step.text.trim(),
      images: step.images,
      timerSeconds: step.timerMinutes == null ? null : step.timerMinutes! * 60,
      timerLabel: step.timerMinutes == null ? null : step.timerLabel,
    ),
  );
  return RecipeRows(
    recipe: RecipesCompanion.insert(
      id: id,
      title: draft.title.trim(),
      description: Value(_blankToNull(draft.description)),
      imageUrl: Value(draft.imageUrl),
      sourceUrl: Value(draft.sourceUrl),
      baseServings: draft.baseServings,
      totalMinutes: draft.totalMinutes,
      difficulty: draft.difficulty,
      rarity: Rarity.fromRecipe(totalMinutes: draft.totalMinutes, difficulty: draft.difficulty).apiValue,
      stepsJson: Value(encodeSteps(steps)),
      createdAt: createdAt,
    ),
    ingredients: [
      for (final (index, row) in draft.ingredients.indexed)
        RecipeIngredientsCompanion.insert(
          recipeId: id,
          ingredientId: row.ingredientId,
          name: row.name,
          aisle: row.aisle,
          quantity: Value(_parseQuantity(row.quantityText)),
          // A unit only means something next to a quantity, as on the server.
          unit: Value(_unitFor(row, units)?.code),
          unitNameVi: Value(_unitFor(row, units)?.nameVi),
          unitNameEn: Value(_unitFor(row, units)?.nameEn),
          unitKind: Value(_unitFor(row, units)?.kind),
          note: Value(_blankToNull(row.note)),
          sortOrder: index,
          // Raw text only when Dart cannot read it ("1 1/2", "2-3"); a plain number is scalable.
          displayQuantity: Value(_parseQuantity(row.quantityText) == null ? _blankToNull(row.quantityText) : null),
        ),
    ],
    tagIds: draft.tagIds.toList(),
  );
}

Recipe recipeFromRows(
  RecipeRow row, {
  required List<RecipeIngredientRow> ingredients,
  required List<int> tagIds,
  required bool isPending,
}) =>
    Recipe(
      id: row.id,
      title: row.title,
      description: row.description,
      imageUrl: row.imageUrl,
      sourceUrl: row.sourceUrl,
      baseServings: row.baseServings,
      totalMinutes: row.totalMinutes,
      difficulty: row.difficulty,
      rarity: Rarity.fromApi(row.rarity),
      createdAt: row.createdAt,
      tagIds: tagIds,
      ingredients: [
        for (final item in ingredients)
          RecipeIngredient(
            ingredientId: item.ingredientId,
            name: item.name,
            aisle: item.aisle,
            quantity: item.quantity,
            unit: item.unit == null
                ? null
                : RecipeUnit(
                    code: item.unit!,
                    nameVi: item.unitNameVi ?? item.unit!,
                    nameEn: item.unitNameEn ?? item.unit!,
                    kind: item.unitKind ?? 'other',
                  ),
            note: item.note,
            baseQuantity: item.baseQuantity,
            baseUnit: item.baseUnit,
            displayQuantity: item.displayQuantity,
          ),
      ],
      steps: row.stepsJson == null ? null : decodeSteps(row.stepsJson!),
      isPending: isPending,
    );

api.RecipeInput inputFromDraft(RecipeDraft draft) => api.RecipeInput(
      title: draft.title.trim(),
      description: _blankToNull(draft.description),
      imageUrl: draft.imageUrl,
      sourceUrl: draft.sourceUrl,
      baseServings: draft.baseServings,
      totalMinutes: draft.totalMinutes,
      difficulty: draft.difficulty,
      steps: [
        for (final step in draft.steps)
          api.RecipeInputStepsInner(
            name: _blankToNull(step.name),
            text: step.text.trim(),
            images: [for (final image in step.images) image.key],
            timerSeconds: step.timerMinutes == null ? null : step.timerMinutes! * 60,
            timerLabel: step.timerMinutes == null ? null : step.timerLabel,
          ),
      ],
      ingredients: [
        for (final row in draft.ingredients)
          api.RecipeInputIngredientsInner(
            ingredientId: row.ingredientId,
            quantity: _blankToNull(row.quantityText),
            // A unit only means something next to a quantity; the server rejects one without it.
            unit: _blankToNull(row.quantityText) == null ? null : _blankToNull(row.unitCode),
            note: _blankToNull(row.note),
          ),
      ],
      tagIds: draft.tagIds.toList(),
    );

double? _parseQuantity(String text) => double.tryParse(text.trim().replaceAll(',', '.'));

/// The catalog unit for a row, or null when it has none or no quantity to attach it to.
RecipeUnit? _unitFor(DraftIngredient row, List<RecipeUnit> units) {
  if (row.quantityText.trim().isEmpty || row.unitCode.isEmpty) return null;
  return units.where((unit) => unit.code == row.unitCode).firstOrNull ??
      RecipeUnit(code: row.unitCode, nameVi: row.unitCode, nameEn: row.unitCode, kind: 'other');
}

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
