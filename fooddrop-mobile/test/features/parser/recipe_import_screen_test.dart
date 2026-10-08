import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/widgets/neon_button.dart';
import 'package:fooddrop/features/parser/data/parser_providers.dart';
import 'package:fooddrop/features/parser/data/photo_picker.dart';
import 'package:fooddrop/features/parser/presentation/recipe_import_screen.dart';
import 'package:fooddrop/features/timers/data/timer_providers.dart' show nowMsProvider, tickerProvider;
import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:go_router/go_router.dart';

import '../../support/parser_fixtures.dart';
import '../../support/pump_app.dart';

DioException _http(int status, [Object? data]) {
  final options = RequestOptions(path: '/parser/jobs');
  return DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: status, data: data));
}

void main() {
  // `now` and `ticks` stand in for the wall clock and the shared 500 ms ticker (which never settles in tests).
  Future<dynamic> openImport(
    WidgetTester tester, {
    required FakeParserRemote remote,
    PhotoPicker? picker,
    int Function()? now,
    Stream<int>? ticks,
  }) async {
    final container = await pumpRoutes(
      tester,
      overrides: <Override>[
        parserRemoteProvider.overrideWithValue(remote),
        importPollIntervalProvider.overrideWithValue(Duration.zero),
        if (picker != null) photoPickerProvider.overrideWithValue(picker),
        if (now != null) nowMsProvider.overrideWithValue(now),
        if (ticks != null) tickerProvider.overrideWith((ref) => ticks),
      ],
      routes: [
        homeThatOpens('/recipes/import'),
        GoRoute(path: '/recipes/import', builder: (context, state) => const RecipeImportScreen()),
        GoRoute(path: '/recipes/new', builder: (context, state) => const Scaffold(body: Text('form mới'))),
      ],
    );
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('a link import polls until done, stores the draft and opens the form', (tester) async {
    final remote = FakeParserRemote(jobs: [
      parseJob(status: api.ParseJobStatusEnum.queued),
      parseJob(status: api.ParseJobStatusEnum.running),
      parseJob(result: parseResult()),
    ]);
    final container = await openImport(tester, remote: remote);

    await tester.enterText(find.byType(TextField).first, ' https://blog.example/thit-kho ');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(remote.started, ['url:https://blog.example/thit-kho']);
    expect(find.text('form mới'), findsOneWidget);
    expect(container.read(importedDraftProvider)?.title, 'Thịt kho trứng');
  });

  testWidgets('the screen is marked as in development', (tester) async {
    await openImport(tester, remote: FakeParserRemote());
    expect(find.byKey(const Key('in-development-notice')), findsOneWidget);
    expect(find.textContaining('Đang phát triển'), findsOneWidget);
  });

  testWidgets('an empty link starts nothing', (tester) async {
    final remote = FakeParserRemote();
    await openImport(tester, remote: remote);

    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(remote.started, isEmpty);
  });

  testWidgets('a failed job explains why in Vietnamese and stays on the screen', (tester) async {
    final remote = FakeParserRemote(
      jobs: [parseJob(status: api.ParseJobStatusEnum.failed, errorCode: api.ParseJobErrorCodeEnum.fetchFailed)],
    );
    await openImport(tester, remote: remote);

    await tester.enterText(find.byType(TextField).first, 'https://blocked.example/x');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('import-error')), findsOneWidget);
    expect(find.textContaining('Không tải được trang này'), findsOneWidget);
    expect(find.text('form mới'), findsNothing);
  });

  testWidgets('quota errors from starting the job are explained', (tester) async {
    await openImport(tester, remote: FakeParserRemote(startError: _http(429)));

    await tester.enterText(find.byType(TextField).first, 'https://blog.example/x');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(find.textContaining('quá nhiều'), findsOneWidget);
  });

  bool enabled(WidgetTester tester, String label) =>
      tester.widget<NeonButton>(find.widgetWithText(NeonButton, label)).onPressed != null;

  testWidgets('after an import the buttons stay disabled for a minute, then come back', (tester) async {
    var now = 1000000;
    final ticks = StreamController<int>();
    addTearDown(ticks.close);
    final remote = FakeParserRemote(
      jobs: [parseJob(status: api.ParseJobStatusEnum.failed, errorCode: api.ParseJobErrorCodeEnum.fetchFailed)],
    );
    await openImport(tester, remote: remote, now: () => now, ticks: ticks.stream);

    await tester.enterText(find.byType(TextField).first, 'https://blocked.example/x');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('import-cooldown')), findsOneWidget);
    expect(find.textContaining('chờ 60 giây'), findsOneWidget);
    expect(enabled(tester, 'Đọc công thức từ liên kết'), isFalse);
    expect(enabled(tester, 'Chụp ảnh công thức'), isFalse);
    expect(enabled(tester, 'Chọn ảnh từ thư viện'), isFalse);

    now += 20000;
    ticks.add(now);
    await tester.pumpAndSettle();
    expect(find.textContaining('chờ 40 giây'), findsOneWidget);

    now += 40000;
    ticks.add(now);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('import-cooldown')), findsNothing);
    expect(enabled(tester, 'Đọc công thức từ liên kết'), isTrue);
    expect(enabled(tester, 'Chọn ảnh từ thư viện'), isTrue);
    expect(remote.started, ['url:https://blocked.example/x']);
  });

  testWidgets('a 429 with a remaining wait starts the countdown from the server value', (tester) async {
    final remote = FakeParserRemote(
      startError: _http(429, {'statusCode': 429, 'code': 'parse_cooldown', 'message': 'Please wait', 'retryAfterSeconds': 37}),
    );
    await openImport(tester, remote: remote, now: () => 1000000, ticks: const Stream<int>.empty());

    await tester.enterText(find.byType(TextField).first, 'https://blog.example/x');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    // Only the live countdown: no failure line repeating a number that would stop matching it.
    expect(find.byKey(const Key('import-error')), findsNothing);
    expect(find.textContaining('37 giây'), findsOneWidget);
    expect(enabled(tester, 'Đọc công thức từ liên kết'), isFalse);
  });

  testWidgets('the countdown uses the length the server sent with the created job', (tester) async {
    final remote = FakeParserRemote(
      cooldownSeconds: 0,
      jobs: [parseJob(status: api.ParseJobStatusEnum.failed, errorCode: api.ParseJobErrorCodeEnum.fetchFailed)],
    );
    await openImport(tester, remote: remote, now: () => 1000000, ticks: const Stream<int>.empty());

    await tester.enterText(find.byType(TextField).first, 'https://blog.example/x');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('import-cooldown')), findsNothing);
    expect(enabled(tester, 'Đọc công thức từ liên kết'), isTrue);
  });

  testWidgets('a failure to start the job does not start a cooldown', (tester) async {
    await openImport(tester, remote: FakeParserRemote(startError: _http(503)), now: () => 1000000);

    await tester.enterText(find.byType(TextField).first, 'https://blog.example/x');
    await tester.tap(find.text('Đọc công thức từ liên kết'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('import-cooldown')), findsNothing);
    expect(enabled(tester, 'Đọc công thức từ liên kết'), isTrue);
  });

  testWidgets('a picked photo is uploaded and imported', (tester) async {
    final remote = FakeParserRemote(jobs: [parseJob(result: parseResult())]);
    final photo = PickedPhoto(Uint8List(2048), api.CreateUploadContentTypeEnum.imageSlashJpeg);
    await openImport(tester, remote: remote, picker: FakePhotoPicker(photo));

    await tester.tap(find.text('Chọn ảnh từ thư viện'));
    await tester.pumpAndSettle();

    expect(remote.started, ['image:2048:image/jpeg']);
    expect(find.text('form mới'), findsOneWidget);
  });

  testWidgets('cancelling the picker does nothing; oversized photos are refused before upload', (tester) async {
    final remote = FakeParserRemote(jobs: [parseJob(result: parseResult())]);
    await openImport(tester, remote: remote, picker: FakePhotoPicker(null));
    await tester.tap(find.text('Chụp ảnh công thức'));
    await tester.pumpAndSettle();
    expect(remote.started, isEmpty);
    expect(find.byKey(const Key('import-error')), findsNothing);
  });

  testWidgets('photos over 5 MB are refused without uploading', (tester) async {
    final remote = FakeParserRemote();
    final big = PickedPhoto(Uint8List(maxPhotoBytes + 1), api.CreateUploadContentTypeEnum.imageSlashJpeg);
    await openImport(tester, remote: remote, picker: FakePhotoPicker(big));

    await tester.tap(find.text('Chọn ảnh từ thư viện'));
    await tester.pumpAndSettle();

    expect(remote.started, isEmpty);
    expect(find.textContaining('Ảnh quá lớn'), findsOneWidget);
  });
}
