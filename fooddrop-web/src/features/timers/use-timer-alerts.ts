import { useEffect } from "react";
import { alertTimerDone } from "./timer-alert";
import { timerRemainingMs } from "./timer-math";
import { useNow } from "./ticker";
import { useTimerStore } from "./use-timer-store";

/** A timer that ended longer ago than this rang while the app was closed; alerting now would be noise. */
const STALE_ALERT_MS = 15_000;

/** Mounted once for the whole app: rings each timer the first time a tick finds it at zero. */
export function useTimerAlerts(): void {
  const now = useNow();
  const hydrated = useTimerStore((state) => state.hydrated);
  const timers = useTimerStore((state) => state.timers);
  const markAlerted = useTimerStore((state) => state.markAlerted);

  useEffect(() => {
    if (!hydrated || now === 0) return;
    for (const timer of timers) {
      if (timer.alertedAt === null && timerRemainingMs(timer, now) === 0) {
        void markAlerted(timer.id);
        if (now - timer.endsAt < STALE_ALERT_MS) alertTimerDone(timer);
      }
    }
  }, [hydrated, now, timers, markAlerted]);
}
