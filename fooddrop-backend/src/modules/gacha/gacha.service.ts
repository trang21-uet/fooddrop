import { HttpStatus, Inject, Injectable, UnprocessableEntityException } from '@nestjs/common';
import { asc, desc, eq, inArray } from 'drizzle-orm';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { gachaSpins, recipeTags, recipes, tagDimensions, tags } from '../../database/schema/index.js';
import { ObjectStorageService } from '../media/object-storage.service.js';
import {
  byRarityDesc,
  countByRarity,
  FEATURED_CASE_IDS,
  inCase,
  TAG_CASE_GROUPS,
  tagCaseId,
  type CaseCandidate,
  type CaseGroup,
} from './gacha-cases.js';
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

  /** Featured cases plus one case per tag the user's recipes carry, with count, rarity mix and rarest dishes. */
  async cases(userId: string): Promise<GachaCases> {
    const [candidates, tagCases] = await Promise.all([this.loadCandidates(userId), this.loadTagCases()]);
    const definitions = [...FEATURED_CASE_IDS.map((id) => ({ id, group: 'featured' as const, label: null })), ...tagCases];
    const groups = definitions
      .map((definition) => ({ ...definition, recipes: candidates.filter((recipe) => inCase(definition.id, recipe)) }))
      // A tag no recipe carries would only be an empty case; featured cases always show.
      .filter((group) => group.group === 'featured' || group.recipes.length > 0);
    const previews = groups.map((group) => [...group.recipes].sort(byRarityDesc).slice(0, CASE_PREVIEW_SIZE));
    const toCard = await this.cardMapper(previews.flat());
    return {
      items: groups.map((group, index) => ({
        id: group.id,
        group: group.group,
        label: group.label,
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

  /** All of the user's recipes with what the case rules read (rarity, time, tags). */
  private async loadCandidates(userId: string): Promise<CandidateRow[]> {
    const [rows, tagRows] = await Promise.all([
      this.db.select(cardColumns).from(recipes).where(eq(recipes.ownerId, userId)),
      this.db
        .select({ recipeId: recipeTags.recipeId, dimension: tagDimensions.slug, slug: tags.slug })
        .from(recipeTags)
        .innerJoin(recipes, eq(recipes.id, recipeTags.recipeId))
        .innerJoin(tags, eq(tags.id, recipeTags.tagId))
        .innerJoin(tagDimensions, eq(tagDimensions.id, tags.dimensionId))
        .where(eq(recipes.ownerId, userId)),
    ]);
    const tagCaseIds = new Map<string, string[]>();
    for (const { recipeId, dimension, slug } of tagRows) {
      tagCaseIds.set(recipeId, [...(tagCaseIds.get(recipeId) ?? []), tagCaseId(dimension, slug)]);
    }
    return rows.map((row) => ({ ...row, tagCaseIds: tagCaseIds.get(row.id) ?? [] }));
  }

  /** One case per catalog tag in the tabbed dimensions, in tab order then catalog order. */
  private async loadTagCases(): Promise<Array<{ id: string; group: CaseGroup; label: string }>> {
    const rows = await this.db
      .select({ dimension: tagDimensions.slug, slug: tags.slug, label: tags.label })
      .from(tags)
      .innerJoin(tagDimensions, eq(tagDimensions.id, tags.dimensionId))
      .where(inArray(tagDimensions.slug, [...TAG_CASE_GROUPS]))
      .orderBy(asc(tags.id));
    return TAG_CASE_GROUPS.flatMap((group) =>
      rows
        .filter((row) => row.dimension === group)
        .map((row) => ({ id: tagCaseId(row.dimension, row.slug), group, label: row.label })),
    );
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
