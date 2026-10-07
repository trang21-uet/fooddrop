import 'dart:math' as math;

double scaleQuantity(double quantity, int servings, int baseServings) => quantity * servings / baseServings;

/// Kitchen-friendly rounding: g/ml to 5, pieces to 0.5. Below 5 g/ml the step drops to 0.5 and a
/// positive amount never rounds to 0, so a pinch of spice does not vanish when halving a recipe.
/// Same rules and vectors as the web app (`docs/fixtures/portion-scaling-cases.json`).
double roundForUnit(double quantity, String unit) {
  if (quantity <= 0) return 0;
  final step = unit == 'piece' || quantity < 5 ? 0.5 : 5.0;
  return math.max((quantity / step).round() * step, 0.5);
}

/// The recipe's own numbers are shown untouched at its base servings; only scaled amounts are rounded.
double scaleIngredientQuantity(double quantity, String unit, int servings, int baseServings) {
  if (servings == baseServings) return quantity;
  return roundForUnit(scaleQuantity(quantity, servings, baseServings), unit);
}
