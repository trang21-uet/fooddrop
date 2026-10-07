/** `pausedRemainingMs` is set only while paused; otherwise `endsAt` (epoch ms) is the truth. */
export interface TimerClock {
  endsAt: number;
  pausedRemainingMs: number | null;
}

export const ONE_MINUTE_MS = 60_000;

export function timerRemainingMs(timer: TimerClock, now: number): number {
  return timer.pausedRemainingMs ?? Math.max(0, timer.endsAt - now);
}

export function pauseTimer<T extends TimerClock>(timer: T, now: number): T {
  if (timer.pausedRemainingMs !== null) return timer;
  return { ...timer, pausedRemainingMs: timerRemainingMs(timer, now) };
}

export function resumeTimer<T extends TimerClock>(timer: T, now: number): T {
  if (timer.pausedRemainingMs === null) return timer;
  return { ...timer, endsAt: now + timer.pausedRemainingMs, pausedRemainingMs: null };
}

/** Adding time to a timer that already rang restarts it from now instead of from the past. */
export function addTimerMs<T extends TimerClock>(timer: T, addMs: number, now: number): T {
  if (timer.pausedRemainingMs !== null) return { ...timer, pausedRemainingMs: timer.pausedRemainingMs + addMs };
  return { ...timer, endsAt: Math.max(timer.endsAt, now) + addMs };
}
