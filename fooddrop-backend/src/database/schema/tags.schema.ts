import {
  check,
  index,
  integer,
  numeric,
  pgTable,
  primaryKey,
  serial,
  text,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { recipes } from './recipes.schema.js';

export const tagDimensions = pgTable('tag_dimensions', {
  id: serial('id').primaryKey(),
  slug: text('slug').notNull().unique(),
  label: text('label').notNull(),
});

export const tags = pgTable(
  'tags',
  {
    id: serial('id').primaryKey(),
    dimensionId: integer('dimension_id')
      .notNull()
      .references(() => tagDimensions.id),
    slug: text('slug').notNull(),
    label: text('label').notNull(),
  },
  (t) => [unique('tags_dimension_slug_unique').on(t.dimensionId, t.slug)],
);

export const recipeTags = pgTable(
  'recipe_tags',
  {
    recipeId: uuid('recipe_id')
      .notNull()
      .references(() => recipes.id, { onDelete: 'cascade' }),
    tagId: integer('tag_id')
      .notNull()
      .references(() => tags.id),
  },
  (t) => [
    primaryKey({ columns: [t.recipeId, t.tagId] }),
    index('recipe_tags_tag_idx').on(t.tagId, t.recipeId),
  ],
);

// Context boosts for the gacha (consumed in phase 08).
export const weatherBoosts = pgTable(
  'weather_boosts',
  {
    tagId: integer('tag_id')
      .notNull()
      .references(() => tags.id),
    condition: text('condition').$type<'rain' | 'cold' | 'hot' | 'clear'>().notNull(),
    weightMultiplier: numeric('weight_multiplier', { mode: 'number' }).notNull().default(1.5),
  },
  (t) => [
    primaryKey({ columns: [t.tagId, t.condition] }),
    check('weather_boosts_condition_check', sql`${t.condition} IN ('rain','cold','hot','clear')`),
  ],
);
