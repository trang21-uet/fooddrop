import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';
import { UNIT_KINDS } from '../../database/schema/units.schema.js';

/** A unit as clients show it. Both names are sent so a locale switch needs no API change. */
export const unitSchema = z.object({
  code: z.string(),
  nameVi: z.string(),
  nameEn: z.string(),
  kind: z.enum(UNIT_KINDS),
});

export class UnitDto extends createZodDto('Unit', unitSchema, 'output') {}

export type UnitView = z.output<typeof unitSchema>;
