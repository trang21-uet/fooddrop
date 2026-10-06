import { BadRequestException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { and, eq, inArray, sql } from 'drizzle-orm';
import { DRIZZLE, type Database, type Transaction } from '../../database/database.module.js';
import { ingredients, recipeIngredients, recipeTags, recipes, tags } from '../../database/schema/index.js';
import { InvalidQuantityError, normalizeQuantity } from '../units/normalize-quantity.js';
import { RecipesReaderService } from './recipes-reader.service.js';
import type { RecipeDetail, RecipeInput } from './recipes.schemas.js';

type IngredientRow = typeof recipeIngredients.$inferInsert;

@Injectable()
export class RecipesService {
  constructor(
    @Inject(DRIZZLE) private readonly db: Database,
    private readonly reader: RecipesReaderService,
  ) {}

  async create(ownerId: string, input: RecipeInput): Promise<RecipeDetail> {
    const ingredientRows = await this.buildIngredientRows(input);
    await this.assertTagsExist(input.tagIds);

    const id = await this.db.transaction(async (tx) => {
      const [created] = await tx
        .insert(recipes)
        .values({ ...this.recipeColumns(input), ownerId })
        .returning({ id: recipes.id });
      await this.writeChildren(tx, created!.id, ingredientRows, input.tagIds);
      return created!.id;
    });
    return this.reader.getDetail(ownerId, id);
  }

  /** Full replace (PUT): scalar fields are overwritten and ingredient/tag links are rebuilt. */
  async update(ownerId: string, id: string, input: RecipeInput): Promise<RecipeDetail> {
    const ingredientRows = await this.buildIngredientRows(input);
    await this.assertTagsExist(input.tagIds);

    await this.db.transaction(async (tx) => {
      const updated = await tx
        .update(recipes)
        // DB clock, like created_at, so the two never disagree when app and DB clocks drift.
        .set({ ...this.recipeColumns(input), updatedAt: sql`now()` })
        .where(and(eq(recipes.id, id), eq(recipes.ownerId, ownerId)))
        .returning({ id: recipes.id });
      if (updated.length === 0) throw new NotFoundException('Recipe not found');

      await tx.delete(recipeIngredients).where(eq(recipeIngredients.recipeId, id));
      await tx.delete(recipeTags).where(eq(recipeTags.recipeId, id));
      await this.writeChildren(tx, id, ingredientRows, input.tagIds);
    });
    return this.reader.getDetail(ownerId, id);
  }

  async remove(ownerId: string, id: string): Promise<void> {
    const deleted = await this.db
      .delete(recipes)
      .where(and(eq(recipes.id, id), eq(recipes.ownerId, ownerId)))
      .returning({ id: recipes.id });
    if (deleted.length === 0) throw new NotFoundException('Recipe not found');
  }

  private recipeColumns(input: RecipeInput) {
    return {
      title: input.title,
      description: input.description ?? null,
      imageUrl: input.imageUrl ?? null,
      sourceUrl: input.sourceUrl ?? null,
      baseServings: input.baseServings,
      totalMinutes: input.totalMinutes,
      difficulty: input.difficulty,
      // Order is positional so clients cannot send gaps or duplicates.
      steps: input.steps.map((step, index) => ({ ...step, order: index + 1 })),
    };
  }

  private async writeChildren(
    tx: Transaction,
    recipeId: string,
    ingredientRows: Omit<IngredientRow, 'recipeId'>[],
    tagIds: number[],
  ): Promise<void> {
    if (ingredientRows.length > 0) {
      await tx.insert(recipeIngredients).values(ingredientRows.map((row) => ({ ...row, recipeId })));
    }
    if (tagIds.length > 0) {
      await tx.insert(recipeTags).values(tagIds.map((tagId) => ({ recipeId, tagId })));
    }
  }

  /** Normalizes each raw `{quantity, unit}` with the catalog's density/default unit. */
  private async buildIngredientRows(input: RecipeInput): Promise<Omit<IngredientRow, 'recipeId'>[]> {
    const ids = input.ingredients.map((item) => item.ingredientId);
    if (new Set(ids).size !== ids.length) {
      throw new BadRequestException('Each ingredient can appear only once per recipe');
    }
    if (ids.length === 0) return [];

    const catalog = await this.db
      .select({ id: ingredients.id, defaultUnit: ingredients.defaultUnit, densityGPerMl: ingredients.densityGPerMl })
      .from(ingredients)
      .where(inArray(ingredients.id, ids));
    const byId = new Map(catalog.map((row) => [row.id, row]));

    return input.ingredients.map((item, sortOrder) => {
      const info = byId.get(item.ingredientId);
      if (!info) throw new BadRequestException(`Unknown ingredient ${item.ingredientId}`);
      try {
        const normalized = normalizeQuantity(item.quantity, item.unit, info);
        // An unconvertible unit ("1 handful") survives in the note rather than being lost.
        const note = [item.note, normalized.note].filter(Boolean).join(' — ') || null;
        return {
          ingredientId: item.ingredientId,
          quantity: normalized.quantity,
          unit: normalized.unit,
          note,
          sortOrder,
        };
      } catch (error) {
        if (error instanceof InvalidQuantityError) {
          throw new BadRequestException(`Invalid quantity "${String(item.quantity)}" for ingredient ${item.ingredientId}`);
        }
        throw error;
      }
    });
  }

  private async assertTagsExist(tagIds: number[]): Promise<void> {
    const unique = [...new Set(tagIds)];
    if (unique.length !== tagIds.length) throw new BadRequestException('Duplicate tag ids');
    if (unique.length === 0) return;
    const found = await this.db.select({ id: tags.id }).from(tags).where(inArray(tags.id, unique));
    if (found.length !== unique.length) throw new BadRequestException('Unknown tag id');
  }
}
