import type { recipes } from '../../database/schema/index.js';
import type { RecipeDetail, RecipeSummary, RecipeTagView } from './recipes.schemas.js';

type RecipeRow = typeof recipes.$inferSelect;

export function toRecipeSummary(row: RecipeRow, tags: RecipeTagView[]): RecipeSummary {
  return {
    id: row.id,
    title: row.title,
    description: row.description,
    imageUrl: row.imageUrl,
    baseServings: row.baseServings,
    totalMinutes: row.totalMinutes,
    difficulty: row.difficulty,
    rarity: row.rarity,
    tags,
    createdAt: row.createdAt.toISOString(),
  };
}

/** `imageUrls` maps a stored object key to the URL clients load it from. */
export function toRecipeDetail(
  row: RecipeRow,
  tags: RecipeTagView[],
  ingredients: RecipeDetail['ingredients'],
  imageUrls: ReadonlyMap<string, string | null>,
): RecipeDetail {
  return {
    ...toRecipeSummary(row, tags),
    sourceUrl: row.sourceUrl,
    updatedAt: row.updatedAt.toISOString(),
    // Rows saved before step names and photos existed have neither field.
    steps: row.steps.map((step) => ({
      ...step,
      images: (step.images ?? []).map((key) => ({ key, url: imageUrls.get(key) ?? null })),
    })),
    ingredients,
  };
}
