export type UnitDimension = 'mass' | 'volume' | 'count';

export interface UnitDefinition {
  dimension: UnitDimension;
  /** Multiplier to the dimension's base unit: grams for mass, millilitres for volume, 1 for count. */
  factor: number;
}

/** Lowercase and strip diacritics / punctuation so "Muỗng Cà Phê" and "muong ca phe" match. */
export function foldUnitText(text: string): string {
  return text
    .normalize('NFD')
    .replace(/\p{M}/gu, '')
    .replace(/đ/gi, 'd')
    .toLowerCase()
    .replace(/[.,]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

const MASS: Record<string, number> = {
  g: 1, gram: 1, grams: 1, gr: 1, gam: 1,
  kg: 1000, kilogram: 1000, kilograms: 1000, kilo: 1000, kilos: 1000,
  mg: 0.001, milligram: 0.001, milligrams: 0.001,
  oz: 28.3495, ounce: 28.3495, ounces: 28.3495,
  lb: 453.592, lbs: 453.592, pound: 453.592, pounds: 453.592,
  lang: 100, // Vietnamese "lạng" = 100 g
};

const VOLUME: Record<string, number> = {
  ml: 1, milliliter: 1, milliliters: 1, millilitre: 1, millilitres: 1,
  cl: 10, dl: 100,
  l: 1000, lit: 1000, liter: 1000, liters: 1000, litre: 1000, litres: 1000,
  tsp: 4.92892, teaspoon: 4.92892, teaspoons: 4.92892,
  'muong ca phe': 4.92892, 'thia ca phe': 4.92892, 'muong cafe': 4.92892,
  tbsp: 14.7868, tablespoon: 14.7868, tablespoons: 14.7868,
  'muong canh': 14.7868, 'thia canh': 14.7868, 'muong sup': 14.7868,
  cup: 236.588, cups: 236.588,
  'fl oz': 29.5735, 'fluid ounce': 29.5735, 'fluid ounces': 29.5735,
};

const COUNT = [
  'piece', 'pieces', 'pc', 'pcs', 'each', 'whole',
  'qua', 'trai', 'cu', 'tep', 'con', 'cai', 'mieng', 'nhanh', 'lat', 'cay', 'la', 'bo',
  'clove', 'cloves', 'slice', 'slices', 'sprig', 'sprigs', 'stalk', 'stalks', 'head', 'heads',
];

const UNIT_TABLE = new Map<string, UnitDefinition>([
  ...Object.entries(MASS).map(([k, factor]): [string, UnitDefinition] => [k, { dimension: 'mass', factor }]),
  ...Object.entries(VOLUME).map(([k, factor]): [string, UnitDefinition] => [k, { dimension: 'volume', factor }]),
  ...COUNT.map((k): [string, UnitDefinition] => [k, { dimension: 'count', factor: 1 }]),
]);

export function lookupUnit(unit: string): UnitDefinition | undefined {
  return UNIT_TABLE.get(foldUnitText(unit));
}

/** "oz" alone is ambiguous between weight and fluid ounces; callers decide from the ingredient. */
export function isBareOunce(unit: string): boolean {
  return ['oz', 'ounce', 'ounces'].includes(foldUnitText(unit));
}
