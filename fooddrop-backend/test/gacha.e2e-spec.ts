import { setupRecipeFixtures, type RecipeFixtures } from './support/recipe-fixtures.js';

interface Card {
  id: string;
  title: string;
  rarity: string;
  baseServings: number;
}

interface CaseView {
  id: string;
  recipeCount: number;
  rarityCounts: Record<string, number>;
  preview: Card[];
}

// Requires `docker compose up -d`, `pnpm db:migrate` and `pnpm db:seed`. Runs with the default 30 spins/minute.
describe('gacha cases and spins (e2e)', () => {
  let fx: RecipeFixtures;
  let quick: string;
  let slow: string;
  let salmon: string;

  const spin = (body: Record<string, unknown> = {}, user = fx.alice) =>
    fx.api(user).post('/gacha/spins').send({ caseType: 'cook', caseId: 'all', ...body });

  beforeAll(async () => {
    fx = await setupRecipeFixtures();
    const create = async (overrides: Record<string, unknown>) =>
      (await fx.api(fx.alice).post('/recipes').send(fx.recipeBody(overrides)).expect(201)).body.id as string;
    quick = await create({ title: 'Trứng ốp la', totalMinutes: 10, difficulty: 1, tagIds: [fx.tagIds['vietnamese']] });
    slow = await create({ title: 'Phở bò', totalMinutes: 300, difficulty: 4, tagIds: [fx.tagIds['vietnamese']] });
    salmon = await create({}); // Cá hồi áp chảo: dinner, 25 min, blue
  });

  afterAll(async () => {
    await fx.close();
  });

  it('lists every case with its count, rarity mix and rarest dishes first', async () => {
    const { items } = (await fx.api(fx.alice).get('/gacha/cases').expect(200)).body as { items: CaseView[] };
    const byId = Object.fromEntries(items.map((item) => [item.id, item]));
    expect(items.map((item) => item.id)).toEqual(['all', 'breakfast', 'lunch', 'dinner', 'quick', 'epic']);
    expect(byId['all']).toMatchObject({ recipeCount: 3, rarityCounts: { white: 1, blue: 1, purple: 0, pink: 0, red: 1 } });
    expect(byId['all']!.preview.map((card) => card.title)).toEqual(['Phở bò', 'Cá hồi áp chảo', 'Trứng ốp la']);
    expect(byId['breakfast']).toMatchObject({ recipeCount: 0, preview: [] });
    expect(byId['dinner']!.preview.map((card) => card.id)).toEqual([salmon]);
    expect(byId['quick']!.recipeCount).toBe(2);
    expect(byId['epic']!.preview.map((card) => card.id)).toEqual([slow]);

    const bobs = (await fx.api(fx.bob).get('/gacha/cases').expect(200)).body as { items: CaseView[] };
    expect(bobs.items.every((item) => item.recipeCount === 0)).toBe(true);
  });

  it('returns a 70-card reel that lands on the server-drawn result', async () => {
    const { body } = await spin().expect(201);
    expect(body.reel).toHaveLength(70);
    expect(body.winningIndex).toBe(60);
    expect(body.reel[body.winningIndex]).toEqual(body.result);
    expect(Math.abs(body.offsetJitter)).toBeLessThanOrEqual(0.4);
    expect(body.poolSize).toBe(3);
    for (const card of body.reel as Card[]) expect([quick, slow, salmon]).toContain(card.id);
    expect(body.result.baseServings).toBe(2);
  });

  it('draws only from the chosen case', async () => {
    const quickSpin = (await spin({ caseId: 'quick' }).expect(201)).body;
    expect(new Set((quickSpin.reel as Card[]).map((card) => card.id))).toEqual(new Set([quick, salmon]));
    expect(quickSpin.poolSize).toBe(2);

    expect((await spin({ caseId: 'epic' }).expect(201)).body.result.id).toBe(slow);
    expect((await spin({ caseId: 'dinner' }).expect(201)).body.result.id).toBe(salmon);
  });

  it('rejects an unknown case and a client-chosen result', async () => {
    await spin({ caseId: 'secret' }).expect(400);
    await fx.api(fx.alice).post('/gacha/spins').send({ caseType: 'cook' }).expect(400);
    await spin({ caseType: 'lazy' }).expect(400);
    // Extra keys are stripped: the client cannot pick the result.
    const { body } = await spin({ caseId: 'epic', resultRecipeId: quick, winningIndex: 0 }).expect(201);
    expect(body.result.id).toBe(slow);
    expect(body.winningIndex).toBe(60);
  });

  it('answers 422 for an empty case', async () => {
    expect((await spin({ caseId: 'breakfast' }).expect(422)).body).toMatchObject({ code: 'gacha_empty_pool' });
    expect((await spin({}, fx.bob).expect(422)).body).toMatchObject({ code: 'gacha_empty_pool' });
  });

  it('lists the spin history newest first, scoped to the user', async () => {
    const latest = (await spin({ caseId: 'epic' }).expect(201)).body;
    const history = (await fx.api(fx.alice).get('/gacha/spins').query({ limit: 2 }).expect(200)).body;
    expect(history.items).toHaveLength(2);
    expect(history.items[0]).toMatchObject({ id: latest.spinId, caseType: 'cook', result: { id: slow } });

    expect((await fx.api(fx.bob).get('/gacha/spins').expect(200)).body.items).toEqual([]);
  });

  it('keeps a spin whose recipe was deleted, with a null result', async () => {
    const dinner = (await spin({ caseId: 'dinner' }).expect(201)).body;
    await fx.api(fx.alice).delete(`/recipes/${salmon}`).expect(204);
    const history = (await fx.api(fx.alice).get('/gacha/spins').query({ limit: 1 }).expect(200)).body;
    expect(history.items[0]).toMatchObject({ id: dinner.spinId, result: null });
  });

  it('limits spins to 30 per minute per user', async () => {
    await fx.api(fx.bob).post('/recipes').send(fx.recipeBody()).expect(201);
    // Bob's empty-case spin above already counted as one.
    for (let i = 0; i < 29; i++) await spin({}, fx.bob).expect(201);
    const blocked = await spin({}, fx.bob).expect(429);
    expect(blocked.body).toMatchObject({ code: 'gacha_rate_limit' });
    expect(blocked.body.retryAfterSeconds).toBeGreaterThan(0);
    expect(blocked.body.retryAfterSeconds).toBeLessThanOrEqual(60);
    expect(blocked.headers['retry-after']).toBe(String(blocked.body.retryAfterSeconds));

    // Alice has her own window.
    await spin().expect(201);
  });
});
