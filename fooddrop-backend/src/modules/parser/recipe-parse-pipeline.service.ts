import { createHash } from 'node:crypto';
import { Inject, Injectable, Logger } from '@nestjs/common';
import type { Redis } from 'ioredis';
import { z } from 'zod';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { ingredients, tags } from '../../database/schema/index.js';
import { REDIS_CLIENT } from '../../redis/redis.module.js';
import { MAX_IMAGE_BYTES } from '../media/media.schemas.js';
import { ObjectStorageService, userUploadPrefix } from '../media/object-storage.service.js';
import { ClaudeRecipeExtractor } from './claude-recipe-extractor.js';
import { buildDraft } from './draft-builder.js';
import { sniffImageType } from './image-sniffer.js';
import { extractJsonLdRecipe } from './json-ld-recipe-extractor.js';
import { ParseJobError } from './parse-job-error.js';
import { rawRecipeSchema, type ParsedRecipeDraft, type RawRecipe } from './parser.schemas.js';
import { cleanHtmlToText } from './readability-cleaner.js';
import { assertFetchableUrl, fetchPublicPage } from './url-fetcher.js';

const URL_CACHE_TTL_SECONDS = 7 * 24 * 3600;
// Bump when extraction logic changes so stale cached output is not served for a week.
const URL_CACHE_VERSION = 2;

type DraftSource = ParsedRecipeDraft['source'];

// Cache the extractor output, not the draft: ingredient matching is redone against the current catalog.
const cachedExtractSchema = z.object({
  raw: rawRecipeSchema,
  source: z.enum(['json-ld', 'llm-text']),
  finalUrl: z.string(),
});

export interface ParseJobInput {
  userId: string;
  sourceType: 'url' | 'image';
  source: string;
}

@Injectable()
export class RecipeParsePipeline {
  private readonly logger = new Logger(RecipeParsePipeline.name);

  constructor(
    @Inject(DRIZZLE) private readonly db: Database,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly extractor: ClaudeRecipeExtractor,
    private readonly storage: ObjectStorageService,
  ) {}

  async run(job: ParseJobInput): Promise<ParsedRecipeDraft> {
    const [catalog, tagCatalog] = await Promise.all([
      this.db
        .select({
          id: ingredients.id,
          name: ingredients.name,
          aliases: ingredients.aliases,
          defaultUnit: ingredients.defaultUnit,
          densityGPerMl: ingredients.densityGPerMl,
        })
        .from(ingredients),
      this.db.select({ id: tags.id, slug: tags.slug, label: tags.label }).from(tags),
    ]);
    const slugs = tagCatalog.map((tag) => tag.slug);

    let raw: RawRecipe;
    let source: DraftSource;
    let sourceUrl: string | null = null;
    if (job.sourceType === 'url') {
      ({ raw, source, finalUrl: sourceUrl } = await this.extractFromUrl(job.source, slugs));
    } else {
      raw = await this.extractFromImage(job.userId, job.source, slugs);
      source = 'llm-vision';
    }
    return buildDraft(raw, { source, sourceUrl, catalog, tags: tagCatalog });
  }

  private async extractFromUrl(url: string, tagSlugs: string[]) {
    const key = `parser:url:v${URL_CACHE_VERSION}:${createHash('sha256').update(assertFetchableUrl(url).toString()).digest('hex')}`;
    const cached = await this.readCache(key);
    if (cached) return cached;

    const page = await fetchPublicPage(url);
    const jsonLd = extractJsonLdRecipe(page.html);
    const extract = jsonLd
      ? { raw: jsonLd, source: 'json-ld' as const, finalUrl: page.finalUrl }
      : {
          raw: await this.extractor.extractFromText(cleanHtmlToText(page.html), page.finalUrl, tagSlugs),
          source: 'llm-text' as const,
          finalUrl: page.finalUrl,
        };
    await this.writeCache(key, extract);
    return extract;
  }

  private async extractFromImage(userId: string, key: string, tagSlugs: string[]): Promise<RawRecipe> {
    // Jobs may only read what the same user uploaded.
    if (!key.startsWith(userUploadPrefix(userId)) || key.includes('..')) throw new ParseJobError('image_unreadable', 'foreign key');
    const object = await this.storage.readObject(key, MAX_IMAGE_BYTES);
    const mediaType = object ? sniffImageType(object.bytes) : null;
    if (!object || !mediaType) throw new ParseJobError('image_unreadable', 'missing, oversized or unsupported image');
    return this.extractor.extractFromImage(object.bytes, mediaType, tagSlugs);
  }

  // Redis is an optimization here: a cache outage must never fail a parse.
  private async readCache(key: string): Promise<z.output<typeof cachedExtractSchema> | null> {
    try {
      const value = await this.redis.get(key);
      const parsed = value ? cachedExtractSchema.safeParse(JSON.parse(value)) : null;
      return parsed?.success ? parsed.data : null;
    } catch (error) {
      this.logger.warn(`Parser cache read failed: ${String(error)}`);
      return null;
    }
  }

  private async writeCache(key: string, value: z.output<typeof cachedExtractSchema>): Promise<void> {
    try {
      await this.redis.set(key, JSON.stringify(value), 'EX', URL_CACHE_TTL_SECONDS);
    } catch (error) {
      this.logger.warn(`Parser cache write failed: ${String(error)}`);
    }
  }
}
