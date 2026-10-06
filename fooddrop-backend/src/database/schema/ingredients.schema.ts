import { boolean, check, numeric, pgTable, text, uuid } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';

export const INGREDIENT_AISLES = [
  'produce',
  'meat',
  'seafood',
  'dairy',
  'pantry',
  'spices',
  'frozen',
  'other',
] as const;
export type IngredientAisle = (typeof INGREDIENT_AISLES)[number];

export const QUANTITY_UNITS = ['g', 'ml', 'piece'] as const;
export type QuantityUnit = (typeof QUANTITY_UNITS)[number];

// Canonical ingredients drive grocery aggregation and ingredient tags.
export const ingredients = pgTable(
  'ingredients',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    name: text('name').notNull().unique(),
    aliases: text('aliases')
      .array()
      .notNull()
      .default(sql`'{}'::text[]`),
    aisle: text('aisle').$type<IngredientAisle>().notNull(),
    // Unit used when summing this ingredient across recipes (eggs: piece, milk: ml, flour: g).
    defaultUnit: text('default_unit').$type<QuantityUnit>().notNull().default('g'),
    densityGPerMl: numeric('density_g_per_ml', { mode: 'number' }),
    isFermented: boolean('is_fermented').notNull().default(false),
  },
  (t) => [
    check(
      'ingredients_aisle_check',
      sql`${t.aisle} IN ('produce','meat','seafood','dairy','pantry','spices','frozen','other')`,
    ),
    check('ingredients_default_unit_check', sql`${t.defaultUnit} IN ('g','ml','piece')`),
  ],
);
