import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/parser/data/parse_job_mapper.dart';
import 'package:fooddrop/features/parser/data/parser_providers.dart';
import 'package:fooddrop/features/recipes/data/ingredient_catalog.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/presentation/form/recipe_form_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../support/fake_recipe_remote.dart';
import '../../../support/parser_fixtures.dart';
import '../../../support/pump_app.dart';

/// Catalog stand-in that records what the form asks it to create.
class _FakeCatalog implements IngredientCatalog {
  _FakeCatalog({this.fail = false});

  final bool fail;
  final created = <String>[];

  @override
  Future<IngredientOption> ensure(String name, {String defaultUnit = 'g'}) async {
    if (fail) throw dioError(DioExceptionType.connectionError);
    created.add('$name:$defaultUnit');
    return IngredientOption(id: 'new-1', name: 'Trứng cút', aisle: 'other');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<dynamic> openForm(WidgetTester tester, _FakeCatalog catalog) async {
    final container = await pumpRoutes(
      tester,
      overrides: [
        ingredientCatalogProvider.overrideWithValue(catalog),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const [])),
      ],
      routes: [
        homeThatOpens('/new'),
        GoRoute(path: '/new', builder: (context, state) => const RecipeFormScreen()),
      ],
    );
    container.read(importedDraftProvider.notifier).set(draftFromParseResult(parseResult()));
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('a new recipe starts from the imported draft, then clears it', (tester) async {
    final container = await openForm(tester, _FakeCatalog());

    expect(find.widgetWithText(TextFormField, 'Thịt kho trứng'), findsOneWidget);
    expect(find.text('Thịt ba chỉ'), findsOneWidget);
    expect(find.text('trứng cút'), findsOneWidget);
    expect(container.read(importedDraftProvider), isNull, reason: 'the next plain "new recipe" must start empty');
  });

  testWidgets('unmatched ingredients can be added to the catalog in one tap', (tester) async {
    final catalog = _FakeCatalog();
    await openForm(tester, catalog);

    expect(find.textContaining('1 nguyên liệu chưa có trong danh mục'), findsOneWidget);
    await tester.tap(find.text('Thêm 1 nguyên liệu mới vào danh mục'));
    await tester.pumpAndSettle();

    // Blank unit text in the draft means counted pieces.
    expect(catalog.created, ['trứng cút:piece']);
    expect(find.textContaining('chưa có trong danh mục'), findsNothing);
    expect(find.text('Trứng cút'), findsOneWidget);
  });

  testWidgets('a failed catalog add keeps the banner and explains', (tester) async {
    await openForm(tester, _FakeCatalog(fail: true));

    await tester.tap(find.text('Thêm 1 nguyên liệu mới vào danh mục'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Không thêm được một số nguyên liệu'), findsOneWidget);
    expect(find.textContaining('1 nguyên liệu chưa có trong danh mục'), findsOneWidget);
  });
}
