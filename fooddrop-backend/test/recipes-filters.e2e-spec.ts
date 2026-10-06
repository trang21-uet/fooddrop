import { setupRecipeFixtures, type RecipeFixtures } from './support/recipe-fixtures.js';

// Requires `docker compose up -d`, `pnpm db:migrate` and `pnpm db:seed`.
describe('recipe list filters and pagination (e2e)', () => {
  let fx: RecipeFixtures;
  let grilled: string;
  let slowSoup: string;

  const titles = async (query: Record<string, string | number>): Promise<string[]> =>
    ((await fx.api(fx.alice).get('/recipes').query(query).expect(200)).body.items as Array<{ title: string }>).map(
      (recipe) => recipe.title,
    );

  beforeAll(async () => {
    fx = await setupRecipeFixtures();
    const { tagIds } = fx;
    const create = async (overrides: Record<string, unknown>) =>
      (await fx.api(fx.alice).post('/recipes').send(fx.recipeBody(overrides)).expect(201)).body.id as string;

    await create({}); // Cá hồi áp chảo: japanese + air-fryer + dinner, 25 min
    grilled = await create({ title: 'Gà nướng chanh', totalMinutes: 60, difficulty: 3, tagIds: [tagIds['vietnamese'], tagIds['oven']] });
    slowSoup = await create({
      title: 'Phở bò',
      totalMinutes: 300,
      difficulty: 4,
      tagIds: [tagIds['vietnamese'], tagIds['pressure-cooker'], tagIds['soup']],
    });
  });

  afterAll(async () => {
    await fx.close();
  });

  it('AND across dimensions: japanese + air-fryer returns the matching recipe only', async () => {
    expect(await titles({ tags: `${fx.tagIds['japanese']},${fx.tagIds['air-fryer']}` })).toEqual(['Cá hồi áp chảo']);
  });

  it('AND across dimensions: a non-matching second dimension excludes the recipe', async () => {
    expect(await titles({ tags: `${fx.tagIds['japanese']},${fx.tagIds['oven']}` })).toEqual([]);
  });

  it('OR within a dimension: vietnamese or japanese', async () => {
    const result = await titles({ tags: `${fx.tagIds['vietnamese']},${fx.tagIds['japanese']}` });
    expect([...result].sort()).toEqual(['Cá hồi áp chảo', 'Gà nướng chanh', 'Phở bò']);
  });

  it('filters by rarity, max minutes and accent-insensitive text', async () => {
    expect(await titles({ rarity: 'red' })).toEqual(['Phở bò']);
    expect([...(await titles({ rarity: 'purple,red' }))].sort()).toEqual(['Gà nướng chanh', 'Phở bò']);
    expect(await titles({ maxMinutes: 30 })).toEqual(['Cá hồi áp chảo']);
    expect(await titles({ q: 'pho bo' })).toEqual(['Phở bò']);
    expect(await titles({ q: 'GA NUONG' })).toEqual(['Gà nướng chanh']);
  });

  it('treats LIKE wildcards in the search text literally', async () => {
    expect(await titles({ q: '%' })).toEqual([]);
  });

  it('rejects an unknown tag id and a bad rarity', async () => {
    await fx.api(fx.alice).get('/recipes').query({ tags: '999999' }).expect(400);
    await fx.api(fx.alice).get('/recipes').query({ rarity: 'gold' }).expect(400);
  });

  it('paginates with a stable cursor and no duplicates', async () => {
    const seen: string[] = [];
    let cursor: string | undefined;
    let pages = 0;
    do {
      const res = await fx.api(fx.alice).get('/recipes').query({ limit: 2, ...(cursor ? { cursor } : {}) }).expect(200);
      seen.push(...res.body.items.map((r: { id: string }) => r.id));
      cursor = res.body.nextCursor ?? undefined;
      pages += 1;
    } while (cursor && pages < 10);
    expect(pages).toBe(2); // 3 recipes, 2 per page
    expect(new Set(seen).size).toBe(3);
    expect(seen).toEqual(expect.arrayContaining([grilled, slowSoup]));
  });

  it.each([
    ['garbage', 'garbage'],
    ['uuid-shaped but invalid id', Buffer.from(`2026-10-06T10:00:00.000Z|${'-'.repeat(36)}`).toString('base64url')],
  ])('rejects a malformed cursor (%s) with 400', async (_name, cursor) => {
    await fx.api(fx.alice).get('/recipes').query({ cursor }).expect(400);
  });
});
