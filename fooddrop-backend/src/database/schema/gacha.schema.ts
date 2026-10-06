import { check, index, jsonb, pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { recipes } from './recipes.schema.js';
import { users } from './users.schema.js';

// Lazy case options are user-defined; Places results are never persisted.
export const lazyOptions = pgTable(
  'lazy_options',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    kind: text('kind').$type<'delivery' | 'restaurant' | 'custom'>().notNull(),
    name: text('name').notNull(),
    deepLink: text('deep_link'),
    placeId: text('place_id'),
  },
  (t) => [
    index('lazy_options_user_idx').on(t.userId),
    check('lazy_options_kind_check', sql`${t.kind} IN ('delivery','restaurant','custom')`),
  ],
);

export const gachaSpins = pgTable(
  'gacha_spins',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    caseType: text('case_type').$type<'cook' | 'lazy'>().notNull(),
    resultRecipeId: uuid('result_recipe_id').references(() => recipes.id, { onDelete: 'set null' }),
    resultLazyPayload: jsonb('result_lazy_payload'),
    context: jsonb('context'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('gacha_spins_user_created_idx').on(t.userId, t.createdAt.desc()),
    check('gacha_spins_case_type_check', sql`${t.caseType} IN ('cook','lazy')`),
  ],
);
