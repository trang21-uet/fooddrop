import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/gacha/data/gacha_providers.dart';
import 'package:fooddrop/features/gacha/domain/gacha_case.dart';
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

  setUp(() => remote = FakeGachaRemote()..caseList = fakeGachaCases({GachaCaseId.all: 5, GachaCaseId.quick: 2}));

  testWidgets('lists every case and opens the selected one', (tester) async {
    await pumpPicker(tester);
    for (final name in ['Hòm Tổng hợp', 'Hòm Bữa sáng', 'Hòm Bữa trưa', 'Hòm Bữa tối', 'Hòm Nhanh gọn', 'Hòm Cầu kỳ']) {
      expect(find.text(name), findsWidgets);
    }
    expect(find.text('Mở Hòm Tổng hợp'), findsOneWidget);

    await tester.tap(find.text('Hòm Nhanh gọn').first);
    await tester.pump();
    expect(find.text('2 công thức'), findsWidgets);
    await tester.tap(find.text('Mở Hòm Nhanh gọn'));
    await tester.pumpAndSettle();
    expect(find.text('reel quick'), findsOneWidget);
  });

  testWidgets('an empty case cannot be opened', (tester) async {
    await pumpPicker(tester);
    await tester.tap(find.text('Hòm Bữa sáng').first);
    await tester.pump();
    expect(find.textContaining('Hòm này chưa có món nào'), findsOneWidget);
    await tester.tap(find.text('Mở Hòm Bữa sáng'));
    await tester.pumpAndSettle();
    expect(find.textContaining('reel'), findsNothing);
  });
}
