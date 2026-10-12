import type { recipes } from '../../database/schema/index.js';
import type { RecipeDetail, RecipeSummary, RecipeTagView } from './recipes.schemas.js';

type RecipeRow = typeof recipes.$inferSelect;

/** `imageUrls` maps a stored object key to the URL clients load it from. */
export function toRecipeSummary(
  row: RecipeRow,
  tags: RecipeTagView[],
  imageUrls: ReadonlyMap<string, string | null>,
): RecipeSummary {
  return {
    id: row.id,
    title: row.title,
    description: row.description,
    imageUrl: row.imageKey ? (imageUrls.get(row.imageKey) ?? null) : row.imageUrl,
    imageKey: row.imageKey,
    baseServings: row.baseServings,
    totalMinutes: row.totalMinutes,
    difficulty: row.difficulty,
    rarity: row.rarity,
    tags,
    createdAt: row.createdAt.toISOString(),
  };
}

export function toRecipeDetail(
  row: RecipeRow,
  tags: RecipeTagView[],
  ingredients: RecipeDetail['ingredients'],
  imageUrls: ReadonlyMap<string, string | null>,
): RecipeDetail {
  return {
    ...toRecipeSummary(row, tags, imageUrls),
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

/** Every stored photo key a recipe references: its cover and its step photos. */
export const recipeImageKeys = (row: { imageKey?: string | null; steps: ReadonlyArray<{ images?: string[] }> }): string[] => [
  ...new Set([...(row.imageKey ? [row.imageKey] : []), ...row.steps.flatMap((step) => step.images ?? [])]),
];
