"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useQueryClient } from "@tanstack/react-query";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import { FormProvider, useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { ChevronLeftIcon } from "@/components/ui/icons";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";
import { recipesQueryKey } from "../use-recipes-query";
import { RecipeBasicsFields } from "./recipe-basics-fields";
import { RecipeCoverImageField } from "./recipe-cover-image-field";
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
        <form onSubmit={methods.handleSubmit(onSubmit)} noValidate className="flex flex-col gap-6">
          <Link
            href="/recipes"
            className="flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-muted transition hover:text-foreground"
          >
            <ChevronLeftIcon width={16} height={16} />
            Tất cả công thức
          </Link>
          <h1 className="text-3xl leading-tight font-extrabold tracking-tight sm:text-[40px]">
            {heading ?? (recipeId ? "Sửa công thức" : "Thêm công thức")}
          </h1>
          <div className="grid items-start gap-7 lg:grid-cols-[minmax(0,1fr)_minmax(280px,360px)]">
            <div className="flex min-w-0 flex-col gap-6">
              <RecipeBasicsFields />
              <RecipeIngredientsField offerBulkAdd={offerBulkIngredientAdd} />
              <RecipeStepsField />
            </div>
            <aside className="flex flex-col gap-6">
              <RecipeCoverImageField />
              <RecipeTagPicker />
            </aside>
          </div>

          {/* Pinned to the bottom of the viewport so saving never needs a scroll; only the form moves under it. */}
          <div className="sticky bottom-3 z-10 flex flex-wrap items-center justify-end gap-3 rounded-2xl border border-border bg-surface/95 px-4 py-3 shadow-[0_-8px_32px_rgb(0_0_0/0.45)] backdrop-blur">
            {serverError && (
              <p role="alert" className="mr-auto text-sm text-danger">
                {serverError}
              </p>
            )}
            <Button variant="secondary" onClick={() => router.back()}>
              Hủy
            </Button>
            <Button
              type="submit"
              disabled={isSubmitting || uploading > 0}
              className="shadow-[0_0_22px_-4px_rgb(255_138_31/0.7)]"
            >
              {isSubmitting ? "Đang lưu…" : uploading > 0 ? "Đang tải ảnh…" : "Lưu công thức"}
            </Button>
          </div>
        </form>
      </UploadActivityContext.Provider>
    </FormProvider>
  );
}
