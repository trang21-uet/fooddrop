import type { QUANTITY_UNITS } from '../database/schema/ingredients.schema.js';
import type { DraftIngredient } from './draft-to-recipe-input.js';

type BaseUnit = (typeof QUANTITY_UNITS)[number];

/** Case- and diacritic-folded, like the catalog's unaccent duplicate check ("Hành Lá" = "hanh la"). */
export const foldName = (text: string): string =>
  text.normalize('NFD').replace(/\p{M}/gu, '').replace(/đ/gi, 'd').trim().toLowerCase();

/** The catalog row a duplicate-name conflict referred to; the closest search hit when none folds equal. */
export function findIngredientByName<T extends { id: string; name: string; aliases: string[] }>(rows: T[], name: string): T {
  const target = foldName(name);
  const match = rows.find((row) => [row.name, ...row.aliases].some((candidate) => foldName(candidate) === target)) ?? rows[0];
  if (!match) throw new Error(`Ingredient "${name}" exists but was not found by search`);
  return match;
}

/** Grocery base unit for a new ingredient, from the unit its first recipe line uses. */
export function ingredientDefaultUnit(item: Pick<DraftIngredient, 'quantity' | 'unit'>, unitKinds: Map<string, string>): BaseUnit {
  const kind = item.unit ? unitKinds.get(item.unit) : undefined;
  if (kind === 'mass') return 'g';
  if (kind === 'volume') return 'ml';
  if (kind === 'count' || (item.quantity !== null && !item.unit)) return 'piece';
  return 'g';
}
