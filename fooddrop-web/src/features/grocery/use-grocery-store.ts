import { create } from "zustand";
import { localDb, persist } from "@/lib/local-db";
import type { GroceryRecipe, GrocerySelection } from "./aggregate-grocery";

interface GroceryState {
  hydrated: boolean;
  selections: GrocerySelection[];
  recipes: Record<string, GroceryRecipe>;
  /** Item keys (`ingredientId|unit`) the user ticked off. */
  checked: string[];
  hydrate: () => Promise<void>;
  /** Adding a recipe that is already listed replaces its servings and refreshes its snapshot. */
  addRecipe: (recipe: GroceryRecipe, servings: number) => Promise<void>;
  setServings: (recipeId: string, servings: number) => Promise<void>;
  removeRecipe: (recipeId: string) => Promise<void>;
  toggleChecked: (key: string) => Promise<void>;
  uncheckAll: () => Promise<void>;
  clearAll: () => Promise<void>;
}

const initial = { hydrated: false, selections: [], recipes: {}, checked: [] } satisfies Partial<GroceryState>;

/** Persists only `{recipeId, servings}` + checked keys (plus recipe snapshots); the aggregate is derived. */
export const useGroceryStore = create<GroceryState>((set, get) => ({
  ...initial,

  hydrate: async () => {
    if (get().hydrated) return;
    try {
      const db = localDb();
      const [selections, recipes, checked] = await Promise.all([
        db.grocerySelections.toArray(),
        db.groceryRecipes.toArray(),
        db.groceryChecked.toArray(),
      ]);
      set({
        hydrated: true,
        selections,
        recipes: Object.fromEntries(recipes.map((recipe) => [recipe.id, recipe])),
        checked: checked.map((row) => row.key),
      });
    } catch (error) {
      console.error("Could not load the grocery list", error);
      set({ hydrated: true });
    }
  },

  addRecipe: async (recipe, servings) => {
    const selection = { recipeId: recipe.id, servings };
    set((state) => ({
      selections: [...state.selections.filter((s) => s.recipeId !== recipe.id), selection],
      recipes: { ...state.recipes, [recipe.id]: recipe },
    }));
    const db = localDb();
    await persist(() =>
      db.transaction("rw", db.grocerySelections, db.groceryRecipes, async () => {
        await db.grocerySelections.put(selection);
        await db.groceryRecipes.put(recipe);
      }),
    );
  },

  setServings: async (recipeId, servings) => {
    const selection = { recipeId, servings };
    set((state) => ({ selections: state.selections.map((s) => (s.recipeId === recipeId ? selection : s)) }));
    await persist(() => localDb().grocerySelections.put(selection));
  },

  removeRecipe: async (recipeId) => {
    set((state) => {
      const recipes = { ...state.recipes };
      delete recipes[recipeId];
      return { selections: state.selections.filter((s) => s.recipeId !== recipeId), recipes };
    });
    const db = localDb();
    await persist(() =>
      db.transaction("rw", db.grocerySelections, db.groceryRecipes, async () => {
        await db.grocerySelections.delete(recipeId);
        await db.groceryRecipes.delete(recipeId);
      }),
    );
  },

  toggleChecked: async (key) => {
    const wasChecked = get().checked.includes(key);
    set((state) => ({ checked: wasChecked ? state.checked.filter((k) => k !== key) : [...state.checked, key] }));
    await persist(() => (wasChecked ? localDb().groceryChecked.delete(key) : localDb().groceryChecked.put({ key })));
  },

  uncheckAll: async () => {
    set({ checked: [] });
    await persist(() => localDb().groceryChecked.clear());
  },

  clearAll: async () => {
    set({ selections: [], recipes: {}, checked: [] });
    const db = localDb();
    await persist(() => Promise.all([db.grocerySelections.clear(), db.groceryRecipes.clear(), db.groceryChecked.clear()]));
  },
}));

/** Resets in-memory state only (sign-out and tests). */
export function resetGroceryStore(): void {
  useGroceryStore.setState({ ...initial });
}
