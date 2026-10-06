import { PgDialect } from 'drizzle-orm/pg-core';
import { buildRecipeFilter } from './recipe-filters.js';

const dialect = new PgDialect();
const render = (...args: Parameters<typeof buildRecipeFilter>) => dialect.sqlToQuery(buildRecipeFilter(...args));
const OWNER = '3f1e8a52-6d0b-4c8e-9a41-2b7f0c1d5e9a';

describe('buildRecipeFilter', () => {
  it('always scopes to the owner', () => {
    const { sql, params } = render(OWNER, {}, [], null);
    expect(sql).toContain('"recipes"."owner_id" = $1');
    expect(params[0]).toBe(OWNER);
  });

  it('adds one EXISTS per tag dimension (AND across, OR within)', () => {
    const { sql, params } = render(OWNER, {}, [[1, 2], [7]], null);
    expect(sql.match(/EXISTS/g)).toHaveLength(2);
    expect(sql).toContain('"recipe_tags"."tag_id" in ($2, $3)');
    expect(params).toEqual([OWNER, 1, 2, 7]);
  });

  it('adds no tag clause when nothing was requested', () => {
    expect(render(OWNER, {}, [], null).sql).not.toContain('EXISTS');
  });

  it('applies rarity, max minutes and escaped text search', () => {
    const { sql, params } = render(OWNER, { rarity: ['red', 'pink'], maxMinutes: 30, q: '50%_off' }, [], null);
    expect(sql).toContain('"recipes"."rarity" in');
    expect(sql).toContain('"recipes"."total_minutes" <=');
    expect(sql).toContain('unaccent');
    expect(params).toContain('%50\\%\\_off%');
  });

  it('applies the keyset cursor as a row comparison', () => {
    const cursor = { createdAt: new Date('2026-10-06T10:00:00.000Z'), id: OWNER };
    const { sql, params } = render(OWNER, {}, [], cursor);
    expect(sql).toContain('< ($2::timestamptz, $3::uuid)');
    expect(params).toEqual([OWNER, '2026-10-06T10:00:00.000Z', OWNER]);
  });
});
