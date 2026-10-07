import type { QuantityUnit } from '../../database/schema/ingredients.schema.js';
import { InvalidQuantityError, normalizeQuantity } from '../units/normalize-quantity.js';
import { createIngredientMatcher, matchTagIds, type CatalogIngredient, type CatalogTag } from './ingredient-matcher.js';
import type { ParsedRecipeDraft, RawRecipe } from './parser.schemas.js';

export interface DraftContext {
  source: ParsedRecipeDraft['source'];
  sourceUrl: string | null;
  catalog: CatalogIngredient[];
  tags: CatalogTag[];
}

const clamp = (value: number, min: number, max: number): number => Math.min(max, Math.max(min, value));

/** Used when the source (JSON-LD) says nothing; the user adjusts it in the editable draft. */
export function guessDifficulty(ingredientCount: number, stepCount: number, totalMinutes: number | null): number {
  return clamp(Math.round(ingredientCount / 6 + stepCount / 5 + (totalMinutes ?? 30) / 60), 1, 5);
}

function absoluteHttpUrl(value: string | null | undefined, base: string | null): string | null {
  if (!value) return null;
  try {
    const url = new URL(value, base ?? undefined);
    return url.protocol === 'http:' || url.protocol === 'https:' ? url.toString().slice(0, 2000) : null;
  } catch {
    return null;
  }
}

function joinNotes(...parts: Array<string | null | undefined>): string | null {
  const text = parts.filter((part): part is string => Boolean(part?.trim())).join('; ');
  return text ? text.slice(0, 200) : null;
}

type DraftIngredient = ParsedRecipeDraft['ingredients'][number];

function buildIngredient(
  raw: RawRecipe['ingredients'][number],
  match: (name: string) => CatalogIngredient | null,
): DraftIngredient {
  const catalogEntry = match(raw.name);
  // A new ingredient has no catalog unit or density, so it keeps whatever dimension the source used.
  const info = catalogEntry ?? { defaultUnit: 'g' as QuantityUnit, densityGPerMl: null };
  const hasQuantity = raw.quantity !== null && raw.quantity !== undefined && raw.quantity !== '';
  let quantity = 0;
  let unit: QuantityUnit = info.defaultUnit;
  let unitNote: string | undefined;
  try {
    if (hasQuantity) {
      const normalized = normalizeQuantity(raw.quantity!, raw.unit, info);
      ({ quantity, unit } = normalized);
      unitNote = normalized.note;
    }
  } catch (error) {
    // "a pinch", "some": keep the original wording for the user instead of inventing a number.
    if (!(error instanceof InvalidQuantityError)) throw error;
    unitNote = [raw.quantity, raw.unit].filter(Boolean).join(' ');
  }
  return {
    name: raw.name,
    quantity,
    unit,
    note: joinNotes(raw.note, unitNote),
    ingredientId: catalogEntry?.id ?? null,
    matchedName: catalogEntry?.name ?? null,
    isNew: catalogEntry === null,
  };
}

/** Turns extractor output into the draft clients edit: units normalized, ingredients and tags matched. */
export function buildDraft(raw: RawRecipe, context: DraftContext): ParsedRecipeDraft {
  const match = createIngredientMatcher(context.catalog);
  const totalMinutes = raw.totalMinutes ? clamp(Math.round(raw.totalMinutes), 1, 10_080) : null;
  const ingredients = raw.ingredients.slice(0, 100).map((ingredient) => buildIngredient(ingredient, match));
  const steps = raw.steps.slice(0, 100).map((step) => ({
    text: step.text.slice(0, 2000),
    ...(step.timerSeconds ? { timerSeconds: clamp(Math.round(step.timerSeconds), 1, 86_400) } : {}),
  }));

  return {
    source: context.source,
    title: raw.title.slice(0, 200),
    description: raw.description?.slice(0, 2000) || null,
    imageUrl: absoluteHttpUrl(raw.imageUrl, context.sourceUrl),
    sourceUrl: absoluteHttpUrl(context.sourceUrl, null),
    baseServings: raw.servings ? clamp(Math.round(raw.servings), 1, 100) : 2,
    totalMinutes,
    difficulty: raw.difficulty ?? guessDifficulty(ingredients.length, steps.length, totalMinutes),
    ingredients,
    steps,
    suggestedTagIds: matchTagIds(raw.suggestedTags, context.tags),
  };
}
