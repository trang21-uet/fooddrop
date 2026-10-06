import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';

export const tagSchema = z.object({
  id: z.number().int(),
  slug: z.string(),
  label: z.string(),
});

export const tagDimensionSchema = z.object({
  id: z.number().int(),
  slug: z.string(),
  label: z.string(),
  tags: z.array(tagSchema),
});

export class TagDimensionDto extends createZodDto('TagDimension', tagDimensionSchema, 'output') {}
