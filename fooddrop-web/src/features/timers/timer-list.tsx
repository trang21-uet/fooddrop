"use client";

import { TimerRow } from "./timer-row";
import { useNow } from "./ticker";
import { useTimerStore } from "./use-timer-store";

export function TimerList({ emptyText }: { emptyText?: string }) {
  const timers = useTimerStore((state) => state.timers);
  const hydrated = useTimerStore((state) => state.hydrated);
  const now = useNow();

  if (!hydrated) return null;
  if (timers.length === 0) return emptyText ? <p className="text-sm text-muted">{emptyText}</p> : null;

  return (
    <ul className="flex flex-col gap-2">
      {timers.map((timer) => (
        <TimerRow key={timer.id} timer={timer} now={now} />
      ))}
    </ul>
  );
}
