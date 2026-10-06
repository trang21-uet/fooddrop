import { fetchRecipeDetail } from "@/features/recipes/fetch-recipe-detail";
import { RecipeDetailView } from "@/features/recipes/recipe-detail";

export async function generateMetadata({ params }: { params: Promise<{ id: string }> }) {
  const recipe = await fetchRecipeDetail((await params).id);
  return { title: `${recipe.title} · Food Drop` };
}

export default async function RecipeDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const recipe = await fetchRecipeDetail((await params).id);
  return <RecipeDetailView recipe={recipe} />;
}
