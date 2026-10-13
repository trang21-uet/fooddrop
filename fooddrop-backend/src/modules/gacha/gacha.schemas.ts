import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';
import { RARITIES } from '../../database/schema/recipes.schema.js';
import { CASE_IDS } from './gacha-cases.js';

export const CASE_TYPES = ['cook'] as const;

// ---- Requests -------------------------------------------------------------------------------

export const createSpinSchema = z.object({
  caseType: z.enum(CASE_TYPES),
  /** Which cook case to open; `GET /gacha/cases` lists them with what they hold. */
  caseId: z.enum(CASE_IDS),
});

export const listSpinsQuerySchema = z.object({
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

// ---- Responses ------------------------------------------------------------------------------

/** What a reel card needs, plus `baseServings` so "Add to grocery" works without another request. */
export const gachaRecipeCardSchema = z.object({
  id: z.uuid(),
  title: z.string(),
  imageUrl: z.string().nullable(),
  rarity: z.enum(RARITIES),
  totalMinutes: z.number().int(),
  difficulty: z.number().int(),
  baseServings: z.number().int(),
});

export const gachaSpinSchema = z.object({
  spinId: z.uuid(),
  caseType: z.enum(CASE_TYPES),
  createdAt: z.iso.datetime(),
  /** Decided by the server; equals `reel[winningIndex]`. */
  result: gachaRecipeCardSchema,
  reel: z.array(gachaRecipeCardSchema),
  winningIndex: z.number().int(),
  /** Where the marker stops inside the winning card, in card widths from its center (−0.4..0.4). */
  offsetJitter: z.number(),
  /** Recipes in the case; a small pool means a repetitive reel, so clients can suggest adding more. */
  poolSize: z.number().int(),
});

export const gachaCasesSchema = z.object({
  items: z.array(
    z.object({
      id: z.enum(CASE_IDS),
      recipeCount: z.number().int(),
      rarityCounts: z.object({
        white: z.number().int(),
        blue: z.number().int(),
        purple: z.number().int(),
        pink: z.number().int(),
        red: z.number().int(),
      }),
      /** Up to `CASE_PREVIEW_SIZE` dishes, rarest first: the case's dish list and the reel shown before a spin. */
      preview: z.array(gachaRecipeCardSchema),
    }),
  ),
});

export const spinHistorySchema = z.object({
  items: z.array(
    z.object({
      id: z.uuid(),
      caseType: z.enum(CASE_TYPES),
      createdAt: z.iso.datetime(),
      /** Null once the recipe was deleted. */
      result: gachaRecipeCardSchema.nullable(),
    }),
  ),
});

export const gachaErrorSchema = z.object({
  statusCode: z.number().int(),
  code: z.enum(['gacha_rate_limit', 'gacha_empty_pool']),
  message: z.string(),
  retryAfterSeconds: z.number().int().positive().optional(),
});

export class CreateSpinDto extends createZodDto('CreateGachaSpin', createSpinSchema) {}
export class ListSpinsQueryDto extends createZodDto('ListGachaSpinsQuery', listSpinsQuerySchema) {}
export class GachaSpinDto extends createZodDto('GachaSpin', gachaSpinSchema, 'output') {}
export class GachaCasesDto extends createZodDto('GachaCases', gachaCasesSchema, 'output') {}
export class SpinHistoryDto extends createZodDto('GachaSpinHistory', spinHistorySchema, 'output') {}
export class GachaErrorDto extends createZodDto('GachaError', gachaErrorSchema, 'output') {}

export type CreateSpin = z.output<typeof createSpinSchema>;
export type GachaRecipeCard = z.output<typeof gachaRecipeCardSchema>;
export type GachaSpin = z.output<typeof gachaSpinSchema>;
export type GachaCases = z.output<typeof gachaCasesSchema>;
export type SpinHistory = z.output<typeof spinHistorySchema>;
