import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/database_provider.dart';
import '../domain/timer_entry.dart';
import '../domain/timer_math.dart';
import 'local_notifications_timer_scheduler.dart';
import 'timer_notification_scheduler.dart';
import 'timers_local_store.dart';

part 'timer_providers.g.dart';

typedef NowMs = int Function();

/// Wall clock in epoch ms; tests override it.
@Riverpod(keepAlive: true)
NowMs nowMs(Ref ref) => () => DateTime.now().millisecondsSinceEpoch;

@Riverpod(keepAlive: true)
TimerNotificationScheduler timerNotificationScheduler(Ref ref) => LocalNotificationsTimerScheduler();

@Riverpod(keepAlive: true)
TimersLocalStore timersLocalStore(Ref ref) => TimersLocalStore(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<TimerEntry>> timers(Ref ref) => ref.watch(timersLocalStoreProvider).watchAll();

/// One shared clock for every timer on screen. Auto-disposes, so it only runs while a timer is visible.
@riverpod
Stream<int> ticker(Ref ref) async* {
  final now = ref.watch(nowMsProvider);
  yield now();
  yield* Stream.periodic(const Duration(milliseconds: 500), (_) => now());
}

/// Whether the OS will fire timer notifications at the exact second.
@riverpod
Future<bool> exactAlarmsAllowed(Ref ref) => ref.watch(timerNotificationSchedulerProvider).canScheduleExact();

/// User-initiated timer changes. State lives in Drift as an absolute `endsAt`; the OS notification
/// is the only thing that can ring while the app is closed, so every change keeps it in step.
class TimerActions {
  TimerActions(this._ref);

  final Ref _ref;

  TimersLocalStore get _store => _ref.read(timersLocalStoreProvider);
  TimerNotificationScheduler get _scheduler => _ref.read(timerNotificationSchedulerProvider);
  int get _now => _ref.read(nowMsProvider)();

  Future<void> start(String label, Duration duration) async {
    // Ask while the user is looking at the "start" tap; a failure must not lose the timer itself.
    await _guard('request notification permission', _scheduler.requestNotificationPermission);
    final timer = await _store.insert(label.trim().isEmpty ? 'Hẹn giờ' : label.trim(), _now + duration.inMilliseconds);
    await _schedule(timer);
  }

  Future<void> pause(int id) => _change(id, (timer) => timer.copyWith(clock: pauseTimer(timer.clock, _now)));

  Future<void> resume(int id) =>
      _change(id, (timer) => timer.copyWith(clock: resumeTimer(timer.clock, _now), clearAlerted: true));

  Future<void> addMinute(int id) =>
      _change(id, (timer) => timer.copyWith(clock: addTimerMs(timer.clock, oneMinuteMs, _now), clearAlerted: true));

  Future<void> markAlerted(int id) => _change(id, (timer) => timer.copyWith(alertedAtMs: _now));

  /// Cancels a running timer or dismisses a finished one.
  Future<void> cancel(int id) async {
    await _store.delete(id);
    await _guard('cancel notification', () => _scheduler.cancel(id));
  }

  /// Re-arms the OS notification of every running timer (app start, exact-alarm permission granted).
  Future<void> restore() async {
    for (final timer in await _store.getAll()) {
      if (!timer.clock.isPaused && timer.clock.endsAtMs > _now) await _schedule(timer);
    }
  }

  Future<void> _change(int id, TimerEntry Function(TimerEntry timer) change) async {
    final current = await _store.byId(id);
    if (current == null) return;
    final next = change(current);
    await _store.save(next);
    if (next.clock.isPaused || next.clock.endsAtMs <= _now) {
      await _guard('cancel notification', () => _scheduler.cancel(id));
    } else {
      await _schedule(next);
    }
  }

  Future<void> _schedule(TimerEntry timer) => _guard(
        'schedule notification',
        () => _scheduler.schedule(id: timer.id, label: timer.label, atMs: timer.clock.endsAtMs),
      );

  /// Notification trouble (permission denied, platform error) is logged; the on-screen timer still works.
  Future<void> _guard(String what, Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stack) {
      debugPrint('Timer: could not $what: $error\n$stack');
    }
  }
}

@riverpod
TimerActions timerActions(Ref ref) => TimerActions(ref);
