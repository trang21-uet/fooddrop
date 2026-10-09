import {
  check,
  index,
  integer,
  jsonb,
  numeric,
  pgTable,
  primaryKey,
  smallint,
  text,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { ingredients } from './ingredients.schema.js';
import { units } from './units.schema.js';
import { users } from './users.schema.js';

export interface RecipeStep {
  order: number;
  /** Short heading ("Sơ chế"); optional because imported steps only have content. */
  name?: string;
  /** The instructions themselves. */
  text: string;
  /** Optional tip or warning for the step ("Ướp ít nhất 20 phút"). */
  note?: string;
  /** Object-storage keys of the step photos, in display order. */
  images?: string[];
  timerSeconds?: number;
  timerLabel?: string;
}

export const RARITIES = ['white', 'blue', 'purple', 'pink', 'red'] as const;
export type Rarity = (typeof RARITIES)[number];

// Single place where rarity tiers are defined; thresholds change here only.
const RARITY_SQL = sql`CASE WHEN total_minutes <= 20 AND difficulty <= 1 THEN 'white'
  WHEN total_minutes <= 45 AND difficulty <= 2 THEN 'blue'
  WHEN total_minutes <= 90 AND difficulty <= 3 THEN 'purple'
  WHEN total_minutes <= 180 THEN 'pink'
  ELSE 'red' END`;

export const recipes = pgTable(
  'recipes',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    ownerId: uuid('owner_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    title: text('title').notNull(),
    description: text('description'),
    imageUrl: text('image_url'),
    baseServings: integer('base_servings').notNull().default(2),
    totalMinutes: integer('total_minutes').notNull(),
    difficulty: smallint('difficulty').notNull(),
    rarity: text('rarity').$type<Rarity>().notNull().generatedAlwaysAs(RARITY_SQL),
    steps: jsonb('steps').$type<RecipeStep[]>().notNull(),
    sourceUrl: text('source_url'),
    rawExtract: jsonb('raw_extract'),
    // Millisecond precision so JS Dates round-trip exactly; keyset pagination cursors rely on it.
    createdAt: timestamp('created_at', { withTimezone: true, precision: 3 }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true, precision: 3 }).notNull().defaultNow(),
  },
  (t) => [
    index('recipes_owner_rarity_idx').on(t.ownerId, t.rarity),
    index('recipes_owner_created_idx').on(t.ownerId, t.createdAt.desc(), t.id.desc()),
    check('recipes_base_servings_check', sql`${t.baseServings} > 0`),
    check('recipes_total_minutes_check', sql`${t.totalMinutes} > 0`),
    check('recipes_difficulty_check', sql`${t.difficulty} BETWEEN 1 AND 5`),
  ],
);

export const recipeIngredients = pgTable(
  'recipe_ingredients',
  {
    recipeId: uuid('recipe_id')
      .notNull()
      .references(() => recipes.id, { onDelete: 'cascade' }),
    ingredientId: uuid('ingredient_id')
      .notNull()
      .references(() => ingredients.id),
    // Both optional ("muối, tùy khẩu vị"); `unit` only makes sense next to a quantity.
    quantity: numeric('quantity', { mode: 'number' }),
    unit: text('unit').references(() => units.code),
    note: text('note'),
    sortOrder: integer('sort_order').notNull().default(0),
  },
  (t) => [
    primaryKey({ columns: [t.recipeId, t.ingredientId] }),
    index('recipe_ingredients_ingredient_idx').on(t.ingredientId),
    index('recipe_ingredients_unit_idx').on(t.unit),
    check('recipe_ingredients_quantity_check', sql`${t.quantity} IS NULL OR ${t.quantity} >= 0`),
    check('recipe_ingredients_unit_needs_quantity_check', sql`${t.unit} IS NULL OR ${t.quantity} IS NOT NULL`),
  ],
);
