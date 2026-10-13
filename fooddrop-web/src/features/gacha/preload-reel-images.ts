import type { GachaSpin } from "./gacha-types";

/** Cards seen at slow speed: the first screenful when the reel starts, and around the winner when it stops. */
const START_CARDS = 8;
const LANDING_RADIUS = 5;
export const PRELOAD_TIMEOUT_MS = 1500;

/** Resolves once the photo is downloaded and decoded, or failed; never rejects. */
function load(url: string): Promise<void> {
  return new Promise((resolve) => {
    const image = new Image();
    // decode() keeps decoding off the frame that first paints the card.
    image.onload = () => void (image.decode?.() ?? Promise.resolve()).then(() => resolve(), () => resolve());
    image.onerror = () => resolve();
    image.src = url;
  });
}

/** Image URLs of the cards the user actually reads: the opening screen and the landing area. */
export function slowCardImageUrls(spin: GachaSpin): string[] {
  const from = Math.max(0, spin.winningIndex - LANDING_RADIUS);
  const slow = [...spin.reel.slice(0, START_CARDS), ...spin.reel.slice(from, spin.winningIndex + LANDING_RADIUS + 1)];
  return [...new Set(slow.flatMap((card) => (card.imageUrl ? [card.imageUrl] : [])))];
}

/**
 * Starts loading every reel photo and waits (at most `timeoutMs`) for the slow cards, so the reel never
 * starts on blank cards. The blur in the middle of the spin can fill in while it runs.
 */
export async function preloadReelImages(spin: GachaSpin, timeoutMs = PRELOAD_TIMEOUT_MS): Promise<void> {
  const loads = new Map<string, Promise<void>>();
  for (const card of spin.reel) {
    if (card.imageUrl && !loads.has(card.imageUrl)) loads.set(card.imageUrl, load(card.imageUrl));
  }
  const slow = slowCardImageUrls(spin).map((url) => loads.get(url)!);
  let timer: ReturnType<typeof setTimeout> | undefined;
  await Promise.race([Promise.all(slow), new Promise<void>((resolve) => (timer = setTimeout(resolve, timeoutMs)))]);
  clearTimeout(timer);
}
