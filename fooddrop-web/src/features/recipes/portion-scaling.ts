import type { IngredientUnit } from "./recipe-types";

export function scaleQuantity(quantity: number, servings: number, baseServings: number): number {
  return (quantity * servings) / baseServings;
}

/**
 * Kitchen-friendly rounding: g/ml to 5, pieces to 0.5. Below 5 g/ml the step drops to 0.5 and a
 * positive amount never rounds to 0, so a pinch of spice does not vanish when halving a recipe.
 */
export function roundForUnit(quantity: number, unit: IngredientUnit): number {
  if (quantity <= 0) return 0;
  const step = unit === "piece" || quantity < 5 ? 0.5 : 5;
  return Math.max(Math.round(quantity / step) * step, 0.5);
}

/** The recipe's own numbers are shown untouched at its base servings; only scaled amounts are rounded. */
export function scaleIngredientQuantity(
  quantity: number,
  unit: IngredientUnit,
  servings: number,
  baseServings: number,
): number {
  if (servings === baseServings) return quantity;
  return roundForUnit(scaleQuantity(quantity, servings, baseServings), unit);
}
