import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/core/db/database_provider.dart';
import 'package:fooddrop/features/timers/data/timer_providers.dart';

import '../../../support/fake_timer_scheduler.dart';
import '../../../support/test_database.dart';

const _t0 = 1000000;

void main() {
  late AppDatabase db;
  late FakeTimerScheduler scheduler;
  late int now;
  late ProviderContainer container;

  ProviderContainer open(FakeTimerScheduler scheduler) {
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      timerNotificationSchedulerProvider.overrideWithValue(scheduler),
      nowMsProvider.overrideWithValue(() => now),
    ]);
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    db = openTestDatabase();
    scheduler = FakeTimerScheduler();
    now = _t0;
    container = open(scheduler);
  });
  tearDown(() => db.close());

  TimerActions actions() => container.read(timerActionsProvider);
  Future<List<dynamic>> stored() => container.read(timersLocalStoreProvider).getAll();

  test('start stores an absolute endsAt and schedules the OS notification for it', () async {
    await actions().start('Luộc trứng', const Duration(minutes: 10));

    final timer = (await container.read(timersLocalStoreProvider).getAll()).single;
    expect(timer.label, 'Luộc trứng');
    expect(timer.clock.endsAtMs, _t0 + 600000);
    expect(timer.clock.pausedRemainingMs, isNull);
    expect(scheduler.scheduled, {timer.id: _t0 + 600000});
    expect(scheduler.labels[timer.id], 'Luộc trứng');
    expect(scheduler.permissionRequests, 1);
  });

  test('a blank label falls back to a default', () async {
    await actions().start('   ', const Duration(minutes: 1));
    expect((await container.read(timersLocalStoreProvider).getAll()).single.label, 'Hẹn giờ');
  });

  test('timers survive an app restart and re-arm their notifications', () async {
    await actions().start('Hầm xương', const Duration(hours: 2));
    await actions().start('Luộc rau', const Duration(minutes: 3));

    // "Kill the app": a brand-new container on the same database, an hour later, with a fresh OS state.
    now = _t0 + 3600000;
    final freshScheduler = FakeTimerScheduler();
    final restarted = open(freshScheduler);
    final timers = await restarted.read(timersLocalStoreProvider).getAll();

    expect(timers.map((t) => t.label), ['Luộc rau', 'Hầm xương'], reason: 'ordered by endsAt');
    expect(timers.map((t) => t.remainingMs(now)), [0, 3600000], reason: 'remaining time comes from endsAt, not a counter');

    await restarted.read(timerActionsProvider).restore();
    expect(freshScheduler.scheduled.values, [_t0 + 7200000], reason: 'only the still-running timer is re-armed');
  });

  test('pause cancels the notification; resume schedules it from now with the time that was left', () async {
    await actions().start('a', const Duration(minutes: 10));
    final id = (await stored()).single.id as int;

    now = _t0 + 200000;
    await actions().pause(id);
    var timer = (await container.read(timersLocalStoreProvider).byId(id))!;
    expect(timer.clock.pausedRemainingMs, 400000);
    expect(scheduler.scheduled, isEmpty);

    now = _t0 + 900000;
    await actions().resume(id);
    timer = (await container.read(timersLocalStoreProvider).byId(id))!;
    expect(timer.clock.endsAtMs, _t0 + 1300000);
    expect(timer.clock.pausedRemainingMs, isNull);
    expect(scheduler.scheduled, {id: _t0 + 1300000});
  });

  test('+1 phút extends a running timer and reschedules, or a paused one without scheduling', () async {
    await actions().start('a', const Duration(minutes: 1));
    final id = (await stored()).single.id as int;

    await actions().addMinute(id);
    expect(scheduler.scheduled, {id: _t0 + 120000});

    await actions().pause(id);
    await actions().addMinute(id);
    expect((await container.read(timersLocalStoreProvider).byId(id))!.clock.pausedRemainingMs, 180000);
    expect(scheduler.scheduled, isEmpty);
  });

  test('a finished timer that was already alerted rings again after +1 phút', () async {
    await actions().start('a', const Duration(minutes: 1));
    final id = (await stored()).single.id as int;
    now = _t0 + 70000;
    await actions().markAlerted(id);
    expect((await container.read(timersLocalStoreProvider).byId(id))!.alertedAtMs, now);

    await actions().addMinute(id);
    final timer = (await container.read(timersLocalStoreProvider).byId(id))!;
    expect(timer.clock.endsAtMs, now + 60000);
    expect(timer.alertedAtMs, isNull);
    expect(scheduler.scheduled, {id: now + 60000});
  });

  test('cancel removes the timer and its notification', () async {
    await actions().start('a', const Duration(minutes: 5));
    final id = (await stored()).single.id as int;
    await actions().cancel(id);

    expect(await stored(), isEmpty);
    expect(scheduler.scheduled, isEmpty);
  });

  test('cancelAllNotifications clears every pending notification (sign-out)', () async {
    await actions().start('a', const Duration(minutes: 5));
    await actions().start('b', const Duration(minutes: 9));
    expect(scheduler.scheduled, hasLength(2));

    await actions().cancelAllNotifications();

    expect(scheduler.scheduled, isEmpty);
  });

  test('a notification failure never loses the timer', () async {
    scheduler.failScheduling = true;
    await actions().start('a', const Duration(minutes: 5));
    expect(await stored(), hasLength(1));
  });
}
