import 'package:fooddrop/features/timers/data/timer_notification_scheduler.dart';

/// Records what would be handed to the OS instead of touching the notifications plugin.
class FakeTimerScheduler implements TimerNotificationScheduler {
  /// notification id → scheduled epoch ms, for notifications that are still pending.
  final scheduled = <int, int>{};
  final labels = <int, String>{};
  int permissionRequests = 0;
  int exactAlarmRequests = 0;
  bool exactAllowed = true;
  bool failScheduling = false;

  @override
  Future<void> requestNotificationPermission() async => permissionRequests++;

  @override
  Future<bool> canScheduleExact() async => exactAllowed;

  @override
  Future<void> requestExactAlarms() async => exactAlarmRequests++;

  @override
  Future<void> schedule({required int id, required String label, required int atMs}) async {
    if (failScheduling) throw StateError('notifications unavailable');
    scheduled[id] = atMs;
    labels[id] = label;
  }

  @override
  Future<void> cancel(int id) async {
    scheduled.remove(id);
    labels.remove(id);
  }
}
