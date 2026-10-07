import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/grocery/domain/grocery_aggregation.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';

Recipe _recipe(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      baseServings: json['baseServings'] as int,
      totalMinutes: 30,
      difficulty: 1,
      rarity: Rarity.white,
      createdAt: DateTime.utc(2026),
      ingredients: [
        for (final i in (json['ingredients'] as List).cast<Map<String, dynamic>>())
          RecipeIngredient(
            ingredientId: i['ingredientId'] as String,
            name: i['name'] as String,
            aisle: i['aisle'] as String,
            quantity: (i['quantity'] as num).toDouble(),
            unit: i['unit'] as String,
          ),
      ],
    );

void main() {
  // Vectors shared with the web app; flutter test runs from the fooddrop-mobile folder.
  final file = jsonDecode(File('../docs/fixtures/grocery-aggregation-cases.json').readAsStringSync()) as Map<String, dynamic>;

  group('aggregateGrocery (shared vectors)', () {
    for (final c in (file['cases'] as List).cast<Map<String, dynamic>>()) {
      test(c['name'] as String, () {
        final selections = [
          for (final s in (c['selections'] as List).cast<Map<String, dynamic>>())
            GrocerySelection(recipeId: s['recipeId'] as String, servings: s['servings'] as int),
        ];
        final recipes = {
          for (final r in (c['recipes'] as List).cast<Map<String, dynamic>>()) r['id'] as String: _recipe(r),
        };

        final actual = [
          for (final group in aggregateGrocery(selections, recipes))
            {
              'aisle': group.aisle,
              'items': [
                for (final item in group.items)
                  {'ingredientId': item.ingredientId, 'name': item.name, 'unit': item.unit, 'quantity': item.quantity},
              ],
            },
        ];
        // Round-trip through JSON so 550 and 550.0 compare equal, like the web test.
        final expected = jsonDecode(jsonEncode(c['expected']));
        expect(jsonDecode(jsonEncode(actual)), expected);
      });
    }
  });

  group('groceryShareText', () {
    const groups = [
      GroceryAisleGroup(aisle: 'produce', items: [
        GroceryItem(ingredientId: 'tomato', name: 'Cà chua', unit: 'g', quantity: 550),
        GroceryItem(ingredientId: 'chili', name: 'Ớt', unit: 'g', quantity: 0),
      ]),
      GroceryAisleGroup(aisle: 'dairy', items: [GroceryItem(ingredientId: 'egg', name: 'Trứng gà', unit: 'piece', quantity: 2)]),
    ];

    test('lists unticked items grouped by aisle', () {
      expect(
        groceryShareText(groups, {}),
        'Danh sách đi chợ\n\nRau củ quả\n- Cà chua: 550 g\n- Ớt\n\nTrứng & sữa\n- Trứng gà: 2',
      );
    });

    test('drops ticked items and empty aisles', () {
      expect(groceryShareText(groups, {'tomato|g', 'chili|g'}), 'Danh sách đi chợ\n\nTrứng & sữa\n- Trứng gà: 2');
    });

    test('says so when everything is bought', () {
      expect(groceryShareText(groups, {'tomato|g', 'chili|g', 'egg|piece'}), 'Danh sách đi chợ\n\nĐã mua đủ.');
    });
  });
}
