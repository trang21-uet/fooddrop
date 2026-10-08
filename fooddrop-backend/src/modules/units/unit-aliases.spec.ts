import { SEED_UNITS } from '../../database/seed/seed-units.js';
import { foldUnitText, lookupUnitAlias } from './unit-aliases.js';

describe('lookupUnitAlias', () => {
  it.each([
    ['tbsp', 'tbsp', 1],
    ['Tbsp.', 'tbsp', 1],
    ['muỗng canh', 'tbsp', 1],
    ['thìa cà phê', 'tsp', 1],
    ['muong ca phe', 'tsp', 1],
    ['cup', 'ml', 236.588],
    ['lb', 'g', 453.592],
    ['FL. OZ.', 'ml', 29.5735],
    ['lạng', 'lang', 1],
    ['quả', 'fruit', 1],
    ['tép', 'clove', 1],
    ['nhánh', 'sprig', 1],
    ['cloves', 'clove', 1],
  ])('maps %j to %s x%d', (input, code, factor) => {
    expect(lookupUnitAlias(input)).toEqual({ code, factor });
  });

  it('reads a bare "oz" as fluid ounces for liquids and as weight otherwise', () => {
    expect(lookupUnitAlias('oz', { liquid: true })).toEqual({ code: 'ml', factor: 29.5735 });
    expect(lookupUnitAlias('oz')).toEqual({ code: 'g', factor: 28.3495 });
  });

  it('returns undefined for unknown units', () => {
    expect(lookupUnitAlias('sachet')).toBeUndefined();
    expect(lookupUnitAlias('')).toBeUndefined();
  });

  it('only targets codes that exist in the unit catalog', () => {
    const codes = new Set(SEED_UNITS.map(([code]) => code));
    const names = ['g', 'mg', 'kg', 'lb', 'oz', 'cup', 'ml', 'tsp', 'tbsp', 'quả', 'củ', 'tép', 'nhánh', 'cây', 'lá', 'lát', 'miếng', 'con', 'bó', 'gói', 'hộp', 'nhúm', 'nắm'];
    for (const name of names) {
      const found = lookupUnitAlias(name);
      expect(found, name).toBeDefined();
      expect(codes.has(found!.code), `${name} -> ${found!.code}`).toBe(true);
    }
  });
});

describe('foldUnitText', () => {
  it('drops diacritics, case and punctuation', () => {
    expect(foldUnitText(' Muỗng Cà Phê. ')).toBe('muong ca phe');
  });
});
