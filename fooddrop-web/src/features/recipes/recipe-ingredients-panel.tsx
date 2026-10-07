"use client";

import { useState } from "react";
import { AddToGroceryButton } from "../grocery/add-to-grocery-button";
import { formatQuantity } from "./format-quantity";
import { scaleIngredientQuantity } from "./portion-scaling";
import type { RecipeDetail } from "./recipe-types";
import { ServingsStepper } from "./servings-stepper";

/** Ingredient list with a live servings stepper; the recipe page itself stays a Server Component. */
export function RecipeIngredientsPanel({ recipe }: { recipe: RecipeDetail }) {
  const [servings, setServings] = useState(recipe.baseServings);

  return (
    <section aria-labelledby="ingredients-heading" className="flex flex-col gap-3">
      <h2 id="ingredients-heading" className="text-lg font-semibold">
        Nguyên liệu
      </h2>
      <div className="flex items-center justify-between gap-3">
        <span className="text-sm text-muted">Khẩu phần</span>
        <ServingsStepper value={servings} onChange={setServings} />
      </div>
      {recipe.ingredients.length === 0 ? (
        <p className="text-sm text-muted">Chưa có nguyên liệu.</p>
      ) : (
        <ul className="flex flex-col divide-y divide-border rounded-xl border border-border bg-surface">
          {recipe.ingredients.map((item) => (
            <li key={item.ingredient.id} className="flex justify-between gap-3 px-4 py-2.5 text-sm">
              <span>
                {item.ingredient.name}
                {item.note && <span className="text-muted"> ({item.note})</span>}
              </span>
              <span className="shrink-0 font-mono text-muted">
                {formatQuantity(scaleIngredientQuantity(item.quantity, item.unit, servings, recipe.baseServings), item.unit)}
              </span>
            </li>
          ))}
        </ul>
      )}
      <AddToGroceryButton recipe={recipe} servings={servings} />
    </section>
  );
}
