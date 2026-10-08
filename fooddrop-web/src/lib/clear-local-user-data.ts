import { resetGroceryStore } from "@/features/grocery/use-grocery-store";
import { clearParseCooldown } from "@/features/parser/parse-cooldown";
import { resetTimerStore } from "@/features/timers/use-timer-store";
import { wipeLocalData } from "./local-db";

/**
 * Every way a session ends (sign-out button, expired session) must call this: the grocery list, timers and
 * import cooldown live in this browser, so the next account would otherwise inherit them.
 */
export async function clearLocalUserData(): Promise<void> {
  resetGroceryStore();
  resetTimerStore();
  clearParseCooldown();
  await wipeLocalData().catch((error: unknown) => console.error("Could not wipe local data", error));
}
