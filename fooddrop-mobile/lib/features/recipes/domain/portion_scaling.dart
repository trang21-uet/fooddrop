import 'dart:math' as math;

double scaleQuantity(double quantity, int servings, int baseServings) => quantity * servings / baseServings;

/// Kitchen-friendly rounding by unit code: g/ml to 5, kg/l to 0.1, everything else (spoons, pieces,
/// fruit, cloves, ...) to 0.5. Below 5 g/ml the step drops to 0.5 and a positive amount never rounds
/// to 0, so a pinch of spice does not vanish when halving a recipe. Same rules and vectors as the
/// web app (`docs/fixtures/portion-scaling-cases.json`).
double roundForUnit(double quantity, String? unit) {
  if (quantity <= 0) return 0;
  final step = switch (unit) {
    'g' || 'ml' => quantity < 5 ? 0.5 : 5.0,
    'kg' || 'l' => 0.1,
    _ => 0.5,
  };
  // toStringAsFixed drops float noise such as 0.30000000000000004 from 3 * 0.1.
  return double.parse(math.max((quantity / step).round() * step, step).toStringAsFixed(2));
}

/// The recipe's own numbers are shown untouched at its base servings; only scaled amounts are rounded.
double scaleIngredientQuantity(double quantity, String? unit, int servings, int baseServings) {
  if (servings == baseServings) return quantity;
  return roundForUnit(scaleQuantity(quantity, servings, baseServings), unit);
}
