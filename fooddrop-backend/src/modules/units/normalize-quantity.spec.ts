import { InvalidQuantityError, parseAmount, toBaseQuantity, type IngredientUnitInfo } from './normalize-quantity.js';
import { parseQuantity } from './parse-quantity.js';

const flour: IngredientUnitInfo = { defaultUnit: 'g', densityGPerMl: 0.53 };
const milk: IngredientUnitInfo = { defaultUnit: 'ml', densityGPerMl: 1.03 };
const egg: IngredientUnitInfo = { defaultUnit: 'piece', densityGPerMl: null };
const onion: IngredientUnitInfo = { defaultUnit: 'g', densityGPerMl: null };

const gram = { kind: 'mass', toBase: 1 } as const;
const tablespoon = { kind: 'volume', toBase: 15 } as const;
const teaspoon = { kind: 'volume', toBase: 5 } as const;
const fruit = { kind: 'count', toBase: 1 } as const;
const pinch = { kind: 'other', toBase: null } as const;

describe('parseQuantity', () => {
  it.each([
    ['2', 2],
    ['1.5', 1.5],
    ['1,5', 1.5],
    ['.5', 0.5],
    ['1/2', 0.5],
    ['1 1/2', 1.5],
    ['½', 0.5],
    ['1½', 1.5],
    ['2-3', 2.5],
    ['2 – 3', 2.5],
    ['2 to 3', 2.5],
    ['1/2 - 1', 0.75],
    ['1,000', 1000],
    ['12,500.5', 12500.5],
    ['0,25', 0.25],
    ['1,50', 1.5],
    ['  3  ', 3],
  ])('parses %j as %d', (input, expected) => {
    expect(parseQuantity(input)).toBeCloseTo(expected);
  });

  it.each(['', 'abc', '1/0', '3-2', '-', 'a lot'])('returns null for %j', (input) => {
    expect(parseQuantity(input)).toBeNull();
  });
});

describe('parseAmount', () => {
  it('accepts numbers and written quantities', () => {
    expect(parseAmount(2)).toBe(2);
    expect(parseAmount('1 1/2')).toBe(1.5);
    expect(parseAmount(0)).toBe(0);
  });

  it.each([-1, Number.NaN, Number.POSITIVE_INFINITY, 'abc', ''])('rejects invalid quantity %j', (qty) => {
    expect(() => parseAmount(qty)).toThrow(InvalidQuantityError);
  });
});

describe('toBaseQuantity', () => {
  it('keeps grams unchanged', () => {
    expect(toBaseQuantity(250, gram, onion)).toEqual({ quantity: 250, unit: 'g' });
  });

  it('turns spoons into ml using the catalog factor (5 ml / 15 ml)', () => {
    expect(toBaseQuantity(2, teaspoon, milk)).toEqual({ quantity: 10, unit: 'ml' });
    expect(toBaseQuantity(1.5, tablespoon, onion)).toEqual({ quantity: 22.5, unit: 'ml' });
  });

  it('counts fruit, cloves and sprigs as pieces', () => {
    expect(toBaseQuantity(3, fruit, egg)).toEqual({ quantity: 3, unit: 'piece' });
  });

  it('treats a quantity without a unit as pieces ("2 trứng")', () => {
    expect(toBaseQuantity(2, null, egg)).toEqual({ quantity: 2, unit: 'piece' });
  });

  it('converts volume to grams when the ingredient is summed by weight and has a density', () => {
    expect(toBaseQuantity(2, tablespoon, flour)).toEqual({ quantity: 15.9, unit: 'g' });
  });

  it('converts mass to ml when the ingredient is a liquid with a density', () => {
    expect(toBaseQuantity(103, gram, milk)).toEqual({ quantity: 100, unit: 'ml' });
  });

  it('keeps volume as ml when the ingredient has no density', () => {
    expect(toBaseQuantity(1, tablespoon, onion)).toEqual({ quantity: 15, unit: 'ml' });
  });

  it('keeps grams for piece-counted ingredients instead of inventing a piece weight', () => {
    expect(toBaseQuantity(100, gram, egg)).toEqual({ quantity: 100, unit: 'g' });
  });

  it("contributes 0 in the ingredient's own unit when there is no quantity", () => {
    expect(toBaseQuantity(null, null, onion)).toEqual({ quantity: 0, unit: 'g' });
    expect(toBaseQuantity(null, null, milk)).toEqual({ quantity: 0, unit: 'ml' });
    expect(toBaseQuantity(null, null, egg)).toEqual({ quantity: 0, unit: 'piece' });
  });

  it('contributes 0 for units that cannot be summed ("1 nhúm")', () => {
    expect(toBaseQuantity(1, pinch, onion)).toEqual({ quantity: 0, unit: 'g' });
  });

  it('allows a zero quantity', () => {
    expect(toBaseQuantity(0, gram, onion)).toEqual({ quantity: 0, unit: 'g' });
  });
});
