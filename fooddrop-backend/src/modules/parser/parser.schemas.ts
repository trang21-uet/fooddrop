import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';
import { QUANTITY_UNITS } from '../../database/schema/ingredients.schema.js';
import { PARSE_ERROR_CODES } from './parse-job-error.js';

// ---- Extractor output (JSON-LD and Claude both produce this) --------------------------------

const rawQuantity = z.union([z.number().nonnegative().max(1_000_000), z.string().trim().max(40)]);

/** Raw as written: quantities and units are converted by code, never by the model. */
export const rawRecipeSchema = z.object({
  title: z.string().trim().min(1).max(200),
  description: z.string().trim().max(2000).nullish(),
  imageUrl: z.string().trim().max(2000).nullish(),
  servings: z.number().positive().max(100).nullish(),
  totalMinutes: z.number().positive().max(10_080).nullish(),
  difficulty: z.number().int().min(1).max(5).nullish(),
  ingredients: z
    .array(
      z.object({
        name: z.string().trim().min(1).max(200),
        quantity: rawQuantity.nullish(),
        unit: z.string().trim().max(40).nullish(),
        note: z.string().trim().max(300).nullish(),
      }),
    )
    .max(100),
  steps: z
    .array(
      z.object({
        text: z.string().trim().min(1).max(4000),
        timerSeconds: z.number().positive().max(86_400).nullish(),
      }),
    )
    .max(100),
  /** Tag slugs from the catalog (LLM) or free-form keywords (JSON-LD); matched in `draft-builder`. */
  suggestedTags: z.array(z.string().trim().max(60)).max(20).default([]),
});
export type RawRecipe = z.output<typeof rawRecipeSchema>;

// ---- Requests -------------------------------------------------------------------------------

// Exactly one of url / imageKey (an object, not a union, so it can back a DTO class).
export const createParseJobSchema = z
  .object({
    url: z.url({ protocol: /^https?$/ }).max(2000).optional(),
    imageKey: z.string().min(1).max(300).optional(),
  })
  .refine((value) => (value.url === undefined) !== (value.imageKey === undefined), {
    message: 'Provide exactly one of url or imageKey',
  });

// ---- Responses ------------------------------------------------------------------------------

export const parsedRecipeDraftSchema = z.object({
  source: z.enum(['json-ld', 'llm-text', 'llm-vision']),
  title: z.string(),
  description: z.string().nullable(),
  imageUrl: z.string().nullable(),
  sourceUrl: z.string().nullable(),
  baseServings: z.number().int(),
  totalMinutes: z.number().int().nullable(),
  difficulty: z.number().int(),
  ingredients: z.array(
    z.object({
      /** Name as written in the source, without quantity or preparation. */
      name: z.string(),
      quantity: z.number(),
      unit: z.enum(QUANTITY_UNITS),
      note: z.string().nullable(),
      /** Catalog match (id and its canonical name); null means the client must create the ingredient (`isNew`). */
      matchedName: z.string().nullable(),
      ingredientId: z.uuid().nullable(),
      isNew: z.boolean(),
    }),
  ),
  steps: z.array(z.object({ text: z.string(), timerSeconds: z.number().int().optional() })),
  suggestedTagIds: z.array(z.number().int()),
});

export const parseJobSchema = z.object({
  id: z.uuid(),
  status: z.enum(['queued', 'running', 'succeeded', 'failed']),
  sourceType: z.enum(['url', 'image']),
  errorCode: z.enum(PARSE_ERROR_CODES).nullable(),
  result: parsedRecipeDraftSchema.nullable(),
  createdAt: z.iso.datetime(),
});

export class CreateParseJobDto extends createZodDto('CreateParseJob', createParseJobSchema) {}
export class ParseJobDto extends createZodDto('ParseJob', parseJobSchema, 'output') {}

export type ParsedRecipeDraft = z.output<typeof parsedRecipeDraftSchema>;
export type ParseJobView = z.output<typeof parseJobSchema>;
