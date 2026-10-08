import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../recipes/domain/recipe_draft.dart';

/// Formats a parsed quantity for the form's raw-text field: "500", "1.5", never "500.0"; empty when
/// the source gave no amount.
String formatParsedQuantity(num? value) {
  if (value == null) return '';
  final rounded = double.parse(value.toStringAsFixed(2));
  return rounded == rounded.roundToDouble() ? rounded.round().toString() : rounded.toString();
}

/// Parser draft → form draft. Unmatched ingredients keep an empty id so the form asks the user to add them.
RecipeDraft draftFromParseResult(api.ParseJobResult result) => RecipeDraft(
      title: result.title,
      description: result.description ?? '',
      imageUrl: result.imageUrl,
      sourceUrl: result.sourceUrl,
      baseServings: result.baseServings,
      totalMinutes: result.totalMinutes ?? 30,
      difficulty: result.difficulty,
      tagIds: result.suggestedTagIds.toSet(),
      ingredients: [
        for (final item in result.ingredients)
          DraftIngredient(
            ingredientId: item.ingredientId ?? '',
            // Show the catalog's name for matches so the visible text is what will be saved.
            name: item.matchedName ?? item.name,
            quantityText: formatParsedQuantity(item.quantity),
            unitCode: item.unit ?? '',
            note: item.note ?? '',
          ),
      ],
      steps: result.steps.isEmpty
          ? const [DraftStep()]
          : [
              for (final step in result.steps)
                DraftStep(
                  text: step.text,
                  timerMinutes: step.timerSeconds == null ? null : (step.timerSeconds! / 60).ceil().clamp(1, 1440),
                ),
            ],
    );
