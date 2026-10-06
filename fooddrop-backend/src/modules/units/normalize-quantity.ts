import type { QuantityUnit } from '../../database/schema/ingredients.schema.js';
import { parseQuantity } from './parse-quantity.js';
import { isBareOunce, lookupUnit } from './unit-table.js';

export interface IngredientUnitInfo {
  defaultUnit: QuantityUnit;
  densityGPerMl: number | null;
}

export interface NormalizedQuantity {
  quantity: number;
  unit: QuantityUnit;
  /** Set when the original unit could not be converted (quantity is then 0); keeps the user's wording. */
  note?: string;
}

export class InvalidQuantityError extends Error {
  constructor(input: unknown) {
    super(`Invalid quantity: ${String(input)}`);
    this.name = 'InvalidQuantityError';
  }
}

const round2 = (value: number): number => Math.round(value * 100) / 100;

/**
 * Deterministically maps a raw `{qty, unit}` to g | ml | piece. Mass becomes g, volume ml, counts
 * piece; when the ingredient has a density and prefers the other dimension (e.g. milk in g -> ml)
 * the value is converted so recipes sum cleanly. Unknown units become quantity 0 with the original
 * wording kept in `note` — never guessed.
 */
export function normalizeQuantity(
  quantity: number | string,
  unit: string | null | undefined,
  ingredient: IngredientUnitInfo,
): NormalizedQuantity {
  const amount = typeof quantity === 'number' ? quantity : parseQuantity(quantity);
  if (amount === null || !Number.isFinite(amount) || amount < 0) throw new InvalidQuantityError(quantity);

  const rawUnit = unit?.trim() ?? '';
  if (!rawUnit) return { quantity: round2(amount), unit: 'piece' };

  // A bare "oz" next to a liquid (milk, stock) means fluid ounces, not weight.
  const definition = lookupUnit(isBareOunce(rawUnit) && ingredient.defaultUnit === 'ml' ? 'fl oz' : rawUnit);
  // Unknown unit ("handful"): contribute 0 in the ingredient's own unit so aggregation is not
  // polluted with a made-up count; the user's wording survives in `note`.
  if (!definition) return { quantity: 0, unit: ingredient.defaultUnit, note: `${amount} ${rawUnit}` };

  const base = amount * definition.factor;
  const density = ingredient.densityGPerMl;
  switch (definition.dimension) {
    case 'count':
      return { quantity: round2(base), unit: 'piece' };
    case 'mass':
      if (ingredient.defaultUnit === 'ml' && density) return { quantity: round2(base / density), unit: 'ml' };
      return { quantity: round2(base), unit: 'g' };
    case 'volume':
      if (ingredient.defaultUnit === 'g' && density) return { quantity: round2(base * density), unit: 'g' };
      return { quantity: round2(base), unit: 'ml' };
  }
}
