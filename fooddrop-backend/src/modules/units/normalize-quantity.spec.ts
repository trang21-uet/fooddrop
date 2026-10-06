import { InvalidQuantityError, normalizeQuantity, type IngredientUnitInfo } from './normalize-quantity.js';
import { parseQuantity } from './parse-quantity.js';

const flour: IngredientUnitInfo = { defaultUnit: 'g', densityGPerMl: 0.53 };
const milk: IngredientUnitInfo = { defaultUnit: 'ml', densityGPerMl: 1.03 };
const egg: IngredientUnitInfo = { defaultUnit: 'piece', densityGPerMl: null };
const onion: IngredientUnitInfo = { defaultUnit: 'g', densityGPerMl: null };

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

describe('normalizeQuantity', () => {
  it('keeps grams unchanged', () => {
    expect(normalizeQuantity(250, 'g', onion)).toEqual({ quantity: 250, unit: 'g' });
  });

  it.each([
    [1, 'kg', 1000],
    [2, 'lb', 907.18],
    [4, 'oz', 113.4],
    [500, 'mg', 0.5],
    [3, 'lạng', 300],
  ])('converts %d %s to grams', (qty, unit, grams) => {
    expect(normalizeQuantity(qty, unit, onion)).toEqual({ quantity: grams, unit: 'g' });
  });

  it.each([
    [1, 'l', 1000],
    [1, 'lít', 1000],
    [2, 'tsp', 9.86],
    [1, 'tbsp', 14.79],
    [1, 'cup', 236.59],
    [2, 'fl oz', 59.15],
    [1, 'muỗng canh', 14.79],
    [1, 'muong ca phe', 4.93],
  ])('converts %d %s to ml for a liquid-style ingredient', (qty, unit, ml) => {
    expect(normalizeQuantity(qty, unit, { defaultUnit: 'ml', densityGPerMl: null })).toEqual({
      quantity: ml,
      unit: 'ml',
    });
  });

  it('is case- and punctuation-insensitive for units', () => {
    expect(normalizeQuantity(1, 'Tbsp.', milk)).toEqual({ quantity: 14.79, unit: 'ml' });
    expect(normalizeQuantity(1, 'FL. OZ.', milk)).toEqual({ quantity: 29.57, unit: 'ml' });
  });

  it.each(['quả', 'củ', 'tép', 'con', 'clove', 'pcs'])('treats "%s" as a piece', (unit) => {
    expect(normalizeQuantity(3, unit, egg)).toEqual({ quantity: 3, unit: 'piece' });
  });

  it('treats a missing unit as pieces ("2 eggs")', () => {
    expect(normalizeQuantity(2, undefined, egg)).toEqual({ quantity: 2, unit: 'piece' });
    expect(normalizeQuantity(2, '  ', egg)).toEqual({ quantity: 2, unit: 'piece' });
  });

  it('converts volume to grams when the ingredient is counted by weight and has a density', () => {
    expect(normalizeQuantity(1, 'cup', flour)).toEqual({ quantity: 125.39, unit: 'g' });
  });

  it('converts mass to ml when the ingredient is a liquid with a density', () => {
    expect(normalizeQuantity(103, 'g', milk)).toEqual({ quantity: 100, unit: 'ml' });
  });

  it('keeps volume as ml when the ingredient has no density', () => {
    expect(normalizeQuantity(1, 'cup', onion)).toEqual({ quantity: 236.59, unit: 'ml' });
  });

  it('keeps grams for piece-counted ingredients instead of inventing a piece weight', () => {
    expect(normalizeQuantity(100, 'g', egg)).toEqual({ quantity: 100, unit: 'g' });
  });

  it('accepts string quantities: fractions, mixed numbers and ranges', () => {
    expect(normalizeQuantity('1 1/2', 'cup', milk)).toEqual({ quantity: 354.88, unit: 'ml' });
    expect(normalizeQuantity('2-3', 'tbsp', milk)).toEqual({ quantity: 36.97, unit: 'ml' });
  });

  it('keeps unknown units as a note with quantity 0 in the ingredient default unit', () => {
    expect(normalizeQuantity(2, 'handful', onion)).toEqual({ quantity: 0, unit: 'g', note: '2 handful' });
    expect(normalizeQuantity(1, 'pinch', egg)).toEqual({ quantity: 0, unit: 'piece', note: '1 pinch' });
  });

  it('reads a bare "oz" as fluid ounces for liquids and as weight otherwise', () => {
    expect(normalizeQuantity(8, 'oz', { defaultUnit: 'ml', densityGPerMl: null })).toEqual({ quantity: 236.59, unit: 'ml' });
    expect(normalizeQuantity(8, 'oz', milk)).toEqual({ quantity: 236.59, unit: 'ml' });
    expect(normalizeQuantity(8, 'oz', onion)).toEqual({ quantity: 226.8, unit: 'g' });
  });

  it('allows a zero quantity ("to taste" parsed as 0)', () => {
    expect(normalizeQuantity(0, 'g', onion)).toEqual({ quantity: 0, unit: 'g' });
  });

  it.each([-1, Number.NaN, Number.POSITIVE_INFINITY, 'abc', ''])('rejects invalid quantity %j', (qty) => {
    expect(() => normalizeQuantity(qty, 'g', onion)).toThrow(InvalidQuantityError);
  });
});
