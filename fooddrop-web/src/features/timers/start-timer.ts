import { primeTimerAlerts } from "./timer-alert";
import { useTimerStore } from "./use-timer-store";

/** Single entry point for starting a timer from a click: unlocks sound and asks for notification permission first. */
export async function startTimer(label: string, durationMs: number): Promise<void> {
  await primeTimerAlerts();
  await useTimerStore.getState().start(label, durationMs);
}
