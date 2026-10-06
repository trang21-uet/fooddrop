import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';
import { INGREDIENT_AISLES, QUANTITY_UNITS } from '../../database/schema/ingredients.schema.js';
import { RARITIES } from '../../database/schema/recipes.schema.js';
import { tagSchema } from '../tags/tags.schemas.js';

const commaList = <T extends z.ZodType>(item: T) =>
  z
    .string()
    .transform((value): unknown[] => value.split(',').map((part) => part.trim()).filter(Boolean))
    .pipe(z.array(item).max(30));

// ---- Requests -------------------------------------------------------------------------------

export const recipeStepInputSchema = z.object({
  text: z.string().trim().min(1).max(2000),
  timerSeconds: z.number().int().min(1).max(86_400).optional(),
  timerLabel: z.string().trim().min(1).max(100).optional(),
});

export const recipeIngredientInputSchema = z.object({
  ingredientId: z.uuid(),
  // Raw as written ("1 1/2", "2-3"); the units module converts to g | ml | piece.
  quantity: z.union([z.number().nonnegative().max(1_000_000), z.string().trim().min(1).max(20)]),
  unit: z.string().trim().max(30).nullish(),
  note: z.string().trim().max(200).nullish(),
});

export const recipeInputSchema = z.object({
  title: z.string().trim().min(1).max(200),
  description: z.string().trim().max(2000).nullish(),
  imageUrl: z.url({ protocol: /^https?$/ }).max(2000).nullish(),
  sourceUrl: z.url({ protocol: /^https?$/ }).max(2000).nullish(),
  baseServings: z.number().int().min(1).max(100).default(2),
  totalMinutes: z.number().int().min(1).max(10_080),
  difficulty: z.number().int().min(1).max(5),
  steps: z.array(recipeStepInputSchema).min(1).max(100),
  ingredients: z.array(recipeIngredientInputSchema).max(100).default([]),
  tagIds: z.array(z.number().int().positive()).max(30).default([]),
});

export const listRecipesQuerySchema = z.object({
  // Comma-separated tag ids; OR within a dimension, AND across dimensions.
  tags: commaList(z.coerce.number().int().positive()).optional(),
  rarity: commaList(z.enum(RARITIES)).optional(),
  maxMinutes: z.coerce.number().int().positive().max(10_080).optional(),
  q: z.string().trim().max(100).optional(),
  cursor: z.string().max(200).optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

// ---- Responses ------------------------------------------------------------------------------

const recipeTagSchema = tagSchema.extend({ dimension: z.string() });

const recipeSummarySchema = z.object({
  id: z.uuid(),
  title: z.string(),
  description: z.string().nullable(),
  imageUrl: z.string().nullable(),
  baseServings: z.number().int(),
  totalMinutes: z.number().int(),
  difficulty: z.number().int(),
  rarity: z.enum(RARITIES),
  tags: z.array(recipeTagSchema),
  createdAt: z.iso.datetime(),
});

export const recipeDetailSchema = recipeSummarySchema.extend({
  sourceUrl: z.string().nullable(),
  updatedAt: z.iso.datetime(),
  steps: z.array(
    z.object({
      order: z.number().int(),
      text: z.string(),
      timerSeconds: z.number().int().optional(),
      timerLabel: z.string().optional(),
    }),
  ),
  ingredients: z.array(
    z.object({
      ingredient: z.object({
        id: z.uuid(),
        name: z.string(),
        aisle: z.enum(INGREDIENT_AISLES),
      }),
      quantity: z.number(),
      unit: z.enum(QUANTITY_UNITS),
      note: z.string().nullable(),
    }),
  ),
});

export const recipeListSchema = z.object({
  items: z.array(recipeSummarySchema),
  nextCursor: z.string().nullable(),
});

export class RecipeInputDto extends createZodDto('RecipeInput', recipeInputSchema) {}
export class ListRecipesQueryDto extends createZodDto('ListRecipesQuery', listRecipesQuerySchema) {}
export class RecipeDetailDto extends createZodDto('RecipeDetail', recipeDetailSchema, 'output') {}
export class RecipeListDto extends createZodDto('RecipeList', recipeListSchema, 'output') {}

export type RecipeInput = z.output<typeof recipeInputSchema>;
export type RecipeDetail = z.output<typeof recipeDetailSchema>;
export type RecipeSummary = z.output<typeof recipeListSchema>['items'][number];
export type RecipeTagView = z.output<typeof recipeTagSchema>;
export type ListRecipesQuery = z.output<typeof listRecipesQuerySchema>;
