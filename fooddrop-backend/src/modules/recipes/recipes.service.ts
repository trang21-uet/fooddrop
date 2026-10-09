import { BadRequestException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { and, eq, inArray, sql } from 'drizzle-orm';
import { DRIZZLE, type Database, type Transaction } from '../../database/database.module.js';
import { ingredients, recipeIngredients, recipeTags, recipes, tags } from '../../database/schema/index.js';
import { ObjectStorageService, recipeImagePrefix } from '../media/object-storage.service.js';
import { InvalidQuantityError, parseAmount } from '../units/normalize-quantity.js';
import { UnitsService } from '../units/units.service.js';
import { RecipesReaderService } from './recipes-reader.service.js';
import type { RecipeDetail, RecipeInput } from './recipes.schemas.js';

type IngredientRow = typeof recipeIngredients.$inferInsert;

/** Every photo key mentioned by a recipe's steps. */
export const stepImageKeys = (steps: ReadonlyArray<{ images?: string[] }>): string[] => [
  ...new Set(steps.flatMap((step) => step.images ?? [])),
];

@Injectable()
export class RecipesService {
  constructor(
    @Inject(DRIZZLE) private readonly db: Database,
    private readonly reader: RecipesReaderService,
    private readonly units: UnitsService,
    private readonly storage: ObjectStorageService,
  ) {}

  async create(ownerId: string, input: RecipeInput): Promise<RecipeDetail> {
    const ingredientRows = await this.buildIngredientRows(input);
    await this.assertTagsExist(input.tagIds);
    const columns = this.recipeColumns(ownerId, input);

    const id = await this.db.transaction(async (tx) => {
      const [created] = await tx
        .insert(recipes)
        .values({ ...columns, ownerId })
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
    const columns = this.recipeColumns(ownerId, input);

    const dropped = await this.db.transaction(async (tx) => {
      const [before] = await tx
        .select({ steps: recipes.steps })
        .from(recipes)
        .where(and(eq(recipes.id, id), eq(recipes.ownerId, ownerId)))
        // Concurrent updates must see each other's photo list, or one could delete a photo the other keeps.
        .for('update');
      if (!before) throw new NotFoundException('Recipe not found');
      const updated = await tx
        .update(recipes)
        // DB clock, like created_at, so the two never disagree when app and DB clocks drift.
        .set({ ...columns, updatedAt: sql`now()` })
        .where(and(eq(recipes.id, id), eq(recipes.ownerId, ownerId)))
        .returning({ id: recipes.id });
      if (updated.length === 0) throw new NotFoundException('Recipe not found');

      await tx.delete(recipeIngredients).where(eq(recipeIngredients.recipeId, id));
      await tx.delete(recipeTags).where(eq(recipeTags.recipeId, id));
      await this.writeChildren(tx, id, ingredientRows, input.tagIds);
      const kept = new Set(columns.steps.flatMap((step) => step.images ?? []));
      return stepImageKeys(before.steps).filter((key) => !kept.has(key));
    });
    await this.deleteUnreferencedPhotos(ownerId, id, dropped);
    return this.reader.getDetail(ownerId, id);
  }

  async remove(ownerId: string, id: string): Promise<void> {
    const deleted = await this.db
      .delete(recipes)
      .where(and(eq(recipes.id, id), eq(recipes.ownerId, ownerId)))
      .returning({ steps: recipes.steps });
    if (deleted.length === 0) throw new NotFoundException('Recipe not found');
    await this.deleteUnreferencedPhotos(ownerId, id, stepImageKeys(deleted[0]!.steps));
  }

  /** Removes stored photos that this recipe no longer shows, unless another recipe of the owner still uses the key. */
  private async deleteUnreferencedPhotos(ownerId: string, recipeId: string, keys: string[]): Promise<void> {
    if (keys.length === 0) return;
    const stillUsed = await this.db.execute<{ key: string }>(sql`
      SELECT DISTINCT image.key
      FROM recipes r,
           jsonb_array_elements(r.steps) AS step,
           jsonb_array_elements_text(COALESCE(step -> 'images', '[]'::jsonb)) AS image(key)
      WHERE r.owner_id = ${ownerId} AND r.id <> ${recipeId} AND image.key IN (${sql.join(keys, sql`, `)})`);
    const shared = new Set(stillUsed.rows.map((row) => row.key));
    await this.storage.deleteObjects(keys.filter((key) => !shared.has(key)));
  }

  private recipeColumns(ownerId: string, input: RecipeInput) {
    // A photo key is a capability: only keys under the owner's prefix may be attached, so one user
    // cannot pull another user's uploads into their own recipe.
    const prefix = recipeImagePrefix(ownerId);
    return {
      title: input.title,
      description: input.description ?? null,
      imageUrl: input.imageUrl ?? null,
      sourceUrl: input.sourceUrl ?? null,
      baseServings: input.baseServings,
      totalMinutes: input.totalMinutes,
      difficulty: input.difficulty,
      // Order is positional so clients cannot send gaps or duplicates.
      steps: input.steps.map(({ name, note, images, ...step }, index) => {
        if (images.some((key) => !key.startsWith(prefix) || key.includes('..'))) {
          throw new BadRequestException(`Step ${index + 1} has an image that was not uploaded by you`);
        }
        return {
          ...step,
          ...(name ? { name } : {}),
          ...(note ? { note } : {}),
          ...(images.length > 0 ? { images } : {}),
          order: index + 1,
        };
      }),
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

  /** Checks references and parses each quantity; the unit is stored as the cook chose it. */
  private async buildIngredientRows(input: RecipeInput): Promise<Omit<IngredientRow, 'recipeId'>[]> {
    const ids = input.ingredients.map((item) => item.ingredientId);
    if (new Set(ids).size !== ids.length) {
      throw new BadRequestException('Each ingredient can appear only once per recipe');
    }
    if (ids.length === 0) return [];

    const known = await this.db.select({ id: ingredients.id }).from(ingredients).where(inArray(ingredients.id, ids));
    const knownIds = new Set(known.map((row) => row.id));
    const unitCodes = [...new Set(input.ingredients.flatMap((item) => (item.unit ? [item.unit] : [])))];
    const knownUnits = await this.units.findByCodes(unitCodes);

    return input.ingredients.map((item, sortOrder) => {
      if (!knownIds.has(item.ingredientId)) throw new BadRequestException(`Unknown ingredient ${item.ingredientId}`);
      if (item.unit && !knownUnits.has(item.unit)) throw new BadRequestException(`Unknown unit "${item.unit}"`);
      return {
        ingredientId: item.ingredientId,
        quantity: this.parseQuantity(item),
        unit: item.unit ?? null,
        note: item.note || null,
        sortOrder,
      };
    });
  }

  private parseQuantity(item: RecipeInput['ingredients'][number]): number | null {
    if (item.quantity == null) return null;
    try {
      return parseAmount(item.quantity);
    } catch (error) {
      if (error instanceof InvalidQuantityError) {
        throw new BadRequestException(`Invalid quantity "${String(item.quantity)}" for ingredient ${item.ingredientId}`);
      }
      throw error;
    }
  }

  private async assertTagsExist(tagIds: number[]): Promise<void> {
    const unique = [...new Set(tagIds)];
    if (unique.length !== tagIds.length) throw new BadRequestException('Duplicate tag ids');
    if (unique.length === 0) return;
    const found = await this.db.select({ id: tags.id }).from(tags).where(inArray(tags.id, unique));
    if (found.length !== unique.length) throw new BadRequestException('Unknown tag id');
  }
}
