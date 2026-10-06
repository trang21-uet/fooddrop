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

export function toRecipeDetail(
  row: RecipeRow,
  tags: RecipeTagView[],
  ingredients: RecipeDetail['ingredients'],
): RecipeDetail {
  return {
    ...toRecipeSummary(row, tags),
    sourceUrl: row.sourceUrl,
    updatedAt: row.updatedAt.toISOString(),
    steps: row.steps,
    ingredients,
  };
}
