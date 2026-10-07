"use client";

import { useEffect } from "react";
import { useGroceryStore } from "@/features/grocery/use-grocery-store";
import { TimerDock } from "@/features/timers/timer-dock";
import { useTimerAlerts } from "@/features/timers/use-timer-alerts";
import { useTimerStore } from "@/features/timers/use-timer-store";

/** Loads persisted grocery/timer state once per session, rings finished timers, and shows the timer dock. */
export function LocalStateBoot() {
  useEffect(() => {
    void useGroceryStore.getState().hydrate();
    void useTimerStore.getState().hydrate();
  }, []);
  useTimerAlerts();
  return <TimerDock />;
}
