import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop/features/recipes/presentation/form/recipe_form_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../support/pump_app.dart';
import '../../../support/recipe_fixtures.dart';

final _stepFields = find.byWidgetPredicate((widget) {
  final key = widget.key;
  return widget is TextFormField && key is ValueKey && key.value.toString().startsWith('step-text-');
});

typedef _Saved = ({RecipeDraft draft, String? id});

class _RecordingActions extends RecipeActions {
  _RecordingActions(super.ref, this.saved);

  final List<_Saved> saved;

  @override
  Future<String> save(RecipeDraft draft, {String? id}) async {
    saved.add((draft: draft, id: id));
    return id ?? 'local-new';
  }
}

void main() {
  late List<_Saved> saved;

  setUp(() => saved = []);

  Future<void> openNewForm(WidgetTester tester, {List<Override> overrides = const []}) async {
    await pumpRoutes(
      tester,
      overrides: [
        recipeActionsProvider.overrideWith((ref) => _RecordingActions(ref, saved)),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const [])),
        ...overrides,
      ],
      routes: [
        homeThatOpens('/new'),
        GoRoute(path: '/new', builder: (context, state) => const RecipeFormScreen()),
      ],
    );
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();
  }

  testWidgets('submitting an empty form shows what is missing and saves nothing', (tester) async {
    await openNewForm(tester);

    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    expect(find.text('Cần nhập tiêu đề'), findsOneWidget);
    expect(find.text('Hãy mô tả bước này'), findsOneWidget);
    expect(find.textContaining('Còn trường chưa hợp lệ'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('errors clear as soon as the field is fixed', (tester) async {
    await openNewForm(tester);
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');
    await tester.pump();

    expect(find.text('Cần nhập tiêu đề'), findsNothing);
    expect(find.text('Hãy mô tả bước này'), findsOneWidget, reason: 'the step is still empty');
  });

  testWidgets('rejects an out-of-range time and servings', (tester) async {
    await openNewForm(tester);
    await tester.enterText(find.byKey(const ValueKey('recipe-minutes')), '0');
    await tester.enterText(find.byKey(const ValueKey('recipe-servings')), '');
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    expect(find.text('Nhập từ 1 đến 10080 phút'), findsOneWidget);
    expect(find.text('Nhập từ 1 đến 100 khẩu phần'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('a valid form is saved once and returns to the previous screen', (tester) async {
    await openNewForm(tester);

    await tester.enterText(find.byKey(const ValueKey('recipe-title')), '  Bún chả  ');
    await tester.enterText(_stepFields, 'Nướng thịt');
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    expect(saved, hasLength(1));
    final only = saved.single;
    expect(only.id, isNull, reason: 'creating, not editing');
    expect(only.draft.title, '  Bún chả  ', reason: 'trimming happens when mapping to the API input');
    expect(only.draft.difficulty, 4);
    expect(only.draft.steps.single.text, 'Nướng thịt');
    expect(find.text('mở'), findsOneWidget, reason: 'popped back to the home page');
  });

  testWidgets('steps can be added, reordered and removed', (tester) async {
    await openNewForm(tester);

    await tester.tap(find.text('Thêm bước'));
    await tester.pumpAndSettle();
    expect(_stepFields, findsNWidgets(2));
    await tester.enterText(_stepFields.at(0), 'Một');
    await tester.enterText(_stepFields.at(1), 'Hai');

    await tester.tap(find.byTooltip('Chuyển bước 1 xuống'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(_stepFields.first).initialValue, 'Hai');

    await tester.tap(find.byTooltip('Xóa bước 1'));
    await tester.pumpAndSettle();
    expect(_stepFields, findsOneWidget);
  });

  testWidgets('editing starts from the stored recipe and saves under its id', (tester) async {
    final recipe = domainRecipe(id: 'r1', title: 'Phở bò', steps: ['Hầm xương']);
    await pumpRoutes(
      tester,
      overrides: [
        recipeActionsProvider.overrideWith((ref) => _RecordingActions(ref, saved)),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const [])),
        recipeProvider('r1').overrideWith((ref) => Stream.value(recipe)),
      ],
      routes: [
        homeThatOpens('/edit'),
        GoRoute(path: '/edit', builder: (context, state) => const RecipeFormScreen(recipeId: 'r1')),
      ],
    );
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();

    expect(find.text('Sửa công thức'), findsWidgets);
    expect(tester.widget<TextFormField>(find.byKey(const ValueKey('recipe-title'))).initialValue, 'Phở bò');
    expect(tester.widget<TextFormField>(_stepFields).initialValue, 'Hầm xương');

    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();
    expect(saved.single.id, 'r1');
  });
}
