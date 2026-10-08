import type { RecipeFormValues } from "../recipes/recipe-form/recipe-form-schema";
import type { ParsedRecipeDraft } from "./parser-types";

const FALLBACK_MINUTES = 30;

/** Parser draft → recipe form state. Unmatched ingredients keep an empty id so the form asks the user to add them. */
export function draftToFormValues(draft: ParsedRecipeDraft): RecipeFormValues {
  return {
    title: draft.title,
    description: draft.description ?? "",
    imageUrl: draft.imageUrl ?? "",
    sourceUrl: draft.sourceUrl ?? "",
    baseServings: draft.baseServings,
    totalMinutes: draft.totalMinutes ?? FALLBACK_MINUTES,
    difficulty: draft.difficulty,
    ingredients: draft.ingredients.map((item) => ({
      ingredientId: item.ingredientId ?? "",
      // Show the catalog's name for matches so the visible text is what will be saved.
      ingredientName: item.matchedName ?? item.name,
      quantity: item.quantity === null ? "" : String(Number.parseFloat(item.quantity.toFixed(2))),
      unit: item.unit ?? "",
      note: item.note ?? "",
    })),
    steps:
      draft.steps.length > 0
        ? draft.steps.map((step) => ({
            name: "",
            text: step.text,
            images: [],
            timerMinutes: step.timerSeconds ? Math.min(1440, Math.ceil(step.timerSeconds / 60)) : undefined,
          }))
        : [{ name: "", text: "", images: [] }],
    tagIds: draft.suggestedTagIds,
  };
}
