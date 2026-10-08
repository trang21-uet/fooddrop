export function scaleQuantity(quantity: number, servings: number, baseServings: number): number {
  return (quantity * servings) / baseServings;
}

/**
 * Kitchen-friendly rounding by unit code: g/ml to 5, kg/l to 0.1, everything else (spoons, pieces,
 * fruit, cloves, ...) to 0.5. Below 5 g/ml the step drops to 0.5 and a positive amount never rounds
 * to 0, so a pinch of spice does not vanish when halving a recipe.
 */
export function roundForUnit(quantity: number, unit: string | null): number {
  if (quantity <= 0) return 0;
  const step = unit === "g" || unit === "ml" ? (quantity < 5 ? 0.5 : 5) : unit === "kg" || unit === "l" ? 0.1 : 0.5;
  // toFixed drops float noise such as 0.30000000000000004 from 3 * 0.1.
  return Number.parseFloat(Math.max(Math.round(quantity / step) * step, step).toFixed(2));
}

/** The recipe's own numbers are shown untouched at its base servings; only scaled amounts are rounded. */
export function scaleIngredientQuantity(
  quantity: number,
  unit: string | null,
  servings: number,
  baseServings: number,
): number {
  if (servings === baseServings) return quantity;
  return roundForUnit(scaleQuantity(quantity, servings, baseServings), unit);
}
