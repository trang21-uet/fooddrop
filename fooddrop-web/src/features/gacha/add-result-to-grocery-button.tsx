"use client";

import { useMutation } from "@tanstack/react-query";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";
import { toGroceryRecipe } from "../grocery/add-to-grocery-button";
import { useGroceryStore } from "../grocery/use-grocery-store";

/** The reel card has no ingredients, so the detail is fetched on click and added at its base servings. */
export function AddResultToGroceryButton({ recipeId }: { recipeId: string }) {
  const addRecipe = useGroceryStore((state) => state.addRecipe);
  const add = useMutation({
    mutationFn: async () => {
      const recipe = unwrap(await apiClient.GET("/recipes/{id}", { params: { path: { id: recipeId } } }));
      if (recipe.ingredients.length === 0) return false;
      await addRecipe(toGroceryRecipe(recipe), recipe.baseServings);
      return true;
    },
  });

  if (add.data === true) {
    return (
      <Link href="/grocery" className="flex min-h-11 items-center justify-center text-sm font-semibold text-accent">
        Đã thêm · Xem danh sách đi chợ
      </Link>
    );
  }
  return (
    <div className="flex flex-col gap-1.5">
      <Button variant="secondary" onClick={() => add.mutate()} disabled={add.isPending || add.data === false}>
        {add.isPending ? "Đang thêm…" : "Thêm vào đi chợ"}
      </Button>
      {add.data === false && <p className="text-center text-xs text-muted">Món này chưa có nguyên liệu.</p>}
      {add.isError && (
        <p role="alert" className="text-center text-xs text-danger">
          Không thêm được, thử lại nhé.
        </p>
      )}
    </div>
  );
}
