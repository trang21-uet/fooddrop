import { InvalidQuantityError, parseAmount } from '../units/normalize-quantity.js';
import { lookupUnitAlias } from '../units/unit-aliases.js';
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

const round2 = (value: number): number => Math.round(value * 100) / 100;

function buildIngredient(
  raw: RawRecipe['ingredients'][number],
  match: (name: string) => CatalogIngredient | null,
): DraftIngredient {
  const catalogEntry = match(raw.name);
  const hasQuantity = raw.quantity !== null && raw.quantity !== undefined && raw.quantity !== '';
  let quantity: number | null = null;
  let unit: string | null = null;
  let unitNote: string | undefined;
  if (hasQuantity) {
    try {
      const amount = parseAmount(raw.quantity!);
      const rawUnit = raw.unit?.trim();
      // A bare "oz" next to a liquid (milk, stock) means fluid ounces, not weight.
      const alias = rawUnit ? lookupUnitAlias(rawUnit, { liquid: catalogEntry?.defaultUnit === 'ml' }) : undefined;
      if (!rawUnit) {
        quantity = round2(amount);
      } else if (alias) {
        // The cook's own unit survives ("2 tbsp" -> 2 thìa canh); only units outside the catalog are converted.
        quantity = round2(amount * alias.factor);
        unit = alias.code;
      } else {
        // "2 sachets": keep the original wording for the user instead of inventing a number.
        unitNote = `${raw.quantity} ${rawUnit}`;
      }
    } catch (error) {
      // "a pinch", "some": same, the wording is the only information there is.
      if (!(error instanceof InvalidQuantityError)) throw error;
      unitNote = [raw.quantity, raw.unit].filter(Boolean).join(' ');
    }
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
