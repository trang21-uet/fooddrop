"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import { FormProvider, useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";
import { recipesQueryKey } from "../use-recipes-query";
import { RecipeBasicsFields } from "./recipe-basics-fields";
import { EMPTY_RECIPE_FORM, recipeFormSchema, toRecipeInput, type RecipeFormValues } from "./recipe-form-schema";
import { RecipeIngredientsField } from "./recipe-ingredients-field";
import { RecipeStepsField } from "./recipe-steps-field";
import { RecipeTagPicker } from "./recipe-tag-picker";
import { UploadActivityContext } from "./upload-activity";

interface RecipeFormProps {
  heading?: string;
  /** Imported drafts arrive with unmatched ingredients; offer to add them to the catalog in one click. */
  offerBulkIngredientAdd?: boolean;
  /** Present when editing; the form PUTs to this recipe instead of creating a new one. */
  recipeId?: string;
  initialValues?: RecipeFormValues;
}

export function RecipeForm({ heading, offerBulkIngredientAdd, recipeId, initialValues = EMPTY_RECIPE_FORM }: RecipeFormProps) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [serverError, setServerError] = useState<string | null>(null);
  const [uploading, setUploading] = useState(0);
  const uploadActivity = useMemo(
    () => ({ begin: (count: number) => setUploading((n) => n + count), end: (count: number) => setUploading((n) => n - count) }),
    [],
  );
  const methods = useForm<RecipeFormValues>({
    resolver: zodResolver(recipeFormSchema),
    defaultValues: initialValues,
  });

  const onSubmit = async (values: RecipeFormValues) => {
    setServerError(null);
    if (uploading > 0) return;
    const body = toRecipeInput(values);
    try {
      const saved = recipeId
        ? unwrap(await apiClient.PUT("/recipes/{id}", { params: { path: { id: recipeId } }, body }))
        : unwrap(await apiClient.POST("/recipes", { body }));
      await queryClient.invalidateQueries({ queryKey: recipesQueryKey });
      router.push(`/recipes/${saved.id}`);
      router.refresh();
    } catch (error) {
      setServerError(error instanceof Error ? error.message : "Không lưu được công thức.");
    }
  };

  const { isSubmitting } = methods.formState;
  return (
    <FormProvider {...methods}>
      <UploadActivityContext.Provider value={uploadActivity}>
      <form onSubmit={methods.handleSubmit(onSubmit)} noValidate className="flex max-w-3xl flex-col gap-8">
        <h1 className="text-2xl font-bold tracking-tight">{heading ?? (recipeId ? "Sửa công thức" : "Thêm công thức")}</h1>
        <RecipeBasicsFields />
        <RecipeIngredientsField offerBulkAdd={offerBulkIngredientAdd} />
        <RecipeStepsField />
        <RecipeTagPicker />
        {serverError && (
          <p role="alert" className="text-sm text-danger">
            {serverError}
          </p>
        )}
        <div className="flex gap-3">
          <Button type="submit" disabled={isSubmitting || uploading > 0}>
            {isSubmitting ? "Đang lưu…" : uploading > 0 ? "Đang tải ảnh…" : "Lưu công thức"}
          </Button>
          <Button variant="secondary" onClick={() => router.back()}>
            Hủy
          </Button>
        </div>
      </form>
      </UploadActivityContext.Provider>
    </FormProvider>
  );
}
