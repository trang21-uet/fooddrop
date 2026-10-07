/// OS-level "timer done" notifications. The OS suspends background isolates, so a Dart `Timer`
/// cannot ring a timer while the app is closed; a scheduled notification can.
abstract class TimerNotificationScheduler {
  /// Asks for permission to show notifications (Android 13+, iOS). Safe to call repeatedly.
  Future<void> requestNotificationPermission();

  /// Whether the OS lets this app fire at the exact second (Android 14+ makes that opt-in).
  Future<bool> canScheduleExact();

  /// Opens the system screen where the user can allow exact alarms.
  Future<void> requestExactAlarms();

  /// Replaces any notification already scheduled with [id].
  Future<void> schedule({required int id, required String label, required int atMs});

  Future<void> cancel(int id);
}
