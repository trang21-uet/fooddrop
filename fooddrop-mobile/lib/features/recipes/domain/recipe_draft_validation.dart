import 'recipe_draft.dart';

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
