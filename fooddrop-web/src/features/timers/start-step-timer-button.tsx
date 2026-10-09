"use client";

import { StopwatchIcon } from "@/components/ui/icons";
import { formatCountdown } from "./format-countdown";
import { startTimer } from "./start-timer";

/** Prefilled timer for a recipe step that carries `timerSeconds`; `caption` is the step's own timer label, if any. */
export function StartStepTimerButton({ seconds, label, caption }: { seconds: number; label: string; caption?: string | null }) {
  return (
    <button
      type="button"
      onClick={() => void startTimer(label, seconds * 1000)}
      className="flex min-h-11 items-center gap-2 self-start rounded-xl border border-border bg-surface-raised px-4 text-sm font-semibold transition hover:border-accent"
    >
      <StopwatchIcon className="shrink-0 text-accent" />
      <span>
        Bắt đầu hẹn giờ · <span className="font-mono text-accent">{formatCountdown(seconds * 1000)}</span>
        {caption && <span className="text-muted"> {caption}</span>}
      </span>
    </button>
  );
}
