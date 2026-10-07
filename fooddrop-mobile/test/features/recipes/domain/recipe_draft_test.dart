import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';

void main() {
  group('validateDraft', () {
    test('a fresh draft only complains about the missing title and step text', () {
      final errors = validateDraft(const RecipeDraft());
      expect(errors.title, 'Cần nhập tiêu đề');
      expect(errors.stepRows.keys, [0]);
      expect(errors.totalMinutes, isNull);
      expect(errors.baseServings, isNull);
      expect(errors.isEmpty, isFalse);
    });

    test('a complete draft is valid', () {
      const draft = RecipeDraft(
        title: 'Phở bò',
        steps: [DraftStep(text: 'Hầm xương')],
        ingredients: [DraftIngredient(ingredientId: 'i1', name: 'Xương bò', quantityText: '800', unitText: 'g')],
      );
      expect(validateDraft(draft).isEmpty, isTrue);
    });

    test('flags out-of-range numbers, unpicked ingredients and missing quantities', () {
      const draft = RecipeDraft(
        title: 'x',
        totalMinutes: 0,
        baseServings: 101,
        steps: [],
        ingredients: [
          DraftIngredient(ingredientId: '', name: 'Muối'),
          DraftIngredient(ingredientId: 'i2', name: 'Đường'),
        ],
      );
      final errors = validateDraft(draft);
      expect(errors.totalMinutes, isNotNull);
      expect(errors.baseServings, isNotNull);
      expect(errors.steps, 'Thêm ít nhất một bước');
      expect(errors.ingredientRows[0], 'Chọn một nguyên liệu trong danh sách');
      expect(errors.ingredientRows[1], 'Nhập số lượng');
    });
  });

  group('RecipeDraft.fromRecipe', () {
    test('round-trips steps (seconds to minutes) and keeps photo and source', () {
      final recipe = Recipe(
        id: 'r1',
        title: 'Phở bò',
        baseServings: 4,
        totalMinutes: 180,
        difficulty: 4,
        rarity: Rarity.pink,
        createdAt: DateTime.utc(2026),
        imageUrl: 'https://example.com/pho.jpg',
        sourceUrl: 'https://example.com/recipe',
        tagIds: const [1, 2],
        ingredients: const [
          RecipeIngredient(ingredientId: 'i1', name: 'Xương bò', aisle: 'meat', quantity: 800, unit: 'g'),
          RecipeIngredient(ingredientId: 'i2', name: 'Hành tây', aisle: 'produce', quantity: 1.5, unit: 'piece'),
        ],
        steps: const [RecipeStep(text: 'Chần', timerSeconds: 90, timerLabel: 'chần')],
      );

      final draft = RecipeDraft.fromRecipe(recipe);

      expect(draft.imageUrl, 'https://example.com/pho.jpg');
      expect(draft.sourceUrl, 'https://example.com/recipe');
      expect(draft.tagIds, {1, 2});
      expect(draft.steps.single.timerMinutes, 2, reason: 'sub-minute remainders round up');
      expect(draft.steps.single.timerLabel, 'chần');
      expect(draft.ingredients[0].quantityText, '800');
      expect(draft.ingredients[0].unitText, 'g');
      expect(draft.ingredients[1].quantityText, '1.5');
      expect(draft.ingredients[1].unitText, isEmpty, reason: 'pieces have a blank unit');
    });
  });

  group('formatting', () {
    test('formatMinutes', () {
      expect(formatMinutes(20), '20 phút');
      expect(formatMinutes(180), '3 giờ');
      expect(formatMinutes(90), '1 giờ 30 phút');
    });

    test('formatTimer', () {
      expect(formatTimer(600), '10:00');
      expect(formatTimer(9000), '2:30:00');
    });

    test('quantityLabel trims float noise and omits the unit for pieces', () {
      const grams = RecipeIngredient(ingredientId: 'a', name: 'a', aisle: 'x', quantity: 250.0000001, unit: 'g');
      const pieces = RecipeIngredient(ingredientId: 'b', name: 'b', aisle: 'x', quantity: 2, unit: 'piece');
      const offline = RecipeIngredient(
        ingredientId: 'c',
        name: 'c',
        aisle: 'x',
        quantity: 0,
        unit: 'piece',
        displayQuantity: '1 1/2 thìa',
      );
      expect(grams.quantityLabel, '250 g');
      expect(pieces.quantityLabel, '2');
      expect(offline.quantityLabel, '1 1/2 thìa');
    });

    test('Rarity.fromRecipe mirrors the backend thresholds', () {
      expect(Rarity.fromRecipe(totalMinutes: 20, difficulty: 1), Rarity.white);
      expect(Rarity.fromRecipe(totalMinutes: 20, difficulty: 2), Rarity.blue);
      expect(Rarity.fromRecipe(totalMinutes: 90, difficulty: 3), Rarity.purple);
      expect(Rarity.fromRecipe(totalMinutes: 90, difficulty: 5), Rarity.pink);
      expect(Rarity.fromRecipe(totalMinutes: 181, difficulty: 1), Rarity.red);
    });
  });
}
