import { seededRandomInt } from '../../../test/support/seeded-random-int.js';
import { buildReel, MAX_OFFSET_JITTER, REEL_LENGTH, WINNING_INDEX } from './reel-builder.js';

describe('buildReel', () => {
  it('puts the winner at the winning index and fills every other slot', () => {
    let filler = 0;
    const reel = buildReel('winner', () => `filler-${filler++}`, seededRandomInt(1));
    expect(reel.cards).toHaveLength(REEL_LENGTH);
    expect(reel.winningIndex).toBe(WINNING_INDEX);
    expect(reel.cards[WINNING_INDEX]).toBe('winner');
    expect(reel.cards.filter((card) => card.startsWith('filler'))).toHaveLength(REEL_LENGTH - 1);
  });

  it('keeps the landing jitter inside ±0.4 of a card, reaching both edges', () => {
    expect(buildReel('w', () => 'f', () => 0).offsetJitter).toBe(-MAX_OFFSET_JITTER);
    expect(buildReel('w', () => 'f', (max) => max - 1).offsetJitter).toBe(MAX_OFFSET_JITTER);
    const rng = seededRandomInt(9);
    for (let i = 0; i < 1000; i++) expect(Math.abs(buildReel('w', () => 'f', rng).offsetJitter)).toBeLessThanOrEqual(MAX_OFFSET_JITTER);
  });

  it('repeats the only recipe when the pool has one', () => {
    expect(new Set(buildReel('solo', () => 'solo', () => 0).cards)).toEqual(new Set(['solo']));
  });
});
