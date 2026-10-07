import 'timer_math.dart';

class TimerEntry {
  const TimerEntry({required this.id, required this.label, required this.clock, this.alertedAtMs});

  /// Also the OS notification id.
  final int id;
  final String label;
  final TimerClock clock;

  /// Set once the done-alert has fired, so a restart does not ring again.
  final int? alertedAtMs;

  int remainingMs(int nowMs) => timerRemainingMs(clock, nowMs);

  bool isDone(int nowMs) => !clock.isPaused && remainingMs(nowMs) == 0;

  TimerEntry copyWith({TimerClock? clock, int? alertedAtMs, bool clearAlerted = false}) => TimerEntry(
        id: id,
        label: label,
        clock: clock ?? this.clock,
        alertedAtMs: clearAlerted ? null : (alertedAtMs ?? this.alertedAtMs),
      );
}
