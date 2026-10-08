import 'recipe.dart';

class DraftIngredient {
  const DraftIngredient({
    this.uid = 0,
    required this.ingredientId,
    required this.name,
    this.aisle = 'other',
    this.quantityText = '',
    this.unitCode = '',
    this.note = '',
  });

  /// Stable row identity for widget keys while rows are added, removed or reordered.
  final int uid;

  /// Empty until the user picks one from the catalog.
  final String ingredientId;
  final String name;
  final String aisle;

  /// Optional. Raw text ("1 1/2", "2-3"); the backend parses it.
  final String quantityText;

  /// A unit code from the catalog ("tbsp"); blank = none. Only sent together with a quantity.
  final String unitCode;
  final String note;

  DraftIngredient copyWith({
    int? uid,
    String? ingredientId,
    String? name,
    String? aisle,
    String? quantityText,
    String? unitCode,
    String? note,
  }) =>
      DraftIngredient(
        uid: uid ?? this.uid,
        ingredientId: ingredientId ?? this.ingredientId,
        name: name ?? this.name,
        aisle: aisle ?? this.aisle,
        quantityText: quantityText ?? this.quantityText,
        unitCode: unitCode ?? this.unitCode,
        note: note ?? this.note,
      );
}

class DraftStep {
  const DraftStep({this.uid = 0, this.name = '', this.text = '', this.images = const [], this.timerMinutes, this.timerLabel});

  final int uid;

  /// Optional heading; blank = none.
  final String name;
  final String text;
  final List<RecipeStepImage> images;
  final int? timerMinutes;

  /// Not editable yet; carried through so editing never drops an existing label.
  final String? timerLabel;

  DraftStep copyWith({int? uid, String? name, String? text, List<RecipeStepImage>? images, int? Function()? timerMinutes}) =>
      DraftStep(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        text: text ?? this.text,
        images: images ?? this.images,
        timerMinutes: timerMinutes != null ? timerMinutes() : this.timerMinutes,
        timerLabel: timerLabel,
      );
}

/// Form state for creating or editing a recipe.
class RecipeDraft {
  const RecipeDraft({
    this.title = '',
    this.description = '',
    this.imageUrl,
    this.sourceUrl,
    this.baseServings = 2,
    this.totalMinutes = 30,
    this.difficulty = 2,
    this.tagIds = const {},
    this.ingredients = const [],
    this.steps = const [DraftStep()],
  });

  final String title;
  final String description;

  /// No editor on mobile yet; preserved so edits never clear them.
  final String? imageUrl;
  final String? sourceUrl;
  final int baseServings;
  final int totalMinutes;
  final int difficulty;
  final Set<int> tagIds;
  final List<DraftIngredient> ingredients;
  final List<DraftStep> steps;

  RecipeDraft copyWith({
    String? title,
    String? description,
    int? baseServings,
    int? totalMinutes,
    int? difficulty,
    Set<int>? tagIds,
    List<DraftIngredient>? ingredients,
    List<DraftStep>? steps,
  }) =>
      RecipeDraft(
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl,
        sourceUrl: sourceUrl,
        baseServings: baseServings ?? this.baseServings,
        totalMinutes: totalMinutes ?? this.totalMinutes,
        difficulty: difficulty ?? this.difficulty,
        tagIds: tagIds ?? this.tagIds,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
      );

  factory RecipeDraft.fromRecipe(Recipe recipe) => RecipeDraft(
        title: recipe.title,
        description: recipe.description ?? '',
        imageUrl: recipe.imageUrl,
        sourceUrl: recipe.sourceUrl,
        baseServings: recipe.baseServings,
        totalMinutes: recipe.totalMinutes,
        difficulty: recipe.difficulty,
        tagIds: recipe.tagIds.toSet(),
        ingredients: [
          for (final item in recipe.ingredients)
            DraftIngredient(
              ingredientId: item.ingredientId,
              name: item.name,
              aisle: item.aisle,
              quantityText: item.quantityText,
              unitCode: item.unit?.code ?? '',
              note: item.note ?? '',
            ),
        ],
        steps: [
          for (final step in recipe.steps ?? const <RecipeStep>[])
            DraftStep(
              name: step.name ?? '',
              text: step.text,
              images: step.images,
              // Timers are stored in seconds; the form edits whole minutes (ceil keeps a sub-minute timer non-zero).
              timerMinutes: step.timerSeconds == null ? null : (step.timerSeconds! / 60).ceil(),
              timerLabel: step.timerLabel,
            ),
        ],
      );
}
