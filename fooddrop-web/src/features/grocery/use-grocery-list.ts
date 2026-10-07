import { useMemo } from "react";
import { aggregateGrocery, type GroceryAisleGroup } from "./aggregate-grocery";
import { useGroceryStore } from "./use-grocery-store";

/** Memoized derived list: recomputed only when selections or the recipe snapshots change. */
export function useGroceryList(): GroceryAisleGroup[] {
  const selections = useGroceryStore((state) => state.selections);
  const recipes = useGroceryStore((state) => state.recipes);
  return useMemo(() => aggregateGrocery(selections, new Map(Object.entries(recipes))), [selections, recipes]);
}
