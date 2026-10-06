import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';
import { INGREDIENT_AISLES, QUANTITY_UNITS } from '../../database/schema/ingredients.schema.js';

export const ingredientSchema = z.object({
  id: z.uuid(),
  name: z.string(),
  aliases: z.array(z.string()),
  aisle: z.enum(INGREDIENT_AISLES),
  defaultUnit: z.enum(QUANTITY_UNITS),
  densityGPerMl: z.number().nullable(),
  isFermented: z.boolean(),
});

export const searchIngredientsQuerySchema = z.object({
  q: z.string().trim().max(100).optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

export const createIngredientSchema = z.object({
  name: z.string().trim().min(1).max(100),
  aliases: z.array(z.string().trim().min(1).max(100)).max(20).default([]),
  aisle: z.enum(INGREDIENT_AISLES).default('other'),
  defaultUnit: z.enum(QUANTITY_UNITS).default('g'),
  densityGPerMl: z.number().positive().max(25).nullable().default(null),
});

export class IngredientDto extends createZodDto('Ingredient', ingredientSchema, 'output') {}
export class SearchIngredientsQueryDto extends createZodDto(
  'SearchIngredientsQuery',
  searchIngredientsQuerySchema,
) {}
export class CreateIngredientDto extends createZodDto('CreateIngredient', createIngredientSchema) {}
