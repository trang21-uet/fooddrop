"use client";

import { Button } from "@/components/ui/button";
import { formatCountdown } from "./format-countdown";
import { timerRemainingMs } from "./timer-math";
import { useTimerStore, type TimerEntry } from "./use-timer-store";

export function TimerRow({ timer, now }: { timer: TimerEntry; now: number }) {
  const { pause, resume, addMinute, cancel } = useTimerStore.getState();
  const remaining = timerRemainingMs(timer, now);
  const paused = timer.pausedRemainingMs !== null;
  const done = remaining === 0 && !paused;

  return (
    <li
      className={`flex items-center justify-between gap-3 rounded-xl border bg-surface px-4 py-3 ${done ? "border-accent-hot" : "border-border"}`}
    >
      <div className="flex min-w-0 flex-col">
        <span className="truncate text-sm text-muted">{timer.label}</span>
        <span
          role="timer"
          aria-label={`${timer.label}: ${done ? "đã xong" : formatCountdown(remaining)}`}
          className={`font-mono text-2xl font-bold tabular-nums ${done ? "text-accent-hot" : paused ? "text-muted" : ""}`}
        >
          {done ? "Xong!" : formatCountdown(remaining)}
        </span>
      </div>
      <div className="flex shrink-0 flex-wrap justify-end gap-2">
        {!done && (
          <Button variant="secondary" className="min-h-9 px-3 text-sm" onClick={() => void (paused ? resume(timer.id) : pause(timer.id))}>
            {paused ? "Tiếp tục" : "Tạm dừng"}
          </Button>
        )}
        <Button variant="secondary" className="min-h-9 px-3 text-sm" onClick={() => void addMinute(timer.id)}>
          +1 phút
        </Button>
        <Button variant={done ? "primary" : "ghost"} className="min-h-9 px-3 text-sm" onClick={() => void cancel(timer.id)}>
          {done ? "Đóng" : "Hủy"}
        </Button>
      </div>
    </li>
  );
}
