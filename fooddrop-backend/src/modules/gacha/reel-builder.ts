import type { RandomInt } from './weighted-draw.js';

export const REEL_LENGTH = 70;
/** Leaves ten cards after the winner so the strip never shows empty space when it stops. */
export const WINNING_INDEX = 60;
/** Where inside the winning card the marker stops, as a fraction of card width from its center. */
export const MAX_OFFSET_JITTER = 0.4;

export interface Reel<T> {
  cards: T[];
  winningIndex: number;
  /** In `[-MAX_OFFSET_JITTER, MAX_OFFSET_JITTER]`; a value near the edge reads as a near-miss. */
  offsetJitter: number;
}

/**
 * Places the already drawn winner at `WINNING_INDEX` and fills the rest with `pickFiller`, which should
 * draw with the same weights so the rarities passing by look like real odds. Repeats are allowed, which
 * keeps a reel full even when the pool holds a single recipe.
 */
export function buildReel<T>(winner: T, pickFiller: () => T, rng: RandomInt): Reel<T> {
  const cards = Array.from({ length: REEL_LENGTH }, (_, index) => (index === WINNING_INDEX ? winner : pickFiller()));
  const steps = Math.round(MAX_OFFSET_JITTER * 1000);
  return { cards, winningIndex: WINNING_INDEX, offsetJitter: (rng(2 * steps + 1) - steps) / 1000 };
}
