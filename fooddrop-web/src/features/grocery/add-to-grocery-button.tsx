"use client";

import Link from "next/link";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import type { RecipeDetail } from "../recipes/recipe-types";
import type { GroceryRecipe } from "./aggregate-grocery";
import { useGroceryStore } from "./use-grocery-store";

export function toGroceryRecipe(recipe: RecipeDetail): GroceryRecipe {
  return {
    id: recipe.id,
    title: recipe.title,
    baseServings: recipe.baseServings,
    ingredients: recipe.ingredients.map((item) => ({
      ingredientId: item.ingredient.id,
      name: item.ingredient.name,
      aisle: item.ingredient.aisle,
      // The server's g | ml | piece conversion, so recipes written in different units still sum.
      quantity: item.base.quantity,
      unit: item.base.unit,
    })),
  };
}

export function AddToGroceryButton({ recipe, servings }: { recipe: RecipeDetail; servings: number }) {
  const [added, setAdded] = useState(false);
  const addRecipe = useGroceryStore((state) => state.addRecipe);

  const onAdd = async () => {
    await addRecipe(toGroceryRecipe(recipe), servings);
    setAdded(true);
  };

  return (
    <div className="flex flex-wrap items-center gap-3">
      <Button variant="secondary" onClick={onAdd} disabled={recipe.ingredients.length === 0}>
        {added ? "Đã cập nhật danh sách" : "Thêm vào đi chợ"}
      </Button>
      {added && (
        <Link href="/grocery" className="text-sm text-accent underline-offset-4 hover:underline">
          Xem danh sách
        </Link>
      )}
    </div>
  );
}
