import { fetchRecipeDetail } from "@/features/recipes/fetch-recipe-detail";
import { RecipeForm } from "@/features/recipes/recipe-form/recipe-form";
import { toFormValues } from "@/features/recipes/recipe-form/recipe-form-schema";

export const metadata = { title: "Sửa công thức · Food Drop" };

export default async function EditRecipePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const recipe = await fetchRecipeDetail(id);
  return <RecipeForm recipeId={id} initialValues={toFormValues(recipe)} />;
}
