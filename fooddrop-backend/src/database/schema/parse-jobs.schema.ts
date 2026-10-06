import { check, index, jsonb, pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { users } from './users.schema.js';

export const parseJobs = pgTable(
  'parse_jobs',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    sourceType: text('source_type').$type<'url' | 'image'>().notNull(),
    source: text('source').notNull(),
    status: text('status')
      .$type<'queued' | 'running' | 'succeeded' | 'failed'>()
      .notNull()
      .default('queued'),
    result: jsonb('result'),
    error: text('error'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('parse_jobs_user_created_idx').on(t.userId, t.createdAt.desc()),
    check('parse_jobs_source_type_check', sql`${t.sourceType} IN ('url','image')`),
    check('parse_jobs_status_check', sql`${t.status} IN ('queued','running','succeeded','failed')`),
  ],
);
