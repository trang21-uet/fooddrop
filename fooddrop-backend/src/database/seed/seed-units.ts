import type { UnitKind } from '../schema/units.schema.js';

/**
 * [code, nameVi, nameEn, kind, toBase]. Array order is the order shown in pickers.
 * `toBase` converts to g (mass), ml (volume) or 1 (count); null means it cannot be summed.
 * Vietnamese kitchen spoons are 5 ml / 15 ml (not the US 4.93 / 14.79 ml).
 */
export type SeedUnit = [code: string, nameVi: string, nameEn: string, kind: UnitKind, toBase: number | null];

export const SEED_UNITS: SeedUnit[] = [
  ['g', 'g', 'g', 'mass', 1],
  ['kg', 'kg', 'kg', 'mass', 1000],
  ['lang', 'lạng', 'lang (100 g)', 'mass', 100],
  ['ml', 'ml', 'ml', 'volume', 1],
  ['l', 'lít', 'liter', 'volume', 1000],
  ['tsp', 'thìa cafe', 'teaspoon', 'volume', 5],
  ['tbsp', 'thìa canh', 'tablespoon', 'volume', 15],
  ['piece', 'cái', 'piece', 'count', 1],
  ['fruit', 'quả', 'fruit', 'count', 1],
  ['bulb', 'củ', 'bulb / root', 'count', 1],
  ['clove', 'tép', 'clove', 'count', 1],
  ['sprig', 'nhánh', 'sprig', 'count', 1],
  ['stalk', 'cây', 'stalk', 'count', 1],
  ['leaf', 'lá', 'leaf', 'count', 1],
  ['slice', 'lát', 'slice', 'count', 1],
  ['chunk', 'miếng', 'chunk', 'count', 1],
  ['whole', 'con', 'whole animal', 'count', 1],
  ['bunch', 'bó', 'bunch', 'count', 1],
  ['pack', 'gói', 'pack', 'count', 1],
  ['can', 'hộp', 'can / box', 'count', 1],
  ['pinch', 'nhúm', 'pinch', 'other', null],
  ['handful', 'nắm', 'handful', 'other', null],
];
