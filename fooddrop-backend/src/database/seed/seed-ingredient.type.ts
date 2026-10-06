import type { IngredientAisle, QuantityUnit } from '../schema/ingredients.schema.js';

/** [name, aliases, aisle, defaultUnit, densityGPerMl?, isFermented?] */
export type SeedIngredient = [
  name: string,
  aliases: string[],
  aisle: IngredientAisle,
  defaultUnit: QuantityUnit,
  densityGPerMl?: number | null,
  isFermented?: boolean,
];
