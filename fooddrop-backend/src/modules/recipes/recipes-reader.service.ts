import { BadRequestException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { and, asc, desc, eq, inArray } from 'drizzle-orm';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import {
  ingredients,
  recipeIngredients,
  recipeTags,
  recipes,
  tagDimensions,
  tags,
} from '../../database/schema/index.js';
import { decodeCursor, encodeCursor } from './recipe-cursor.js';
import { buildRecipeFilter } from './recipe-filters.js';
import { toRecipeDetail, toRecipeSummary } from './recipe-mapper.js';
import type {
  ListRecipesQuery,
  RecipeDetail,
  RecipeTagView,
  RecipeSummary,
} from './recipes.schemas.js';

@Injectable()
export class RecipesReaderService {
  constructor(@Inject(DRIZZLE) private readonly db: Database) {}

  /** Another user's recipe is reported as missing, so ids cannot be probed across accounts. */
  async getDetail(ownerId: string, id: string): Promise<RecipeDetail> {
    const [row] = await this.db
      .select()
      .from(recipes)
      .where(and(eq(recipes.id, id), eq(recipes.ownerId, ownerId)));
    if (!row) throw new NotFoundException('Recipe not found');

    const [tagsByRecipe, ingredientRows] = await Promise.all([
      this.loadTags([id]),
      this.db
        .select({
          id: ingredients.id,
          name: ingredients.name,
          aisle: ingredients.aisle,
          quantity: recipeIngredients.quantity,
          unit: recipeIngredients.unit,
          note: recipeIngredients.note,
        })
        .from(recipeIngredients)
        .innerJoin(ingredients, eq(ingredients.id, recipeIngredients.ingredientId))
        .where(eq(recipeIngredients.recipeId, id))
        .orderBy(asc(recipeIngredients.sortOrder)),
    ]);

    return toRecipeDetail(
      row,
      tagsByRecipe.get(id) ?? [],
      ingredientRows.map((r) => ({
        ingredient: { id: r.id, name: r.name, aisle: r.aisle },
        quantity: r.quantity,
        unit: r.unit,
        note: r.note,
      })),
    );
  }

  async list(
    ownerId: string,
    query: ListRecipesQuery,
  ): Promise<{ items: RecipeSummary[]; nextCursor: string | null }> {
    const cursor = query.cursor ? decodeCursor(query.cursor) : null;
    if (query.cursor && !cursor) throw new BadRequestException('Invalid cursor');

    const tagGroups = await this.groupTagsByDimension(query.tags ?? []);
    // One extra row tells us whether another page exists without a COUNT query.
    const rows = await this.db
      .select()
      .from(recipes)
      .where(buildRecipeFilter(ownerId, query, tagGroups, cursor))
      .orderBy(desc(recipes.createdAt), desc(recipes.id))
      .limit(query.limit + 1);

    const page = rows.slice(0, query.limit);
    const tagsByRecipe = await this.loadTags(page.map((r) => r.id));
    const last = page.at(-1);
    return {
      items: page.map((row) => toRecipeSummary(row, tagsByRecipe.get(row.id) ?? [])),
      nextCursor:
        rows.length > query.limit && last ? encodeCursor({ createdAt: last.createdAt, id: last.id }) : null,
    };
  }

  private async groupTagsByDimension(tagIds: number[]): Promise<number[][]> {
    if (tagIds.length === 0) return [];
    const rows = await this.db
      .select({ id: tags.id, dimensionId: tags.dimensionId })
      .from(tags)
      .where(inArray(tags.id, tagIds));
    // A silently ignored id would widen the result set, so unknown ids are rejected instead.
    if (rows.length !== new Set(tagIds).size) throw new BadRequestException('Unknown tag id');
    const groups = new Map<number, number[]>();
    for (const row of rows) groups.set(row.dimensionId, [...(groups.get(row.dimensionId) ?? []), row.id]);
    return [...groups.values()];
  }

  private async loadTags(recipeIds: string[]): Promise<Map<string, RecipeTagView[]>> {
    const byRecipe = new Map<string, RecipeTagView[]>();
    if (recipeIds.length === 0) return byRecipe;
    const rows = await this.db
      .select({
        recipeId: recipeTags.recipeId,
        id: tags.id,
        slug: tags.slug,
        label: tags.label,
        dimension: tagDimensions.slug,
      })
      .from(recipeTags)
      .innerJoin(tags, eq(tags.id, recipeTags.tagId))
      .innerJoin(tagDimensions, eq(tagDimensions.id, tags.dimensionId))
      .where(inArray(recipeTags.recipeId, recipeIds))
      .orderBy(asc(tagDimensions.id), asc(tags.id));
    for (const { recipeId, ...tag } of rows) {
      byRecipe.set(recipeId, [...(byRecipe.get(recipeId) ?? []), tag]);
    }
    return byRecipe;
  }
}
