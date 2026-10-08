import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/grocery/data/grocery_providers.dart';
import 'package:fooddrop/features/grocery/domain/grocery_aggregation.dart';
import 'package:fooddrop/features/grocery/presentation/grocery_screen.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';

import '../../../support/pump_app.dart';

class _RecordingGrocery extends GroceryActions {
  _RecordingGrocery(super.ref, this.log);

  final List<String> log;

  @override
  Future<void> setServings(String recipeId, int servings) async => log.add('servings $recipeId $servings');

  @override
  Future<void> removeRecipe(String recipeId) async => log.add('remove $recipeId');

  @override
  Future<void> toggleChecked(String itemKey) async => log.add('toggle $itemKey');

  @override
  Future<void> uncheckAll() async => log.add('uncheckAll');

  @override
  Future<void> clearAll() async => log.add('clearAll');
}

Recipe _recipe(String id, String title, List<RecipeIngredient> ingredients) => Recipe(
      id: id,
      title: title,
      baseServings: 2,
      totalMinutes: 30,
      difficulty: 1,
      rarity: Rarity.white,
      createdAt: DateTime.utc(2026),
      ingredients: ingredients,
    );

final _soup = _recipe('r1', 'Canh cà chua', const [
  RecipeIngredient(ingredientId: 'tomato', name: 'Cà chua', aisle: 'produce', baseQuantity: 200, baseUnit: 'g'),
  RecipeIngredient(ingredientId: 'egg', name: 'Trứng gà', aisle: 'dairy', baseQuantity: 2, baseUnit: 'piece'),
]);
final _salad = _recipe('r2', 'Salad', const [
  RecipeIngredient(ingredientId: 'tomato', name: 'Cà chua', aisle: 'produce', baseQuantity: 100, baseUnit: 'g'),
]);

void main() {
  late List<String> log;
  late List<String> shared;

  setUp(() {
    log = [];
    shared = [];
  });

  Future<void> openGrocery(
    WidgetTester tester, {
    List<GrocerySelection> selections = const [],
    Set<String> checked = const {},
  }) =>
      pumpRoutes(
        tester,
        overrides: <Override>[
          grocerySelectionsProvider.overrideWith((ref) => Stream.value(selections)),
          groceryCheckedProvider.overrideWith((ref) => Stream.value(checked)),
          recipesProvider.overrideWith((ref) => Stream.value([_soup, _salad])),
          groceryActionsProvider.overrideWith((ref) => _RecordingGrocery(ref, log)),
          shareTextProvider.overrideWithValue((text) async => shared.add(text)),
        ],
        routes: [homeRoute(const GroceryScreen())],
      );

  testWidgets('an empty list points at the recipes', (tester) async {
    await openGrocery(tester);
    expect(find.text('Chưa có món nào'), findsOneWidget);
  });

  testWidgets('merges the same ingredient across recipes, grouped by aisle', (tester) async {
    await openGrocery(tester, selections: const [
      GrocerySelection(recipeId: 'r1', servings: 2),
      GrocerySelection(recipeId: 'r2', servings: 4),
    ]);

    expect(find.text('RAU CỦ QUẢ'), findsOneWidget);
    expect(find.text('TRỨNG & SỮA'), findsOneWidget);
    expect(find.text('Cà chua: 400 g'), findsOneWidget, reason: '200 + 100 x 4/2');
    expect(find.text('Trứng gà: 2'), findsOneWidget);
    expect(find.text('Canh cà chua'), findsOneWidget);
    expect(find.text('Salad'), findsOneWidget);
  });

  testWidgets('ticking, servings and removing go through the actions', (tester) async {
    await openGrocery(tester, selections: const [GrocerySelection(recipeId: 'r1', servings: 2)], checked: const {'egg|piece'});

    expect(tester.widget<CheckboxListTile>(find.widgetWithText(CheckboxListTile, 'Trứng gà: 2')).value, isTrue);
    await tester.tap(find.text('Cà chua: 200 g'));
    await tester.tap(find.byTooltip('Tăng khẩu phần'));
    await tester.tap(find.byTooltip('Bỏ Canh cà chua khỏi danh sách'));
    await tester.pump();

    expect(log, ['toggle tomato|g', 'servings r1 3', 'remove r1']);
  });

  testWidgets('share sends only what is still to buy', (tester) async {
    await openGrocery(tester, selections: const [GrocerySelection(recipeId: 'r1', servings: 2)], checked: const {'egg|piece'});

    await tester.tap(find.byTooltip('Chia sẻ danh sách'));
    await tester.pump();

    expect(shared.single, 'Danh sách đi chợ\n\nRau củ quả\n- Cà chua: 200 g');
  });

  testWidgets('clearing the list asks first', (tester) async {
    await openGrocery(tester, selections: const [GrocerySelection(recipeId: 'r1', servings: 2)]);

    await tester.tap(find.byTooltip('Thêm tùy chọn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa danh sách'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(log, isEmpty);

    await tester.tap(find.byTooltip('Thêm tùy chọn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa danh sách'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Xóa'));
    await tester.pumpAndSettle();
    expect(log, ['clearAll']);
  });
}
