import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/db/app_database.dart';
import '../domain/rarity.dart';
import '../domain/recipe.dart';
import '../domain/recipe_draft.dart';

/// Companion rows for one recipe, ready to write in a transaction.
class RecipeRows {
  const RecipeRows({required this.recipe, required this.ingredients, required this.tagIds});

  final RecipesCompanion recipe;
  final List<RecipeIngredientsCompanion> ingredients;
  final List<int> tagIds;
}

String encodeSteps(Iterable<RecipeStep> steps) => jsonEncode([
      for (final step in steps)
        {
          'text': step.text,
          if (step.timerSeconds != null) 'timerSeconds': step.timerSeconds,
          if (step.timerLabel != null) 'timerLabel': step.timerLabel,
        },
    ]);

List<RecipeStep> decodeSteps(String json) => [
      for (final raw in jsonDecode(json) as List<dynamic>)
        RecipeStep(
          text: (raw as Map<String, dynamic>)['text'] as String,
          timerSeconds: raw['timerSeconds'] as int?,
          timerLabel: raw['timerLabel'] as String?,
        ),
    ];

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
          steps.map((s) => RecipeStep(text: s.text, timerSeconds: s.timerSeconds, timerLabel: s.timerLabel)),
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
          quantity: item.quantity.toDouble(),
          unit: item.unit.value,
          note: Value(item.note),
          sortOrder: index,
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
/// and quantities stay as the raw text the user typed (normalization is the backend's job).
RecipeRows rowsFromDraft(String id, RecipeDraft draft, {required DateTime createdAt}) {
  final steps = draft.steps.map(
    (step) => RecipeStep(
      text: step.text.trim(),
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
          quantity: double.tryParse(row.quantityText.replaceAll(',', '.')) ?? 0,
          unit: row.unitText.trim().isEmpty ? 'piece' : row.unitText.trim(),
          note: Value(_blankToNull(row.note)),
          sortOrder: index,
          displayQuantity: Value('${row.quantityText.trim()} ${row.unitText.trim()}'.trim()),
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
            unit: item.unit,
            note: item.note,
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
            text: step.text.trim(),
            timerSeconds: step.timerMinutes == null ? null : step.timerMinutes! * 60,
            timerLabel: step.timerMinutes == null ? null : step.timerLabel,
          ),
      ],
      ingredients: [
        for (final row in draft.ingredients)
          api.RecipeInputIngredientsInner(
            ingredientId: row.ingredientId,
            quantity: row.quantityText.trim(),
            unit: _blankToNull(row.unitText),
            note: _blankToNull(row.note),
          ),
      ],
      tagIds: draft.tagIds.toList(),
    );

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
