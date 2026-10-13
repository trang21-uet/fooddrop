import { RARITIES, type Rarity } from '../../database/schema/recipes.schema.js';
import { RARITY_WEIGHTS } from './rarity-weights.js';
import { seededRandomInt } from '../../../test/support/seeded-random-int.js';
import { createWeightedPicker } from './weighted-draw.js';

const DRAWS = 100_000;

const shares = <T>(pick: () => T, key: (item: T) => string): Map<string, number> => {
  const counts = new Map<string, number>();
  for (let i = 0; i < DRAWS; i++) {
    const k = key(pick());
    counts.set(k, (counts.get(k) ?? 0) + 1);
  }
  return new Map([...counts].map(([k, count]) => [k, count / DRAWS]));
};

describe('createWeightedPicker', () => {
  it('matches the rarity weights within ±2% over 100k draws (one recipe per tier)', () => {
    const pool = RARITIES.map((rarity) => ({ rarity }));
    const pick = createWeightedPicker(pool, (r) => RARITY_WEIGHTS[r.rarity], seededRandomInt(42));
    const observed = shares(pick, (r) => r.rarity);
    for (const rarity of RARITIES) expect(Math.abs((observed.get(rarity) ?? 0) - RARITY_WEIGHTS[rarity] / 100)).toBeLessThan(0.02);
  });

  it('normalizes over the available recipes', () => {
    // Three white recipes (150) and one red (3): red is 3 / 153.
    const pool: Array<{ id: string; rarity: Rarity }> = [
      { id: 'a', rarity: 'white' },
      { id: 'b', rarity: 'white' },
      { id: 'c', rarity: 'white' },
      { id: 'd', rarity: 'red' },
    ];
    const pick = createWeightedPicker(pool, (r) => RARITY_WEIGHTS[r.rarity], seededRandomInt(7));
    const observed = shares(pick, (r) => r.id);
    expect(Math.abs((observed.get('d') ?? 0) - 3 / 153)).toBeLessThan(0.02);
    for (const id of ['a', 'b', 'c']) expect(Math.abs((observed.get(id) ?? 0) - 50 / 153)).toBeLessThan(0.02);
  });

  it('honours fractional weights such as weather boosts', () => {
    const pick = createWeightedPicker(['boosted', 'plain'], (id) => (id === 'boosted' ? 1.5 : 1), seededRandomInt(3));
    expect(Math.abs((shares(pick, String).get('boosted') ?? 0) - 0.6)).toBeLessThan(0.02);
  });

  it('never picks a zero-weight item and covers both ends of the ticket range', () => {
    const items = ['zero', 'first', 'zero-too', 'last'];
    const weight = (id: string) => (id.startsWith('zero') ? 0 : 1);
    expect(createWeightedPicker(items, weight, () => 0)()).toBe('first');
    expect(createWeightedPicker(items, weight, (max) => max - 1)()).toBe('last');
  });

  it('rejects a pool without any positive weight', () => {
    expect(() => createWeightedPicker([], () => 1)).toThrow();
    expect(() => createWeightedPicker(['a'], () => 0)).toThrow();
  });

  it('uses the crypto RNG by default', () => {
    expect(createWeightedPicker(['only'], () => 1)()).toBe('only');
  });
});
