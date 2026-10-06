"use client";

import { useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { apiClient } from "@/lib/api/api-client";
import { recipesQueryKey } from "./use-recipes-query";

export function DeleteRecipeButton({ recipeId }: { recipeId: string }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onDelete = async () => {
    if (!window.confirm("Xóa công thức này? Không thể hoàn tác.")) return;
    setPending(true);
    setError(null);
    try {
      const { response } = await apiClient.DELETE("/recipes/{id}", { params: { path: { id: recipeId } } });
      if (!response.ok) throw new Error(`Delete failed (${response.status})`);
      await queryClient.invalidateQueries({ queryKey: recipesQueryKey });
      router.replace("/recipes");
    } catch {
      setError("Không xóa được công thức. Thử lại nhé.");
      setPending(false);
    }
  };

  return (
    <>
      <Button variant="danger" onClick={onDelete} disabled={pending}>
        {pending ? "Đang xóa…" : "Xóa"}
      </Button>
      {error && (
        <span role="alert" className="text-sm text-danger">
          {error}
        </span>
      )}
    </>
  );
}
