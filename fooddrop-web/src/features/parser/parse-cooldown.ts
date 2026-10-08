/**
 * Mirrors the backend's per-user import cooldown so the UI can disable the button and count down instead of
 * letting the user hit a 429. The backend owns the length (`cooldownSeconds` on the created job, or
 * `retryAfterSeconds` on a 429); this only stores *when* the cooldown ends.
 */

const STORAGE_KEY = "fooddrop:parse-cooldown-ends-at";
// Fallback for browsers where localStorage is blocked: still holds until the page is reloaded.
let memoryEndsAt = 0;

function storedEndsAt(): number {
  try {
    const value = Number(window.localStorage.getItem(STORAGE_KEY));
    return Number.isFinite(value) ? value : 0;
  } catch {
    return 0;
  }
}

export function parseCooldownSecondsLeft(now = Date.now()): number {
  return Math.max(0, Math.ceil((Math.max(memoryEndsAt, storedEndsAt()) - now) / 1000));
}

/** `seconds` always comes from the server, so both sides agree; 0 (cooldown off) ends it right away. */
export function startParseCooldown(seconds: number, now = Date.now()): void {
  memoryEndsAt = now + seconds * 1000;
  try {
    window.localStorage.setItem(STORAGE_KEY, String(memoryEndsAt));
  } catch {
    // Blocked storage: the in-memory value above is enough for this page.
  }
}

/** Called when the session ends: the next account on this browser must not inherit the wait. */
export function clearParseCooldown(): void {
  memoryEndsAt = 0;
  try {
    window.localStorage.removeItem(STORAGE_KEY);
  } catch {
    // Nothing stored.
  }
}
