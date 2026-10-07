const oneMinuteMs = 60000;

/// `pausedRemainingMs` is set only while paused; otherwise `endsAtMs` (epoch ms) is the truth.
class TimerClock {
  const TimerClock({required this.endsAtMs, this.pausedRemainingMs});

  final int endsAtMs;
  final int? pausedRemainingMs;

  bool get isPaused => pausedRemainingMs != null;

  @override
  bool operator ==(Object other) =>
      other is TimerClock && other.endsAtMs == endsAtMs && other.pausedRemainingMs == pausedRemainingMs;

  @override
  int get hashCode => Object.hash(endsAtMs, pausedRemainingMs);

  @override
  String toString() => 'TimerClock($endsAtMs, paused: $pausedRemainingMs)';
}

int timerRemainingMs(TimerClock timer, int nowMs) =>
    timer.pausedRemainingMs ?? (timer.endsAtMs - nowMs < 0 ? 0 : timer.endsAtMs - nowMs);

TimerClock pauseTimer(TimerClock timer, int nowMs) =>
    timer.isPaused ? timer : TimerClock(endsAtMs: timer.endsAtMs, pausedRemainingMs: timerRemainingMs(timer, nowMs));

TimerClock resumeTimer(TimerClock timer, int nowMs) =>
    timer.isPaused ? TimerClock(endsAtMs: nowMs + timer.pausedRemainingMs!) : timer;

/// Adding time to a timer that already rang restarts it from now instead of from the past.
TimerClock addTimerMs(TimerClock timer, int addMs, int nowMs) {
  if (timer.isPaused) return TimerClock(endsAtMs: timer.endsAtMs, pausedRemainingMs: timer.pausedRemainingMs! + addMs);
  final base = timer.endsAtMs > nowMs ? timer.endsAtMs : nowMs;
  return TimerClock(endsAtMs: base + addMs);
}

/// 83000 → "1:23", 3725000 → "1:02:05". Rounds up so a timer never shows 0:00 before it rings.
String formatCountdown(int remainingMs) {
  final totalSeconds = remainingMs <= 0 ? 0 : (remainingMs / 1000).ceil();
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  String two(int value) => value.toString().padLeft(2, '0');
  return hours > 0 ? '$hours:${two(minutes)}:${two(seconds)}' : '$minutes:${two(seconds)}';
}
