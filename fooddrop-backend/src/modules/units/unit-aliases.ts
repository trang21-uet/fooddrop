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

/** A catalog unit plus the multiplier that turns the written amount into that unit. */
export interface UnitAlias {
  code: string;
  factor: number;
}

const OUNCE_G = 28.3495;
const FL_OZ_ML = 29.5735;

const alias = (code: string, factor: number, ...names: string[]): Array<[string, UnitAlias]> =>
  names.map((name) => [name, { code, factor }]);

// Free-text unit as written in a source recipe -> catalog code. Spoons keep their count (2 tbsp =
// 2 thìa canh); units outside the catalog are converted to g / ml so nothing is silently dropped.
const ALIASES = new Map<string, UnitAlias>([
  ...alias('g', 1, 'g', 'gram', 'grams', 'gr', 'gam'),
  ...alias('kg', 1, 'kg', 'kilogram', 'kilograms', 'kilo', 'kilos'),
  ...alias('g', 0.001, 'mg', 'milligram', 'milligrams'),
  ...alias('g', 453.592, 'lb', 'lbs', 'pound', 'pounds'),
  ...alias('lang', 1, 'lang'),
  ...alias('ml', 1, 'ml', 'milliliter', 'milliliters', 'millilitre', 'millilitres'),
  ...alias('ml', 10, 'cl'),
  ...alias('ml', 100, 'dl'),
  ...alias('l', 1, 'l', 'lit', 'liter', 'liters', 'litre', 'litres'),
  ...alias('ml', 236.588, 'cup', 'cups'),
  ...alias('ml', FL_OZ_ML, 'fl oz', 'fluid ounce', 'fluid ounces'),
  ...alias('tsp', 1, 'tsp', 'teaspoon', 'teaspoons', 'thia ca phe', 'muong ca phe', 'thia cafe', 'muong cafe', 'thia nho'),
  ...alias('tbsp', 1, 'tbsp', 'tablespoon', 'tablespoons', 'thia canh', 'muong canh', 'muong sup'),
  ...alias('piece', 1, 'piece', 'pieces', 'pc', 'pcs', 'each', 'cai'),
  ...alias('fruit', 1, 'qua', 'trai', 'fruit'),
  ...alias('bulb', 1, 'cu', 'bulb', 'head', 'heads'),
  ...alias('clove', 1, 'tep', 'clove', 'cloves'),
  ...alias('sprig', 1, 'nhanh', 'sprig', 'sprigs'),
  ...alias('stalk', 1, 'cay', 'stalk', 'stalks'),
  ...alias('leaf', 1, 'la', 'leaf', 'leaves'),
  ...alias('slice', 1, 'lat', 'slice', 'slices'),
  ...alias('chunk', 1, 'mieng', 'chunk', 'chunks'),
  ...alias('whole', 1, 'con', 'whole'),
  ...alias('bunch', 1, 'bo', 'bunch', 'bunches'),
  ...alias('pack', 1, 'goi', 'pack', 'packet', 'packets'),
  ...alias('can', 1, 'hop', 'lon', 'can', 'cans', 'box'),
  ...alias('pinch', 1, 'nhum', 'pinch'),
  ...alias('handful', 1, 'nam', 'handful'),
]);

/** "oz" alone is ambiguous between weight and fluid ounces; callers decide from the ingredient. */
const BARE_OUNCES = new Set(['oz', 'ounce', 'ounces']);

export function lookupUnitAlias(unit: string, options: { liquid?: boolean } = {}): UnitAlias | undefined {
  const folded = foldUnitText(unit);
  if (BARE_OUNCES.has(folded)) return options.liquid ? { code: 'ml', factor: FL_OZ_ML } : { code: 'g', factor: OUNCE_G };
  return ALIASES.get(folded);
}
