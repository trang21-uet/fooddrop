import { and, eq, inArray, sql, type SQL } from 'drizzle-orm';
import { recipeTags, recipes } from '../../database/schema/index.js';
import type { RecipeCursor } from './recipe-cursor.js';
import type { ListRecipesQuery } from './recipes.schemas.js';

const escapeLike = (text: string): string => text.replace(/[\\%_]/g, '\\$&');

/**
 * WHERE clause for the recipe list. Always scoped to the owner; `tagGroups` holds the requested tag
 * ids already grouped by dimension, giving AND across dimensions and OR within one — one EXISTS
 * per dimension, served by the (tag_id, recipe_id) index.
 */
export function buildRecipeFilter(
  ownerId: string,
  query: Pick<ListRecipesQuery, 'rarity' | 'maxMinutes' | 'q'>,
  tagGroups: number[][],
  cursor: RecipeCursor | null,
): SQL {
  const conditions: SQL[] = [eq(recipes.ownerId, ownerId)];

  for (const tagIds of tagGroups) {
    conditions.push(
      sql`EXISTS (SELECT 1 FROM ${recipeTags} WHERE ${recipeTags.recipeId} = ${recipes.id} AND ${inArray(recipeTags.tagId, tagIds)})`,
    );
  }
  if (query.rarity?.length) conditions.push(inArray(recipes.rarity, query.rarity));
  if (query.maxMinutes) conditions.push(sql`${recipes.totalMinutes} <= ${query.maxMinutes}`);
  if (query.q) {
    const pattern = `%${escapeLike(query.q)}%`;
    conditions.push(
      sql`(unaccent(${recipes.title}) ILIKE unaccent(${pattern}) OR unaccent(coalesce(${recipes.description}, '')) ILIKE unaccent(${pattern}))`,
    );
  }
  if (cursor) {
    // Keyset pagination: strictly after the last row of the previous page in (created_at, id) DESC order.
    conditions.push(
      sql`(${recipes.createdAt}, ${recipes.id}) < (${cursor.createdAt.toISOString()}::timestamptz, ${cursor.id}::uuid)`,
    );
  }
  return and(...conditions)!;
}
