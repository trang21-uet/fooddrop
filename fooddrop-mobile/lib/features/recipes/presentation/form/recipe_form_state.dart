import '../../domain/recipe_draft.dart';
import '../../domain/recipe_draft_validation.dart';

class RecipeFormState {
  const RecipeFormState({
    required this.draft,
    this.errors,
    this.saving = false,
    this.saveError,
    this.addingIngredients = false,
    this.ingredientError,
    this.uploadingSteps = const {},
    this.imageError,
  });

  final RecipeDraft draft;

  /// Null until the first submit attempt; afterwards kept in sync on every edit.
  final DraftErrors? errors;
  final bool saving;
  final String? saveError;

  /// True while unmatched (imported) ingredients are being added to the shared catalog.
  final bool addingIngredients;
  final String? ingredientError;

  /// Uids of steps with photos still uploading.
  final Set<int> uploadingSteps;
  final String? imageError;

  RecipeFormState copyWith({
    RecipeDraft? draft,
    DraftErrors? errors,
    bool? saving,
    String? saveError,
    bool? addingIngredients,
    String? ingredientError,
    Set<int>? uploadingSteps,
    String? imageError,
  }) =>
      RecipeFormState(
        draft: draft ?? this.draft,
        errors: errors ?? this.errors,
        saving: saving ?? this.saving,
        saveError: saveError,
        addingIngredients: addingIngredients ?? this.addingIngredients,
        ingredientError: ingredientError,
        uploadingSteps: uploadingSteps ?? this.uploadingSteps,
        imageError: imageError,
      );
}
