import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/gacha/data/gacha_providers.dart';
import 'package:fooddrop/features/gacha/presentation/case_select_screen.dart';
import 'package:go_router/go_router.dart';

import '../../support/gacha_fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeGachaRemote remote;

  Future<void> pumpPicker(WidgetTester tester) => pumpRoutes(
        tester,
        routes: [
          homeRoute(const CaseSelectScreen()),
          GoRoute(path: '/drop/:caseId', builder: (context, state) => Text('reel ${state.pathParameters['caseId']}')),
        ],
        overrides: [gachaRemoteProvider.overrideWithValue(remote)],
      );

  setUp(() => remote = FakeGachaRemote()..caseList = fakeGachaCases({'all': 5, 'quick': 2, 'meal_type.dinner': 3}));

  testWidgets('shows the featured tab first and opens the selected case', (tester) async {
    await pumpPicker(tester);
    for (final name in ['Hòm Tổng hợp', 'Hòm Nhanh gọn', 'Hòm Cầu kỳ']) {
      expect(find.text(name), findsWidgets);
    }
    expect(find.text('Hòm Bữa tối'), findsNothing);
    expect(find.text('Mở Hòm Tổng hợp'), findsOneWidget);

    await tester.tap(find.text('Hòm Nhanh gọn').first);
    await tester.pump();
    expect(find.text('2 công thức'), findsWidgets);
    await tester.tap(find.text('Mở Hòm Nhanh gọn'));
    await tester.pumpAndSettle();
    expect(find.text('reel quick'), findsOneWidget);
  });

  testWidgets('a tab lists the tag cases of its dimension', (tester) async {
    await pumpPicker(tester);
    // The tab bar scrolls sideways on a phone.
    await tester.ensureVisible(find.text('Loại món 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loại món 1'));
    await tester.pumpAndSettle();
    expect(find.text('Hòm Tổng hợp'), findsNothing);
    expect(find.text('Mở Hòm Bữa tối'), findsOneWidget);
    await tester.tap(find.text('Mở Hòm Bữa tối'));
    await tester.pumpAndSettle();
    expect(find.text('reel meal_type.dinner'), findsOneWidget);
  });

  testWidgets('an empty tab explains how to fill it', (tester) async {
    await pumpPicker(tester);
    await tester.tap(find.text('Ẩm thực 0'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chưa có công thức nào gắn thẻ ẩm thực'), findsOneWidget);
    expect(find.textContaining('Mở Hòm'), findsNothing);
  });

  testWidgets('an empty case cannot be opened', (tester) async {
    await pumpPicker(tester);
    await tester.tap(find.text('Hòm Cầu kỳ').first);
    await tester.pump();
    expect(find.textContaining('Hòm này chưa có món nào'), findsOneWidget);
    await tester.tap(find.text('Mở Hòm Cầu kỳ'));
    await tester.pumpAndSettle();
    expect(find.textContaining('reel'), findsNothing);
  });
}
