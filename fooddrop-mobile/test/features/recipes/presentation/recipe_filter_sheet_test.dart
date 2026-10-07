import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/presentation/list/recipe_filter_sheet.dart';
import 'package:fooddrop/features/recipes/presentation/list/recipe_filters_controller.dart';
import 'package:go_router/go_router.dart';

import '../../../support/pump_app.dart';
import '../../../support/recipe_fixtures.dart';

const _groups = [
  TagGroup(id: 1, slug: 'cuisine', label: 'Ẩm thực', tags: [
    Tag(id: 10, dimensionId: 1, slug: 'vietnamese', label: 'Việt Nam'),
    Tag(id: 11, dimensionId: 1, slug: 'japanese', label: 'Nhật Bản'),
  ]),
  TagGroup(id: 2, slug: 'equipment', label: 'Dụng cụ', tags: [
    Tag(id: 20, dimensionId: 2, slug: 'oven', label: 'Lò nướng'),
  ]),
];

void main() {
  final recipes = [
    domainRecipe(id: 'pho', title: 'Phở bò', tagIds: [10]),
    domainRecipe(id: 'katsu', title: 'Cà ri katsu', totalMinutes: 25, tagIds: [11, 20], rarity: Rarity.blue),
  ];

  testWidgets('shows tags grouped by dimension and filters the list as chips are tapped', (tester) async {
    final container = await pumpRoutes(
      tester,
      overrides: [
        tagGroupsProvider.overrideWith((ref) => Stream.value(_groups)),
        recipesProvider.overrideWith((ref) => Stream.value(recipes)),
      ],
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Builder(
              builder: (context) => TextButton(onPressed: () => showRecipeFilterSheet(context), child: const Text('mở lọc')),
            ),
          ),
        ),
      ],
    );
    // The sheet only watches tags; keep the derived list alive so its values can be read below.
    container.listen(filteredRecipesProvider, (_, _) {});
    await container.read(recipesProvider.future);
    await tester.tap(find.text('mở lọc'));
    await tester.pumpAndSettle();

    expect(find.text('ẨM THỰC'), findsOneWidget);
    expect(find.text('DỤNG CỤ'), findsOneWidget);
    expect(find.text('Việt Nam'), findsOneWidget);

    await tester.tap(find.text('Nhật Bản'));
    await tester.pump();
    expect(container.read(recipeFiltersControllerProvider).tagIds, {11});
    expect(container.read(filteredRecipesProvider).map((r) => r.id), ['katsu']);

    await tester.tap(find.text('Lò nướng'));
    await tester.pump();
    expect(container.read(filteredRecipesProvider).map((r) => r.id), ['katsu'], reason: 'AND across dimensions');

    await tester.tap(find.text('Việt Nam'));
    await tester.pump();
    expect(container.read(filteredRecipesProvider).map((r) => r.id), ['katsu'],
        reason: 'OR within cuisine, still AND with equipment');

    await tester.tap(find.text('≤ 15 phút'));
    await tester.pump();
    expect(container.read(filteredRecipesProvider), isEmpty);

    await tester.tap(find.text('Xóa lọc'));
    await tester.pump();
    expect(container.read(recipeFiltersControllerProvider).sheetFilterCount, 0);
    expect(container.read(filteredRecipesProvider), hasLength(2));
  });

  testWidgets('tells the user when tags have not been downloaded yet', (tester) async {
    await pumpRoutes(
      tester,
      overrides: [tagGroupsProvider.overrideWith((ref) => Stream.value(const <TagGroup>[]))],
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Builder(
              builder: (context) => TextButton(onPressed: () => showRecipeFilterSheet(context), child: const Text('mở lọc')),
            ),
          ),
        ),
      ],
    );
    await tester.tap(find.text('mở lọc'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Chưa tải được thẻ'), findsOneWidget);
    expect(find.text('≤ 30 phút'), findsOneWidget, reason: 'max-time filter works without tags');
  });
}
