// Crawls Điện máy XANH "Vào bếp" and saves new recipes into one account through the same parser the import
// screen uses. JSON-LD only, so it never calls the paid LLM; step photos are copied into object storage.
//
//   pnpm import:dienmayxanh -- --email you@example.com [--limit 50] [--delay 1500]
//
// Needs Postgres, Redis and S3 from `docker compose up`. Re-running skips URLs the account already has.
import { parseArgs } from 'node:util';
import { ConflictException, Logger, Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { eq, isNotNull, and } from 'drizzle-orm';
import { validateEnv } from '../config/env.schema.js';
import { DRIZZLE, DatabaseModule, type Database } from '../database/database.module.js';
import { recipes, users } from '../database/schema/index.js';
import { IngredientsModule } from '../modules/ingredients/ingredients.module.js';
import { IngredientsService } from '../modules/ingredients/ingredients.service.js';
import { MediaModule } from '../modules/media/media.module.js';
import { ClaudeRecipeExtractor } from '../modules/parser/claude-recipe-extractor.js';
import { ParseJobError } from '../modules/parser/parse-job-error.js';
import { RecipeParsePipeline } from '../modules/parser/recipe-parse-pipeline.service.js';
import { fetchPublicPage } from '../modules/parser/url-fetcher.js';
import { RecipesModule } from '../modules/recipes/recipes.module.js';
import { RecipesService } from '../modules/recipes/recipes.service.js';
import { UnitsService } from '../modules/units/units.service.js';
import { RedisModule } from '../redis/redis.module.js';
import { DIENMAYXANH_HOME, extractArticleUrls, extractCategoryUrls } from './dienmayxanh-recipe-links.js';
import { draftToRecipeInput, type DraftIngredient } from './draft-to-recipe-input.js';
import { findIngredientByName, ingredientDefaultUnit } from './ingredient-lookup.js';

// Some pnpm versions forward the `--` separator; parseArgs would read everything after it as positionals.
const argv = process.argv.slice(2);
const { values } = parseArgs({
  args: argv[0] === '--' ? argv.slice(1) : argv,
  options: {
    email: { type: 'string' },
    limit: { type: 'string', default: '50' },
    delay: { type: 'string', default: '1500' },
  },
});
const limit = Number(values.limit);
const delayMs = Number(values.delay);
if (!values.email || !(limit > 0) || !(delayMs >= 0)) {
  throw new Error('Usage: --email <account email> [--limit 50] [--delay 1500]');
}

// Not the parser worker module: that one starts a BullMQ consumer.
@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, validate: validateEnv }),
    DatabaseModule,
    RedisModule,
    MediaModule,
    IngredientsModule,
    RecipesModule,
  ],
  providers: [ClaudeRecipeExtractor, RecipeParsePipeline],
})
class ImportModule {}

const logger = new Logger('DienMayXanhImport');
const pause = (): Promise<void> => new Promise((resolve) => setTimeout(resolve, delayMs));

/** Home page plus every category page, deduplicated, in the order the site lists them. */
async function discoverArticleUrls(): Promise<string[]> {
  const home = await fetchPublicPage(DIENMAYXANH_HOME);
  const found = new Set(extractArticleUrls(home.html));
  for (const category of extractCategoryUrls(home.html)) {
    await pause();
    try {
      extractArticleUrls((await fetchPublicPage(category)).html).forEach((url) => found.add(url));
    } catch (error) {
      logger.warn(`Skipped category ${category}: ${String(error)}`);
    }
  }
  return [...found];
}

const app = await NestFactory.createApplicationContext(ImportModule, { logger: ['error', 'warn', 'log'] });
try {
  const db = app.get<Database>(DRIZZLE);
  const pipeline = app.get(RecipeParsePipeline);
  const recipesService = app.get(RecipesService, { strict: false });
  const ingredientsService = app.get(IngredientsService, { strict: false });
  const unitKinds = new Map((await app.get(UnitsService, { strict: false }).list()).map((unit) => [unit.code, unit.kind]));

  const [owner] = await db.select({ id: users.id }).from(users).where(eq(users.email, values.email)).limit(1);
  if (!owner) throw new Error(`No account with email ${values.email}`);
  const owned = await db
    .select({ sourceUrl: recipes.sourceUrl })
    .from(recipes)
    .where(and(eq(recipes.ownerId, owner.id), isNotNull(recipes.sourceUrl)));
  const known = new Set(owned.map((row) => row.sourceUrl));

  // Catalog ids for ingredient names the catalog lacks, created once per run.
  const created = new Map<string, string>();
  const resolveIngredient = async (item: DraftIngredient): Promise<string> => {
    const name = item.name.trim().slice(0, 100);
    const cached = created.get(name.toLowerCase());
    if (cached) return cached;
    let id: string;
    try {
      const defaultUnit = ingredientDefaultUnit(item, unitKinds);
      id = (await ingredientsService.create({ name, aliases: [], aisle: 'other', defaultUnit, densityGPerMl: null })).id;
      logger.log(`  + ingredient "${name}"`);
    } catch (error) {
      // Same name in another spelling (case, diacritics, alias) already exists.
      if (!(error instanceof ConflictException)) throw error;
      id = findIngredientByName(await ingredientsService.search(name, 20), name).id;
    }
    created.set(name.toLowerCase(), id);
    return id;
  };

  const candidates = (await discoverArticleUrls()).filter((url) => !known.has(url));
  logger.log(`${candidates.length} new article links; importing up to ${limit}`);
  let saved = 0;
  let skipped = 0;
  for (const url of candidates) {
    if (saved >= limit) break;
    await pause();
    try {
      const draft = await pipeline.run({ userId: owner.id, sourceType: 'url', source: url, structuredOnly: true });
      if (draft.sourceUrl && known.has(draft.sourceUrl)) continue;
      if (draft.ingredients.length === 0 || draft.steps.length === 0) throw new ParseJobError('not_a_recipe', 'empty');
      const recipe = await recipesService.create(owner.id, await draftToRecipeInput(draft, resolveIngredient));
      known.add(draft.sourceUrl ?? url);
      saved++;
      logger.log(`OK   ${recipe.title} (${recipe.ingredients.length} ingredients, ${recipe.steps.length} steps)`);
    } catch (error) {
      skipped++;
      const reason = error instanceof ParseJobError ? error.code : error instanceof Error ? error.message : String(error);
      logger.warn(`SKIP ${url}: ${reason.slice(0, 200)}`);
    }
  }
  logger.log(`Saved ${saved} recipes, skipped ${skipped}`);
} finally {
  await app.close();
}
