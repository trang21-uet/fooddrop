import { check, integer, numeric, pgTable, text } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';

export const UNIT_KINDS = ['mass', 'volume', 'count', 'other'] as const;
export type UnitKind = (typeof UNIT_KINDS)[number];

// Units a recipe line can be written in. Names are stored in both languages so the UI can switch
// locale later; `toBase` is what the grocery list sums in, never what is shown.
export const units = pgTable(
  'units',
  {
    code: text('code').primaryKey(),
    nameVi: text('name_vi').notNull(),
    nameEn: text('name_en').notNull(),
    kind: text('kind').$type<UnitKind>().notNull(),
    // Multiplier to g (mass), ml (volume) or 1 (count). Null for "a pinch": it cannot be summed.
    toBase: numeric('to_base', { mode: 'number' }),
    sortOrder: integer('sort_order').notNull().default(0),
  },
  (t) => [
    check('units_kind_check', sql`${t.kind} IN ('mass','volume','count','other')`),
    check('units_to_base_check', sql`${t.toBase} IS NULL OR ${t.toBase} > 0`),
  ],
);
