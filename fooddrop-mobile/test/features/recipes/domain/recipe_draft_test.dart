import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft_validation.dart';

import '../../../support/recipe_fixtures.dart';

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
        ingredients: [DraftIngredient(ingredientId: 'i1', name: 'Xương bò', quantityText: '800', unitCode: 'g')],
      );
      expect(validateDraft(draft).isEmpty, isTrue);
    });

    test('quantity and unit are optional ("muối, tùy khẩu vị")', () {
      const draft = RecipeDraft(
        title: 'Canh',
        steps: [DraftStep(text: 'Nấu')],
        ingredients: [DraftIngredient(ingredientId: 'i1', name: 'Muối', note: 'tùy khẩu vị')],
      );
      expect(validateDraft(draft).isEmpty, isTrue);
    });

    test('flags out-of-range numbers and unpicked ingredients', () {
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
      expect(errors.ingredientRows.containsKey(1), isFalse, reason: 'a picked ingredient needs no quantity');
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
          RecipeIngredient(ingredientId: 'i1', name: 'Xương bò', aisle: 'meat', quantity: 800, unit: gramUnit),
          RecipeIngredient(ingredientId: 'i2', name: 'Hành tây', aisle: 'produce', quantity: 1.5),
          RecipeIngredient(ingredientId: 'i3', name: 'Muối', aisle: 'spices'),
        ],
        steps: const [
          RecipeStep(
            name: 'Sơ chế',
            text: 'Chần',
            images: [RecipeStepImage(key: 'recipes/u1/a.jpg', url: 'https://cdn.example/a.jpg')],
            timerSeconds: 90,
            timerLabel: 'chần',
          ),
        ],
      );

      final draft = RecipeDraft.fromRecipe(recipe);

      expect(draft.imageUrl, 'https://example.com/pho.jpg');
      expect(draft.sourceUrl, 'https://example.com/recipe');
      expect(draft.tagIds, {1, 2});
      expect(draft.steps.single.timerMinutes, 2, reason: 'sub-minute remainders round up');
      expect(draft.steps.single.timerLabel, 'chần');
      expect(draft.ingredients[0].quantityText, '800');
      expect(draft.ingredients[0].unitCode, 'g');
      expect(draft.ingredients[1].quantityText, '1.5');
      expect(draft.ingredients[1].unitCode, isEmpty, reason: 'a bare count has no unit');
      expect(draft.ingredients[2].quantityText, isEmpty, reason: 'no quantity stays empty');
      expect(draft.steps.single.name, 'Sơ chế');
      expect(draft.steps.single.images.single.key, 'recipes/u1/a.jpg');
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

    test('quantityLabel writes the unit the cook chose and trims float noise', () {
      const grams = RecipeIngredient(ingredientId: 'a', name: 'a', aisle: 'x', quantity: 250.0000001, unit: gramUnit);
      const spoons = RecipeIngredient(ingredientId: 'b', name: 'b', aisle: 'x', quantity: 2, unit: tbspUnit);
      const bare = RecipeIngredient(ingredientId: 'c', name: 'c', aisle: 'x', quantity: 2);
      const none = RecipeIngredient(ingredientId: 'd', name: 'd', aisle: 'x');
      const offline = RecipeIngredient(ingredientId: 'e', name: 'e', aisle: 'x', unit: tbspUnit, displayQuantity: '1 1/2');
      expect(grams.quantityLabel, '250 g');
      expect(spoons.quantityLabel, '2 thìa canh');
      expect(bare.quantityLabel, '2');
      expect(none.quantityLabel, isEmpty);
      expect(offline.quantityLabel, '1 1/2 thìa canh');
    });

    test('scaledLabel keeps the unit, rounds by it, and leaves absent quantities blank', () {
      const spoons = RecipeIngredient(ingredientId: 'b', name: 'b', aisle: 'x', quantity: 1, unit: tbspUnit);
      const none = RecipeIngredient(ingredientId: 'd', name: 'd', aisle: 'x');
      expect(spoons.scaledLabel(3, 2), '1.5 thìa canh');
      expect(spoons.scaledLabel(2, 2), '1 thìa canh');
      expect(none.scaledLabel(3, 2), isEmpty);
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
