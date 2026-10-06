import { Suspense } from "react";
import { RecipeListView } from "@/features/recipes/recipe-list-view";

export const metadata = { title: "Công thức · Food Drop" };

export default function RecipesPage() {
  // useSearchParams (filters in the URL) requires a Suspense boundary.
  return (
    <Suspense>
      <RecipeListView />
    </Suspense>
  );
}
