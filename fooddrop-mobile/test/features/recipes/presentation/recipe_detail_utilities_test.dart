import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/grocery/data/grocery_providers.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/presentation/detail/recipe_detail_screen.dart';
import 'package:fooddrop/features/timers/data/timer_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../support/pump_app.dart';
import '../../../support/recipe_fixtures.dart';

class _RecordingGrocery extends GroceryActions {
  _RecordingGrocery(super.ref, this.added);

  final List<(String, int)> added;

  @override
  Future<void> addRecipe(String recipeId, int servings) async => added.add((recipeId, servings));
}

class _RecordingTimers extends TimerActions {
  _RecordingTimers(super.ref, this.started);

  final List<(String, Duration)> started;

  @override
  Future<void> start(String label, Duration duration) async => started.add((label, duration));
}

final _pho = Recipe(
  id: 'r1',
  title: 'Phở bò',
  baseServings: 4,
  totalMinutes: 180,
  difficulty: 4,
  rarity: Rarity.pink,
  createdAt: DateTime.utc(2026),
  ingredients: [
    RecipeIngredient(ingredientId: 'i1', name: 'Xương bò', aisle: 'meat', quantity: 800, unit: gramUnit),
    RecipeIngredient(ingredientId: 'i2', name: 'Hành tây', aisle: 'produce', quantity: 2),
    RecipeIngredient(ingredientId: 'i3', name: 'Nước mắm', aisle: 'pantry', unit: tbspUnit, displayQuantity: '2'),
    RecipeIngredient(ingredientId: 'i4', name: 'Muối', aisle: 'spices', note: 'tùy khẩu vị'),
  ],
  steps: [
    RecipeStep(text: 'Chần xương bò.', timerSeconds: 600),
    RecipeStep(text: 'Hầm xương.', timerSeconds: 9000, timerLabel: 'Hầm xương'),
  ],
);

void main() {
  late List<(String, int)> groceryAdds;
  late List<(String, Duration)> timersStarted;

  setUp(() {
    groceryAdds = [];
    timersStarted = [];
  });

  Future<void> openDetail(WidgetTester tester) async {
    await pumpRoutes(
      tester,
      overrides: <Override>[
        recipeProvider('r1').overrideWith((ref) => Stream.value(_pho)),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const <TagGroup>[])),
        recipeActionsProvider.overrideWith((ref) => _NoRefresh(ref)),
        groceryActionsProvider.overrideWith((ref) => _RecordingGrocery(ref, groceryAdds)),
        timerActionsProvider.overrideWith((ref) => _RecordingTimers(ref, timersStarted)),
      ],
      routes: [
        homeThatOpens('/recipes/r1'),
        GoRoute(path: '/recipes/:id', builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!)),
        GoRoute(path: '/grocery', builder: (context, state) => const Scaffold(body: Text('trang đi chợ'))),
        GoRoute(path: '/timers', builder: (context, state) => const Scaffold(body: Text('trang hẹn giờ'))),
      ],
    );
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();
  }

  testWidgets('the servings stepper scales ingredients live and rounds scaled amounts', (tester) async {
    await openDetail(tester);
    expect(find.text('800 g'), findsOneWidget);
    expect(find.text('2'), findsWidgets);

    await tester.tap(find.byTooltip('Tăng khẩu phần'));
    await tester.pump();
    expect(find.text('1000 g'), findsOneWidget, reason: '800 x 5/4');
    expect(find.text('2.5'), findsOneWidget, reason: '2 pieces x 5/4');
    expect(find.text('2 thìa canh'), findsOneWidget, reason: 'raw offline text cannot be scaled');

    await tester.tap(find.byTooltip('Giảm khẩu phần'));
    await tester.pump();
    await tester.tap(find.byTooltip('Giảm khẩu phần'));
    await tester.pump();
    expect(find.text('600 g'), findsOneWidget, reason: '800 x 3/4');
    expect(find.text('1.5'), findsOneWidget);
  });

  testWidgets('the add button hands the recipe and chosen servings to the grocery list', (tester) async {
    await openDetail(tester);

    await tester.tap(find.byTooltip('Tăng khẩu phần'));
    await tester.pump();
    await tester.ensureVisible(find.text('Thêm vào đi chợ'));
    await tester.tap(find.text('Thêm vào đi chợ'));
    await tester.pumpAndSettle();

    expect(groceryAdds, [('r1', 5)]);
    expect(find.text('Đã thêm vào danh sách đi chợ'), findsOneWidget);

    await tester.tap(find.text('Xem'));
    await tester.pumpAndSettle();
    expect(find.text('trang đi chợ'), findsOneWidget);
  });

  testWidgets('a step timer starts prefilled from the step', (tester) async {
    await openDetail(tester);

    await tester.ensureVisible(find.text('10:00'));
    await tester.tap(find.text('10:00'));
    await tester.pumpAndSettle();
    expect(timersStarted.single, ('Phở bò · bước 1', const Duration(minutes: 10)));
    expect(find.text('Đã bắt đầu hẹn giờ'), findsOneWidget);

    await tester.ensureVisible(find.text('2:30:00'));
    await tester.tap(find.text('2:30:00'));
    await tester.pumpAndSettle();
    expect(timersStarted.last, ('Hầm xương', const Duration(hours: 2, minutes: 30)));
  });
}

class _NoRefresh extends RecipeActions {
  _NoRefresh(super.ref);

  @override
  Future<void> refreshDetail(String id) async {}
}
