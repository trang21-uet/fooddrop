import 'recipe.dart';

class DraftIngredient {
  const DraftIngredient({
    this.uid = 0,
    required this.ingredientId,
    required this.name,
    this.aisle = 'other',
    this.quantityText = '',
    this.unitText = '',
    this.note = '',
  });

  /// Stable row identity for widget keys while rows are added, removed or reordered.
  final int uid;

  /// Empty until the user picks one from the catalog.
  final String ingredientId;
  final String name;
  final String aisle;

  /// Raw text ("1 1/2", "2-3"); the backend parses it and normalizes to g | ml | piece.
  final String quantityText;

  /// Blank means pieces.
  final String unitText;
  final String note;

  DraftIngredient copyWith({
    int? uid,
    String? ingredientId,
    String? name,
    String? aisle,
    String? quantityText,
    String? unitText,
    String? note,
  }) =>
      DraftIngredient(
        uid: uid ?? this.uid,
        ingredientId: ingredientId ?? this.ingredientId,
        name: name ?? this.name,
        aisle: aisle ?? this.aisle,
        quantityText: quantityText ?? this.quantityText,
        unitText: unitText ?? this.unitText,
        note: note ?? this.note,
      );
}

class DraftStep {
  const DraftStep({this.uid = 0, this.text = '', this.timerMinutes, this.timerLabel});

  final int uid;
  final String text;
  final int? timerMinutes;

  /// Not editable yet; carried through so editing never drops an existing label.
  final String? timerLabel;

  DraftStep copyWith({int? uid, String? text, int? Function()? timerMinutes}) => DraftStep(
        uid: uid ?? this.uid,
        text: text ?? this.text,
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
              quantityText: item.displayQuantity ?? item.quantityText,
              unitText: item.unit == 'piece' ? '' : item.unit,
              note: item.note ?? '',
            ),
        ],
        steps: [
          for (final step in recipe.steps ?? const <RecipeStep>[])
            DraftStep(
              text: step.text,
              // Timers are stored in seconds; the form edits whole minutes (ceil keeps a sub-minute timer non-zero).
              timerMinutes: step.timerSeconds == null ? null : (step.timerSeconds! / 60).ceil(),
              timerLabel: step.timerLabel,
            ),
        ],
      );
}

/// Field-level problems keyed so the form can show them under the right input.
class DraftErrors {
  const DraftErrors({
    this.title,
    this.totalMinutes,
    this.baseServings,
    this.steps,
    this.ingredientRows = const {},
    this.stepRows = const {},
  });

  final String? title;
  final String? totalMinutes;
  final String? baseServings;

  /// Form-level step error ("add at least one step").
  final String? steps;
  final Map<int, String> ingredientRows;
  final Map<int, String> stepRows;

  bool get isEmpty =>
      title == null &&
      totalMinutes == null &&
      baseServings == null &&
      steps == null &&
      ingredientRows.isEmpty &&
      stepRows.isEmpty;
}

DraftErrors validateDraft(RecipeDraft draft) {
  final ingredientRows = <int, String>{};
  for (var i = 0; i < draft.ingredients.length; i++) {
    final row = draft.ingredients[i];
    if (row.ingredientId.isEmpty) {
      ingredientRows[i] = 'Chọn một nguyên liệu trong danh sách';
    } else if (row.quantityText.trim().isEmpty) {
      ingredientRows[i] = 'Nhập số lượng';
    }
  }
  final stepRows = <int, String>{
    for (var i = 0; i < draft.steps.length; i++)
      if (draft.steps[i].text.trim().isEmpty) i: 'Hãy mô tả bước này',
  };

  return DraftErrors(
    title: draft.title.trim().isEmpty ? 'Cần nhập tiêu đề' : null,
    totalMinutes: draft.totalMinutes < 1 || draft.totalMinutes > 10080 ? 'Nhập từ 1 đến 10080 phút' : null,
    baseServings: draft.baseServings < 1 || draft.baseServings > 100 ? 'Nhập từ 1 đến 100 khẩu phần' : null,
    steps: draft.steps.isEmpty ? 'Thêm ít nhất một bước' : null,
    ingredientRows: ingredientRows,
    stepRows: stepRows,
  );
}

/// How a new catalog ingredient should be summed, from the unit text in the form:
/// blank = counted pieces, ml/l = volume, anything else = weight.
String defaultUnitForRowUnit(String unit) {
  final folded = unit.trim().toLowerCase();
  if (folded.isEmpty) return 'piece';
  return folded == 'ml' || folded == 'l' ? 'ml' : 'g';
}
