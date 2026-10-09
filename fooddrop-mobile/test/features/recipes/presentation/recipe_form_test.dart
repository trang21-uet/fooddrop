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

final _noteFields = find.byWidgetPredicate((widget) {
  final key = widget.key;
  return widget is TextFormField && key is ValueKey && key.value.toString().startsWith('step-note-');
});

final _timerFields = find.byWidgetPredicate((widget) {
  final key = widget.key;
  return widget is TextFormField && key is ValueKey && key.value.toString().startsWith('step-timer-');
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

  testWidgets('rejects an out-of-range time', (tester) async {
    await openNewForm(tester);
    await tester.enterText(find.byKey(const ValueKey('recipe-minutes')), '0');
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    expect(find.text('Nhập từ 1 đến 10080 phút'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('servings use a stepper that never goes below one', (tester) async {
    await openNewForm(tester);
    expect(find.text('2 người'), findsOneWidget);

    await tester.tap(find.byTooltip('Tăng khẩu phần'));
    await tester.pump();
    expect(find.text('3 người'), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('Giảm khẩu phần'));
      await tester.pump();
    }
    expect(find.text('1 người'), findsOneWidget);
  });

  testWidgets('cancel leaves without saving', (tester) async {
    await openNewForm(tester);
    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');

    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();

    expect(saved, isEmpty);
    expect(find.text('mở'), findsOneWidget);
  });

  testWidgets('a step keeps its note and an optional timer', (tester) async {
    await openNewForm(tester);
    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');
    await tester.enterText(_stepFields, 'Ướp thịt');
    await tester.enterText(_noteFields, 'Ướp ít nhất 20 phút');

    await tester.ensureVisible(find.text('Thêm hẹn giờ'));
    await tester.tap(find.text('Thêm hẹn giờ'));
    await tester.pump();
    expect(find.text('Có hẹn giờ'), findsOneWidget);
    await tester.enterText(_timerFields, '25');

    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    final step = saved.single.draft.steps.single;
    expect(step.note, 'Ướp ít nhất 20 phút');
    expect(step.timerMinutes, 25);
  });

  testWidgets('turning the timer off clears it', (tester) async {
    await openNewForm(tester);
    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');
    await tester.enterText(_stepFields, 'Ướp thịt');
    await tester.ensureVisible(find.text('Thêm hẹn giờ'));
    await tester.tap(find.text('Thêm hẹn giờ'));
    await tester.pump();
    await tester.tap(find.text('Có hẹn giờ'));
    await tester.pump();
    expect(_timerFields, findsNothing);

    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();
    expect(saved.single.draft.steps.single.timerMinutes, isNull);
  });

  testWidgets('a valid form is saved once and returns to the previous screen', (tester) async {
    await openNewForm(tester);

    await tester.enterText(find.byKey(const ValueKey('recipe-title')), '  Bún chả  ');
    await tester.enterText(_stepFields, 'Nướng thịt');
    // The track is inset by the 20px thumb overlay on each side; level 4 sits at 75%.
    final slider = tester.getRect(find.byKey(const ValueKey('recipe-difficulty')));
    await tester.tapAt(Offset(slider.left + 20 + (slider.width - 40) * 0.75, slider.center.dy));
    await tester.pump();
    expect(find.textContaining('4 · Khó', findRichText: true), findsOneWidget);
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
