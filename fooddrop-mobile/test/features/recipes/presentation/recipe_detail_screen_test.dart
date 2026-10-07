import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop/features/recipes/presentation/detail/recipe_detail_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../support/pump_app.dart';

class _RecordingActions extends RecipeActions {
  _RecordingActions(super.ref, this.deleted);

  final List<String> deleted;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  Future<void> refreshDetail(String id) async {}

  @override
  Future<String> save(RecipeDraft draft, {String? id}) async => id ?? '';
}

Recipe _pho({bool withDetail = true}) => Recipe(
      id: 'r1',
      title: 'Phở bò',
      description: 'Món nước quen thuộc',
      baseServings: 4,
      totalMinutes: 180,
      difficulty: 4,
      rarity: Rarity.pink,
      createdAt: DateTime.utc(2026),
      tagIds: const [10],
      ingredients: const [
        RecipeIngredient(ingredientId: 'i1', name: 'Xương bò', aisle: 'meat', quantity: 800, unit: 'g'),
        RecipeIngredient(ingredientId: 'i2', name: 'Hành tây', aisle: 'produce', quantity: 2, unit: 'piece', note: 'nướng'),
      ],
      steps: withDetail
          ? const [
              RecipeStep(text: 'Chần xương bò trong nước sôi.', timerSeconds: 600),
              RecipeStep(text: 'Hầm xương.', timerSeconds: 9000),
              RecipeStep(text: 'Chan nước dùng lên bánh phở.'),
            ]
          : null,
    );

void main() {
  late List<String> deleted;

  setUp(() => deleted = []);

  Future<void> openDetail(WidgetTester tester, Stream<Recipe?> recipe) => pumpRoutes(
        tester,
        overrides: <Override>[
          recipeProvider('r1').overrideWith((ref) => recipe),
          tagGroupsProvider.overrideWith(
            (ref) => Stream.value(const [
              TagGroup(id: 1, slug: 'cuisine', label: 'Ẩm thực', tags: [
                Tag(id: 10, dimensionId: 1, slug: 'vietnamese', label: 'Việt Nam'),
              ]),
            ]),
          ),
          recipeActionsProvider.overrideWith((ref) => _RecordingActions(ref, deleted)),
        ],
        routes: [
          homeThatOpens('/recipes/r1'),
          GoRoute(path: '/recipes/:id', builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!)),
          GoRoute(path: '/recipes', builder: (context, state) => const Scaffold(body: Text('danh sách'))),
        ],
      ).then((_) async {
        await tester.tap(find.text('mở'));
        await tester.pumpAndSettle();
      });

  testWidgets('shows facts, tags, ingredients with units, steps and timers', (tester) async {
    await openDetail(tester, Stream.value(_pho()));

    expect(find.text('Phở bò'), findsOneWidget);
    expect(find.text('Sử thi'), findsOneWidget);
    expect(find.text('3 giờ'), findsOneWidget);
    expect(find.text('4 / 5'), findsOneWidget);
    expect(find.text('Việt Nam'), findsOneWidget);
    expect(find.text('800 g'), findsOneWidget);
    expect(find.text('Hành tây · nướng'), findsOneWidget);
    expect(find.text('Chần xương bò trong nước sôi.'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('2:30:00'), findsOneWidget);
  });

  testWidgets('a recipe whose steps were never downloaded explains why and blocks editing', (tester) async {
    await openDetail(tester, Stream.value(_pho(withDetail: false)));

    expect(find.textContaining('Đang tải cách làm'), findsOneWidget);
    expect(find.text('Cách làm'), findsNothing);
    final edit = tester.widget<InkWell>(find.descendant(of: find.widgetWithText(Material, 'Sửa công thức'), matching: find.byType(InkWell)).first);
    expect(edit.onTap, isNull);
  });

  testWidgets('deleting asks first, then removes the recipe and leaves the screen', (tester) async {
    await openDetail(tester, Stream.value(_pho()));

    await tester.tap(find.byTooltip('Xóa công thức'));
    await tester.pumpAndSettle();
    expect(find.text('Xóa công thức?'), findsOneWidget);

    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(deleted, isEmpty);

    await tester.tap(find.byTooltip('Xóa công thức'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Xóa'));
    await tester.pumpAndSettle();

    expect(deleted, ['r1']);
    expect(find.text('mở'), findsOneWidget, reason: 'popped back');
  });

  testWidgets('a missing recipe shows a way back instead of crashing', (tester) async {
    await openDetail(tester, Stream.value(null));

    expect(find.text('Công thức này không còn nữa.'), findsOneWidget);
    await tester.tap(find.text('Về danh sách'));
    await tester.pumpAndSettle();
    expect(find.text('danh sách'), findsOneWidget);
  });
}
