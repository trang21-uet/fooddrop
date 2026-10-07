import { roundForUnit, scaleQuantity } from "../recipes/portion-scaling";
import type { Aisle, IngredientUnit } from "../recipes/recipe-types";

export const AISLE_ORDER: readonly Aisle[] = ["produce", "meat", "seafood", "dairy", "pantry", "spices", "frozen", "other"];

export interface GroceryRecipe {
  id: string;
  title: string;
  baseServings: number;
  ingredients: {
    ingredientId: string;
    name: string;
    aisle: Aisle;
    quantity: number;
    unit: IngredientUnit;
  }[];
}

export interface GrocerySelection {
  recipeId: string;
  servings: number;
}

export interface GroceryItem {
  ingredientId: string;
  name: string;
  unit: IngredientUnit;
  quantity: number;
}

export interface GroceryAisleGroup {
  aisle: Aisle;
  items: GroceryItem[];
}

/** Stable key for check marks: the same ingredient in two units is two lines. */
export function groceryItemKey(item: Pick<GroceryItem, "ingredientId" | "unit">): string {
  return `${item.ingredientId}|${item.unit}`;
}

function compareText(a: string, b: string): number {
  return a < b ? -1 : a > b ? 1 : 0;
}

/**
 * Derived state, never persisted. Sums unrounded scaled quantities per (ingredient, unit) and rounds
 * only the total so rounding error does not accumulate. Units are not converted here: the backend
 * already normalizes them. Same rules and vectors as the mobile app (docs/fixtures).
 */
export function aggregateGrocery(
  selections: readonly GrocerySelection[],
  recipesById: ReadonlyMap<string, GroceryRecipe>,
): GroceryAisleGroup[] {
  const totals = new Map<string, GroceryItem & { aisle: Aisle }>();

  for (const selection of selections) {
    const recipe = recipesById.get(selection.recipeId);
    if (!recipe) continue;
    for (const ingredient of recipe.ingredients) {
      const scaled = scaleQuantity(ingredient.quantity, selection.servings, recipe.baseServings);
      const key = groceryItemKey(ingredient);
      const existing = totals.get(key);
      if (existing) existing.quantity += scaled;
      else totals.set(key, { ...ingredient, quantity: scaled });
    }
  }

  const groups: GroceryAisleGroup[] = [];
  for (const aisle of AISLE_ORDER) {
    const items = [...totals.values()]
      .filter((item) => item.aisle === aisle)
      .map(({ ingredientId, name, unit, quantity }) => ({ ingredientId, name, unit, quantity: roundForUnit(quantity, unit) }))
      .sort((a, b) => compareText(a.name, b.name) || compareText(a.unit, b.unit));
    if (items.length > 0) groups.push({ aisle, items });
  }
  return groups;
}
