import { HttpStatus, Inject, Injectable, UnprocessableEntityException } from '@nestjs/common';
import { and, desc, eq } from 'drizzle-orm';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { gachaSpins, recipeTags, recipes, tagDimensions, tags } from '../../database/schema/index.js';
import { ObjectStorageService } from '../media/object-storage.service.js';
import { byRarityDesc, CASE_IDS, countByRarity, inCase, type CaseCandidate } from './gacha-cases.js';
import type { CreateSpin, GachaCases, GachaRecipeCard, GachaSpin, SpinHistory } from './gacha.schemas.js';
import { RARITY_WEIGHTS } from './rarity-weights.js';
import { buildReel } from './reel-builder.js';
import { SpinRateLimit } from './spin-rate-limit.js';
import { createWeightedPicker, cryptoRandomInt } from './weighted-draw.js';

export const CASE_PREVIEW_SIZE = 10;

const cardColumns = {
  id: recipes.id,
  title: recipes.title,
  imageUrl: recipes.imageUrl,
  imageKey: recipes.imageKey,
  rarity: recipes.rarity,
  totalMinutes: recipes.totalMinutes,
  difficulty: recipes.difficulty,
  baseServings: recipes.baseServings,
};

type CardRow = GachaRecipeCard & { imageKey: string | null };
type CandidateRow = CardRow & CaseCandidate;

@Injectable()
export class GachaService {
  constructor(
    @Inject(DRIZZLE) private readonly db: Database,
    private readonly storage: ObjectStorageService,
    private readonly rateLimit: SpinRateLimit,
  ) {}

  /** Every case with what it holds for this user: count, rarity mix and its rarest dishes. */
  async cases(userId: string): Promise<GachaCases> {
    const candidates = await this.loadCandidates(userId);
    const groups = CASE_IDS.map((id) => ({ id, recipes: candidates.filter((recipe) => inCase(id, recipe)) }));
    const previews = groups.map((group) => [...group.recipes].sort(byRarityDesc).slice(0, CASE_PREVIEW_SIZE));
    const toCard = await this.cardMapper(previews.flat());
    return {
      items: groups.map((group, index) => ({
        id: group.id,
        recipeCount: group.recipes.length,
        rarityCounts: countByRarity(group.recipes),
        preview: previews[index]!.map(toCard),
      })),
    };
  }

  /** Draws the result server-side from the case's recipes, builds the reel around it and records the spin. */
  async spin(userId: string, input: CreateSpin): Promise<GachaSpin> {
    await this.rateLimit.consume(userId);

    const pool = (await this.loadCandidates(userId)).filter((recipe) => inCase(input.caseId, recipe));
    if (pool.length === 0) {
      throw new UnprocessableEntityException({
        statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
        code: 'gacha_empty_pool',
        message: 'This case has no recipes',
      });
    }

    const pick = createWeightedPicker(pool, (recipe) => RARITY_WEIGHTS[recipe.rarity], cryptoRandomInt);
    const winner = pick();
    const reel = buildReel(winner, pick, cryptoRandomInt);

    const [spin] = await this.db
      .insert(gachaSpins)
      .values({
        userId,
        caseType: input.caseType,
        resultRecipeId: winner.id,
        context: { caseId: input.caseId, poolSize: pool.length },
      })
      .returning({ id: gachaSpins.id, createdAt: gachaSpins.createdAt });

    const toCard = await this.cardMapper(reel.cards);
    return {
      spinId: spin!.id,
      caseType: input.caseType,
      createdAt: spin!.createdAt.toISOString(),
      result: toCard(winner),
      reel: reel.cards.map(toCard),
      winningIndex: reel.winningIndex,
      offsetJitter: reel.offsetJitter,
      poolSize: pool.length,
    };
  }

  /** The user's latest spins, newest first. */
  async history(userId: string, limit: number): Promise<SpinHistory> {
    const rows = await this.db
      .select({ id: gachaSpins.id, createdAt: gachaSpins.createdAt, recipe: cardColumns })
      .from(gachaSpins)
      .leftJoin(recipes, eq(recipes.id, gachaSpins.resultRecipeId))
      .where(eq(gachaSpins.userId, userId))
      .orderBy(desc(gachaSpins.createdAt))
      .limit(limit);

    // A left join yields an all-null object when the recipe is gone.
    const results = rows.map((row) => (row.recipe?.id ? (row.recipe as CardRow) : null));
    const toCard = await this.cardMapper(results.filter((card) => card !== null));
    return {
      items: rows.map((row, index) => ({
        id: row.id,
        // Lazy spins arrive in Phase 08; until then every stored spin is a cook spin.
        caseType: 'cook' as const,
        createdAt: row.createdAt.toISOString(),
        result: results[index] ? toCard(results[index]) : null,
      })),
    };
  }

  /** All of the user's recipes with what the case rules read (rarity, time, meal_type tags). */
  private async loadCandidates(userId: string): Promise<CandidateRow[]> {
    const [rows, mealTags] = await Promise.all([
      this.db.select(cardColumns).from(recipes).where(eq(recipes.ownerId, userId)),
      this.db
        .select({ recipeId: recipeTags.recipeId, slug: tags.slug })
        .from(recipeTags)
        .innerJoin(recipes, eq(recipes.id, recipeTags.recipeId))
        .innerJoin(tags, eq(tags.id, recipeTags.tagId))
        .innerJoin(tagDimensions, eq(tagDimensions.id, tags.dimensionId))
        .where(and(eq(recipes.ownerId, userId), eq(tagDimensions.slug, 'meal_type'))),
    ]);
    const mealTypes = new Map<string, string[]>();
    for (const { recipeId, slug } of mealTags) mealTypes.set(recipeId, [...(mealTypes.get(recipeId) ?? []), slug]);
    return rows.map((row) => ({ ...row, mealTypes: mealTypes.get(row.id) ?? [] }));
  }

  /** Resolves each uploaded cover once, then maps rows to cards (uploaded photo wins over an external URL). */
  private async cardMapper(rows: CardRow[]): Promise<(row: CardRow) => GachaRecipeCard> {
    const keys = [...new Set(rows.flatMap((row) => (row.imageKey ? [row.imageKey] : [])))];
    const urls = new Map(await Promise.all(keys.map(async (key) => [key, await this.storage.viewUrl(key)] as const)));
    return ({ id, title, imageUrl, imageKey, rarity, totalMinutes, difficulty, baseServings }) => ({
      id,
      title,
      imageUrl: imageKey ? (urls.get(imageKey) ?? null) : imageUrl,
      rarity,
      totalMinutes,
      difficulty,
      baseServings,
    });
  }
}
