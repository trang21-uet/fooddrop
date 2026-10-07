"use client";

import { usePathname } from "next/navigation";
import { useState } from "react";
import { formatCountdown } from "./format-countdown";
import { timerRemainingMs } from "./timer-math";
import { TimerList } from "./timer-list";
import { useNow } from "./ticker";
import { useTimerStore } from "./use-timer-store";

/** Floating dock on every signed-in screen except /timers, which shows the full list itself. */
export function TimerDock() {
  const pathname = usePathname();
  const timers = useTimerStore((state) => state.timers);
  const now = useNow();
  const [open, setOpen] = useState(false);

  if (timers.length === 0 || pathname === "/timers") return null;

  const active = timers.map((timer) => timerRemainingMs(timer, now)).filter((ms) => ms > 0);
  const anyDone = timers.length > active.length;
  const summary = anyDone ? "Có bộ đếm đã xong" : `${formatCountdown(Math.min(...active))} · ${timers.length} bộ đếm`;

  return (
    <div className="fixed right-4 bottom-4 z-30 flex w-[min(24rem,calc(100vw-2rem))] flex-col items-end gap-2">
      {open && (
        <div className="max-h-[60vh] w-full overflow-y-auto rounded-2xl border border-border bg-background p-2 shadow-2xl">
          <TimerList />
        </div>
      )}
      <button
        type="button"
        aria-expanded={open}
        onClick={() => setOpen((value) => !value)}
        className={`min-h-11 rounded-full bg-surface-raised px-5 font-mono text-sm font-bold tabular-nums ${anyDone ? "text-accent-hot" : "glow-accent"}`}
      >
        {summary}
      </button>
    </div>
  );
}
