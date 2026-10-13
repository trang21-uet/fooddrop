import type { Rarity } from '../../database/schema/recipes.schema.js';

/**
 * Relative draw weight of one recipe per rarity tier. A recipe's chance is its weight over the sum
 * of the weights of every recipe in the filtered pool, so the odds normalize over what the user has.
 */
export const RARITY_WEIGHTS: Readonly<Record<Rarity, number>> = {
  white: 50,
  blue: 25,
  purple: 15,
  pink: 7,
  red: 3,
};
