import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/gacha/data/gacha_providers.dart';
import 'package:fooddrop/features/gacha/domain/gacha_case.dart';
import 'package:fooddrop/features/gacha/domain/reel_geometry.dart';
import 'package:fooddrop/features/gacha/presentation/drop_screen.dart';
import 'package:fooddrop/features/gacha/presentation/reel_card.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';

import '../../support/pump_app.dart';
import '../../support/gacha_fakes.dart';

void main() {
  late FakeGachaRemote remote;
  late FakeReelSounds sounds;

  Future<void> pumpDrop(WidgetTester tester) => pumpRoutes(
        tester,
        routes: [homeRoute(const DropScreen(caseId: GachaCaseId.dinner))],
        overrides: [
          gachaRemoteProvider.overrideWithValue(remote),
          reelSoundPlayerProvider.overrideWithValue(sounds),
        ],
      );

  setUp(() {
    remote = FakeGachaRemote();
    sounds = FakeReelSounds();
  });

  testWidgets('spins to the server result, ticking once per card boundary, then reveals it', (tester) async {
    await pumpDrop(tester);
    expect(find.text('Món đã xóa'), findsOneWidget); // history
    expect(find.text('Phở bò'), findsWidgets); // idle reel shows the case's dishes
    expect(find.text('Hòm Bữa tối · 3 công thức · Đổi hòm'), findsOneWidget);

    await tester.tap(find.text('Mở hộp'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Đang quay…'), findsOneWidget);

    // 120 Hz frames for the 7 s spin.
    for (var elapsed = 0; elapsed < 7100; elapsed += 8) {
      await tester.pump(const Duration(milliseconds: 8));
    }
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // The reel spans the 390 px screen edge to edge.
    const layout = ReelLayout(cardWidth: reelCardWidth, gap: reelCardGap, viewportWidth: 390);
    expect(sounds.ticks, layout.slotUnderMarker(layout.targetOffset(60, 0.2)) - layout.slotUnderMarker(0));
    expect(sounds.reveals, [Rarity.purple]);
    expect(find.text('Bún chả'), findsWidgets);
    expect(find.text('Nấu món này'), findsOneWidget);
    expect(remote.spins, [GachaCaseId.dinner]);

    await tester.tap(find.text('Quay lại lần nữa'));
    await tester.pump();
    await tester.pump();
    expect(remote.spins, hasLength(2));
    expect(find.text('Đang quay…'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('explains an empty pool without spinning', (tester) async {
    final request = RequestOptions(path: '/gacha/spins');
    remote.failure = DioException(
      requestOptions: request,
      response: Response(requestOptions: request, statusCode: 422, data: {'code': 'gacha_empty_pool'}),
      type: DioExceptionType.badResponse,
    );
    await pumpDrop(tester);

    await tester.tap(find.text('Mở hộp'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hòm này chưa có món nào. Chọn hòm khác hoặc'), findsOneWidget);
    expect(find.text('Mở hộp'), findsOneWidget);
    expect(sounds.ticks, 0);
  });

  testWidgets('cannot open an empty case', (tester) async {
    remote.caseList = fakeGachaCases({GachaCaseId.all: 3});
    await pumpDrop(tester);
    expect(find.text('Hòm này chưa có món nào. Chọn hòm khác nhé.'), findsOneWidget);
    await tester.tap(find.text('Mở hộp'));
    await tester.pump();
    expect(remote.spins, isEmpty);
  });

  testWidgets('reduced motion fades straight to the result', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpDrop(tester);

    await tester.tap(find.text('Mở hộp'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump(const Duration(milliseconds: 500));
    expect(sounds.ticks, 0);
    expect(find.text('Nấu món này'), findsOneWidget);
  });
}

