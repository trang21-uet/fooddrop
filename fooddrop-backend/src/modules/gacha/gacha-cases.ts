import { RARITIES, type Rarity } from '../../database/schema/recipes.schema.js';

/** The cook cases ("hòm"). Clients own the copy and colours per id; which recipes a case holds is decided here. */
export const CASE_IDS = ['all', 'breakfast', 'lunch', 'dinner', 'quick', 'epic'] as const;
export type CaseId = (typeof CASE_IDS)[number];

export interface CaseCandidate {
  rarity: Rarity;
  totalMinutes: number;
  /** Slugs of the recipe's `meal_type` tags. */
  mealTypes: string[];
}

export const QUICK_CASE_MAX_MINUTES = 30;

const RULES: Record<CaseId, (recipe: CaseCandidate) => boolean> = {
  all: () => true,
  breakfast: (recipe) => recipe.mealTypes.includes('breakfast'),
  lunch: (recipe) => recipe.mealTypes.includes('lunch'),
  dinner: (recipe) => recipe.mealTypes.includes('dinner'),
  quick: (recipe) => recipe.totalMinutes <= QUICK_CASE_MAX_MINUTES,
  epic: (recipe) => recipe.rarity === 'pink' || recipe.rarity === 'red',
};

/** One predicate for both the case list and the draw, so the count a case shows is exactly its pool. */
export const inCase = (caseId: CaseId, recipe: CaseCandidate): boolean => RULES[caseId](recipe);

/** Rarest first, then by title, for the case's dish list. */
export function byRarityDesc<T extends { rarity: Rarity; title: string }>(a: T, b: T): number {
  return RARITIES.indexOf(b.rarity) - RARITIES.indexOf(a.rarity) || a.title.localeCompare(b.title, 'vi');
}

export function countByRarity(recipes: ReadonlyArray<{ rarity: Rarity }>): Record<Rarity, number> {
  const counts = Object.fromEntries(RARITIES.map((rarity) => [rarity, 0])) as Record<Rarity, number>;
  for (const recipe of recipes) counts[recipe.rarity]++;
  return counts;
}
