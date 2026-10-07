"use client";

import { Button } from "@/components/ui/button";
import { startTimer } from "./start-timer";

/** Prefilled timer for a recipe step that carries `timerSeconds`. */
export function StartStepTimerButton({ seconds, label }: { seconds: number; label: string }) {
  const minutes = Math.max(1, Math.round(seconds / 60));
  return (
    <Button variant="secondary" className="min-h-9 self-start px-3 text-sm" onClick={() => void startTimer(label, seconds * 1000)}>
      Hẹn giờ {minutes} phút
    </Button>
  );
}
