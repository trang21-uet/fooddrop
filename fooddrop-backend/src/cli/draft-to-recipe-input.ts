import type { ParsedRecipeDraft } from '../modules/parser/parser.schemas.js';
import { recipeInputSchema, type RecipeInput } from '../modules/recipes/recipes.schemas.js';

export type DraftIngredient = ParsedRecipeDraft['ingredients'][number];

// Same fallback as the web import form when the source gives no time.
const FALLBACK_MINUTES = 30;

const clip = (text: string | null | undefined, max: number): string | undefined => {
  const trimmed = text?.trim();
  return trimmed ? trimmed.slice(0, max) : undefined;
};

/**
 * Parser draft → recipe input, without a person reviewing the form. `resolveIngredient` returns a catalog id
 * for unmatched lines (the web form asks the user instead). Text is clipped to the input limits, and a
 * repeated ingredient keeps its first line (summed when both amounts share a unit), since a recipe lists
 * each ingredient once.
 */
export async function draftToRecipeInput(
  draft: ParsedRecipeDraft,
  resolveIngredient: (item: DraftIngredient) => Promise<string>,
): Promise<RecipeInput> {
  const lines = new Map<string, { quantity: number | null; unit: string | null; note: string | undefined }>();
  for (const item of draft.ingredients) {
    const ingredientId = item.ingredientId ?? (await resolveIngredient(item));
    const seen = lines.get(ingredientId);
    if (!seen) {
      lines.set(ingredientId, { quantity: item.quantity, unit: item.quantity === null ? null : item.unit, note: clip(item.note, 200) });
    } else if (seen.quantity !== null && item.quantity !== null && seen.unit === item.unit) {
      seen.quantity += item.quantity;
    }
  }

  return recipeInputSchema.parse({
    title: clip(draft.title, 200),
    description: clip(draft.description, 2000),
    // A missing cover should not cost the whole recipe.
    imageUrl: draft.imageUrl && /^https?:\/\//.test(draft.imageUrl) && URL.canParse(draft.imageUrl) && draft.imageUrl.length <= 2000 ? draft.imageUrl : undefined,
    sourceUrl: draft.sourceUrl ?? undefined,
    baseServings: Math.min(100, Math.max(1, draft.baseServings)),
    totalMinutes: Math.min(10_080, draft.totalMinutes ?? FALLBACK_MINUTES),
    difficulty: draft.difficulty,
    ingredients: [...lines].map(([ingredientId, line]) => ({
      ingredientId,
      quantity: line.quantity === null ? undefined : Number(line.quantity.toFixed(2)),
      unit: line.unit ?? undefined,
      note: line.note,
    })),
    steps: draft.steps.map((step) => ({
      name: clip(step.name, 100),
      text: clip(step.text, 2000),
      note: clip(step.note, 500),
      images: step.images.map((image) => image.key),
      timerSeconds: step.timerSeconds,
    })),
    tagIds: [...new Set(draft.suggestedTagIds)],
  });
}
