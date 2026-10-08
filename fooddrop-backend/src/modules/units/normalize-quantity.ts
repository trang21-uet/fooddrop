import type { UnitKind } from '../../database/schema/units.schema.js';
import type { QuantityUnit } from '../../database/schema/ingredients.schema.js';
import { parseQuantity } from './parse-quantity.js';

export interface IngredientUnitInfo {
  defaultUnit: QuantityUnit;
  densityGPerMl: number | null;
}

/** The part of a catalog unit the conversion needs. */
export interface UnitConversion {
  kind: UnitKind;
  toBase: number | null;
}

export interface BaseQuantity {
  quantity: number;
  unit: QuantityUnit;
}

export class InvalidQuantityError extends Error {
  constructor(input: unknown) {
    super(`Invalid quantity: ${String(input)}`);
    this.name = 'InvalidQuantityError';
  }
}

const round2 = (value: number): number => Math.round(value * 100) / 100;

/** Raw text ("1 1/2", "2-3") or a number -> a non-negative number; throws on anything else. */
export function parseAmount(quantity: number | string): number {
  const amount = typeof quantity === 'number' ? quantity : parseQuantity(quantity);
  if (amount === null || !Number.isFinite(amount) || amount < 0) throw new InvalidQuantityError(quantity);
  return amount;
}

/**
 * The amount a recipe line contributes to the grocery list, in g | ml | piece. Display quantity and
 * unit stay as the cook wrote them; this is derived on read so a change here fixes old recipes too.
 * Mass becomes g, volume ml, counts piece; when the ingredient has a density and is summed in the
 * other dimension (milk in g -> ml) the value is converted so recipes sum cleanly. A line with no
 * quantity, or a unit that cannot be summed ("a pinch"), contributes 0 in the ingredient's own unit.
 */
export function toBaseQuantity(
  quantity: number | null,
  unit: UnitConversion | null,
  ingredient: IngredientUnitInfo,
): BaseQuantity {
  const none: BaseQuantity = { quantity: 0, unit: ingredient.defaultUnit };
  if (quantity === null) return none;
  // "2 trứng": a count with no unit.
  if (!unit) return { quantity: round2(quantity), unit: 'piece' };
  if (unit.toBase === null || unit.kind === 'other') return none;

  const base = quantity * unit.toBase;
  const density = ingredient.densityGPerMl;
  switch (unit.kind) {
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
