import { RARITIES, type Rarity } from '../../database/schema/recipes.schema.js';

/**
 * The cook cases ("hòm"). Featured cases have fixed rules; every other case is one tag, with id
 * `<dimension>.<tag>` (e.g. `cuisine.vietnamese`). Clients own the featured copy and the tab names.
 */
export const FEATURED_CASE_IDS = ['all', 'quick', 'epic'] as const;
export type FeaturedCaseId = (typeof FEATURED_CASE_IDS)[number];

/** Tag dimensions that get a tab of cases, in tab order. */
export const TAG_CASE_GROUPS = ['cuisine', 'equipment', 'meal_type', 'technique', 'diet'] as const;
export const CASE_GROUPS = ['featured', ...TAG_CASE_GROUPS] as const;
export type CaseGroup = (typeof CASE_GROUPS)[number];

/** Accepts featured ids and the `<dimension>.<tag>` shape; an unknown tag simply holds no recipe. */
export const CASE_ID_PATTERN = /^(all|quick|epic|[a-z_]+\.[a-z0-9-]+)$/;

export interface CaseCandidate {
  rarity: Rarity;
  totalMinutes: number;
  /** The recipe's tags as case ids (`<dimension>.<tag>`). */
  tagCaseIds: string[];
}

export const QUICK_CASE_MAX_MINUTES = 30;

const FEATURED_RULES: Record<FeaturedCaseId, (recipe: CaseCandidate) => boolean> = {
  all: () => true,
  quick: (recipe) => recipe.totalMinutes <= QUICK_CASE_MAX_MINUTES,
  epic: (recipe) => recipe.rarity === 'pink' || recipe.rarity === 'red',
};

export const tagCaseId = (dimensionSlug: string, tagSlug: string): string => `${dimensionSlug}.${tagSlug}`;

const isFeatured = (caseId: string): caseId is FeaturedCaseId => caseId in FEATURED_RULES;

/** One predicate for both the case list and the draw, so the count a case shows is exactly its pool. */
export const inCase = (caseId: string, recipe: CaseCandidate): boolean =>
  isFeatured(caseId) ? FEATURED_RULES[caseId](recipe) : recipe.tagCaseIds.includes(caseId);

/** Rarest first, then by title, for the case's dish list. */
export function byRarityDesc<T extends { rarity: Rarity; title: string }>(a: T, b: T): number {
  return RARITIES.indexOf(b.rarity) - RARITIES.indexOf(a.rarity) || a.title.localeCompare(b.title, 'vi');
}

export function countByRarity(recipes: ReadonlyArray<{ rarity: Rarity }>): Record<Rarity, number> {
  const counts = Object.fromEntries(RARITIES.map((rarity) => [rarity, 0])) as Record<Rarity, number>;
  for (const recipe of recipes) counts[recipe.rarity]++;
  return counts;
}
