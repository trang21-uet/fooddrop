import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/timers/data/timer_providers.dart';
import 'package:fooddrop/features/timers/domain/timer_entry.dart';
import 'package:fooddrop/features/timers/domain/timer_math.dart';
import 'package:fooddrop/features/timers/presentation/timer_dock_shell.dart';
import 'package:fooddrop/features/timers/presentation/timers_screen.dart';

import '../../../support/fake_timer_scheduler.dart';
import '../../../support/pump_app.dart';

const _now = 5000000;

class _RecordingTimers extends TimerActions {
  _RecordingTimers(super.ref, this.log);

  final List<String> log;

  @override
  Future<void> start(String label, Duration duration) async => log.add('start $label ${duration.inSeconds}');

  @override
  Future<void> pause(int id) async => log.add('pause $id');

  @override
  Future<void> resume(int id) async => log.add('resume $id');

  @override
  Future<void> addMinute(int id) async => log.add('addMinute $id');

  @override
  Future<void> cancel(int id) async => log.add('cancel $id');

  @override
  Future<void> markAlerted(int id) async => log.add('alerted $id');

  @override
  Future<void> restore() async => log.add('restore');
}

TimerEntry _running(int id, String label, int remainingMs) =>
    TimerEntry(id: id, label: label, clock: TimerClock(endsAtMs: _now + remainingMs));

void main() {
  late List<String> log;

  setUp(() => log = []);

  /// [fixedStreams] false leaves `timersProvider` and `tickerProvider` for the test to drive by hand.
  List<Override> overrides(
    List<TimerEntry> timers, {
    bool exactAllowed = true,
    FakeTimerScheduler? scheduler,
    bool fixedStreams = true,
  }) =>
      [
        if (fixedStreams) timersProvider.overrideWith((ref) => Stream.value(timers)),
        if (fixedStreams) tickerProvider.overrideWith((ref) => Stream.value(_now)),
        nowMsProvider.overrideWithValue(() => _now),
        exactAlarmsAllowedProvider.overrideWith((ref) async => exactAllowed),
        timerNotificationSchedulerProvider.overrideWithValue(scheduler ?? FakeTimerScheduler()),
        timerActionsProvider.overrideWith((ref) => _RecordingTimers(ref, log)),
      ];

  group('timers screen', () {
    Future<void> openScreen(WidgetTester tester, List<TimerEntry> timers, {bool exactAllowed = true, FakeTimerScheduler? scheduler}) =>
        pumpRoutes(
          tester,
          overrides: overrides(timers, exactAllowed: exactAllowed, scheduler: scheduler),
          routes: [homeRoute(const TimersScreen())],
        );

    testWidgets('starts an ad hoc timer from minutes and a label', (tester) async {
      await openScreen(tester, const []);
      expect(find.textContaining('Chưa có bộ đếm nào'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Tên (tùy chọn)'), 'Luộc trứng');
      await tester.enterText(find.widgetWithText(TextField, 'Số phút'), '7,5');
      await tester.tap(find.text('Bắt đầu'));
      await tester.pump();

      expect(log, ['start Luộc trứng 450']);
    });

    testWidgets('rejects a missing or out-of-range number of minutes', (tester) async {
      await openScreen(tester, const []);

      await tester.enterText(find.widgetWithText(TextField, 'Số phút'), '0');
      await tester.tap(find.text('Bắt đầu'));
      await tester.pump();

      expect(find.text('Nhập số phút từ 1 đến 1440.'), findsOneWidget);
      expect(log, isEmpty);
    });

    testWidgets('lists several timers with their remaining time and controls', (tester) async {
      await openScreen(tester, [
        _running(1, 'Luộc trứng', 83000),
        TimerEntry(id: 2, label: 'Hầm xương', clock: const TimerClock(endsAtMs: _now, pausedRemainingMs: 3725000)),
        TimerEntry(id: 3, label: 'Áp chảo', clock: const TimerClock(endsAtMs: _now - 1000)),
      ]);

      expect(find.text('1:23'), findsOneWidget);
      expect(find.text('1:02:05'), findsOneWidget);
      expect(find.text('Xong!'), findsOneWidget);
      expect(find.text('Tạm dừng'), findsOneWidget);
      expect(find.text('Tiếp tục'), findsOneWidget);

      await tester.tap(find.text('Tạm dừng'));
      await tester.tap(find.text('Tiếp tục'));
      await tester.tap(find.text('Đóng'));
      await tester.tap(find.text('Hủy').first);
      await tester.pump();
      expect(log, ['pause 1', 'resume 2', 'cancel 3', 'cancel 1']);
    });

    testWidgets('warns when exact alarms are not allowed and offers to open the setting', (tester) async {
      final scheduler = FakeTimerScheduler()..exactAllowed = false;
      await openScreen(tester, const [], exactAllowed: false, scheduler: scheduler);

      expect(find.textContaining('có thể trễ vài phút'), findsOneWidget);
      await tester.tap(find.text('Cho phép báo đúng giờ'));
      await tester.pump();
      expect(scheduler.exactAlarmRequests, 1);
    });

    testWidgets('no warning when exact alarms are allowed', (tester) async {
      await openScreen(tester, const []);
      expect(find.textContaining('có thể trễ vài phút'), findsNothing);
    });
  });

  group('timer dock', () {
    Future<void> openShell(WidgetTester tester, List<TimerEntry> timers, {String location = '/recipes'}) => pumpRoutes(
          tester,
          overrides: overrides(timers),
          routes: [homeRoute(TimerDockShell(location: location, child: const Scaffold(body: Text('màn hình')))),],
        );

    testWidgets('re-arms notifications on launch and shows nothing without timers', (tester) async {
      await openShell(tester, const []);
      expect(find.text('màn hình'), findsOneWidget);
      expect(find.byIcon(Icons.timer_outlined), findsNothing);
      expect(log, ['restore']);
    });

    testWidgets('shows the soonest timer and expands to the full list', (tester) async {
      await openShell(tester, [_running(1, 'Luộc trứng', 83000), _running(2, 'Hầm xương', 3600000)]);

      expect(find.text('1:23 · 2 bộ đếm'), findsOneWidget);
      expect(find.text('Hầm xương'), findsNothing);

      await tester.tap(find.text('1:23 · 2 bộ đếm'));
      await tester.pump();
      expect(find.text('Hầm xương'), findsOneWidget);
      expect(find.text('Luộc trứng'), findsOneWidget);
    });

    testWidgets('flags a finished timer and rings it once', (tester) async {
      await openShell(tester, [TimerEntry(id: 7, label: 'Áp chảo', clock: const TimerClock(endsAtMs: _now - 1000))]);
      await tester.pump();

      expect(find.text('Có bộ đếm đã xong'), findsOneWidget);
      expect(log.where((entry) => entry == 'alerted 7'), hasLength(1));
    });

    testWidgets('an already-alerted timer does not ring again after a restart', (tester) async {
      await openShell(tester, [
        TimerEntry(id: 1, label: 'đã báo', clock: const TimerClock(endsAtMs: _now - 1000), alertedAtMs: _now - 500),
      ]);
      await tester.pump();
      expect(log, isNot(contains('alerted 1')));
    });

    testWidgets('a timer that is extended after ringing rings again when it finishes again', (tester) async {
      final timers = StreamController<List<TimerEntry>>();
      final ticks = StreamController<int>();
      // Not awaited: closing a controller whose listener is already gone never completes.
      addTearDown(() {
        timers.close();
        ticks.close();
      });
      await pumpRoutes(
        tester,
        overrides: [
          ...overrides(const [], fixedStreams: false),
          timersProvider.overrideWith((ref) => timers.stream),
          tickerProvider.overrideWith((ref) => ticks.stream),
        ],
        routes: [homeRoute(const TimerDockShell(location: '/recipes', child: Scaffold(body: Text('màn hình'))))],
      );
      int rings() => log.where((entry) => entry == 'alerted 1').length;

      timers.add([TimerEntry(id: 1, label: 'a', clock: const TimerClock(endsAtMs: _now - 1000))]);
      ticks.add(_now);
      await tester.pump();
      await tester.pump();
      expect(rings(), 1);

      // "+1 phút": alert re-armed, timer running again.
      timers.add([_running(1, 'a', 60000)]);
      ticks.add(_now);
      await tester.pump();
      await tester.pump();
      expect(rings(), 1);

      // The minute passes.
      ticks.add(_now + 61000);
      await tester.pump();
      await tester.pump();
      expect(rings(), 2);
    });

    testWidgets('is hidden on the timers screen, which lists them itself', (tester) async {
      await openShell(tester, [_running(1, 'Luộc trứng', 83000)], location: '/timers');
      expect(find.text('1:23 · 1 bộ đếm'), findsNothing);
    });
  });
}
