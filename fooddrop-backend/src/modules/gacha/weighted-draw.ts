import { randomInt } from 'node:crypto';

/** Returns a uniformly random integer in `[0, maxExclusive)`. Injected so tests can seed it. */
export type RandomInt = (maxExclusive: number) => number;

export const cryptoRandomInt: RandomInt = (maxExclusive) => randomInt(maxExclusive);

// Weights turn fractional once weather boosts multiply them; scaling to integers keeps the draw on randomInt.
const WEIGHT_SCALE = 1000;

/**
 * Builds a picker that draws one item with probability `weight / Σ weights`. Cumulative weights are
 * computed once, so filling a 70-card reel costs one binary search per card instead of a pass over the pool.
 */
export function createWeightedPicker<T>(
  items: readonly T[],
  weightOf: (item: T) => number,
  rng: RandomInt = cryptoRandomInt,
): () => T {
  const cumulative: number[] = [];
  let total = 0;
  for (const item of items) {
    total += Math.max(0, Math.round(weightOf(item) * WEIGHT_SCALE));
    cumulative.push(total);
  }
  if (total <= 0) throw new Error('A weighted draw needs at least one item with a positive weight');

  return () => {
    const ticket = rng(total);
    // First index whose cumulative weight exceeds the ticket; zero-weight items are never chosen.
    let low = 0;
    let high = cumulative.length - 1;
    while (low < high) {
      const mid = (low + high) >> 1;
      if (cumulative[mid]! > ticket) high = mid;
      else low = mid + 1;
    }
    return items[low]!;
  };
}
