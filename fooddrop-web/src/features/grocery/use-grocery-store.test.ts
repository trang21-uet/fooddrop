import "fake-indexeddb/auto";
import { beforeEach, describe, expect, it } from "vitest";
import { localDb, wipeLocalData } from "@/lib/local-db";
import type { GroceryRecipe } from "./aggregate-grocery";
import { resetGroceryStore, useGroceryStore } from "./use-grocery-store";

const recipe: GroceryRecipe = {
  id: "r1",
  title: "Canh cà chua",
  baseServings: 2,
  ingredients: [{ ingredientId: "tomato", name: "Cà chua", aisle: "produce", quantity: 200, unit: "g" }],
};

beforeEach(async () => {
  await wipeLocalData();
  resetGroceryStore();
});

describe("grocery store", () => {
  it("persists only the selection plus checked keys, and restores them on reload", async () => {
    const store = useGroceryStore.getState();
    await store.addRecipe(recipe, 4);
    await store.toggleChecked("tomato|g");

    expect(await localDb().grocerySelections.toArray()).toEqual([{ recipeId: "r1", servings: 4 }]);

    resetGroceryStore();
    await useGroceryStore.getState().hydrate();
    expect(useGroceryStore.getState()).toMatchObject({
      hydrated: true,
      selections: [{ recipeId: "r1", servings: 4 }],
      recipes: { r1: recipe },
      checked: ["tomato|g"],
    });
  });

  it("re-adding a recipe replaces its servings instead of duplicating it", async () => {
    await useGroceryStore.getState().addRecipe(recipe, 2);
    await useGroceryStore.getState().addRecipe(recipe, 6);
    expect(useGroceryStore.getState().selections).toEqual([{ recipeId: "r1", servings: 6 }]);
  });

  it("toggles, unchecks all, removes and clears", async () => {
    const store = useGroceryStore.getState();
    await store.addRecipe(recipe, 2);
    await store.toggleChecked("tomato|g");
    await store.toggleChecked("tomato|g");
    expect(useGroceryStore.getState().checked).toEqual([]);

    await store.toggleChecked("tomato|g");
    await store.uncheckAll();
    expect(await localDb().groceryChecked.count()).toBe(0);

    await store.setServings("r1", 3);
    expect(useGroceryStore.getState().selections).toEqual([{ recipeId: "r1", servings: 3 }]);

    await store.removeRecipe("r1");
    expect(useGroceryStore.getState().recipes).toEqual({});
    expect(await localDb().groceryRecipes.count()).toBe(0);

    await store.addRecipe(recipe, 2);
    await store.clearAll();
    expect(await localDb().grocerySelections.count()).toBe(0);
  });
});
