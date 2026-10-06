import request from 'supertest';
import { setupRecipeFixtures, type RecipeFixtures } from './support/recipe-fixtures.js';

// Requires `docker compose up -d`, `pnpm db:migrate` and `pnpm db:seed`.
describe('recipes CRUD and ownership (e2e)', () => {
  let fx: RecipeFixtures;

  beforeAll(async () => {
    fx = await setupRecipeFixtures();
  });

  afterAll(async () => {
    await fx.close();
  });

  it('rejects anonymous requests', async () => {
    await request(fx.app.getHttpServer()).get('/recipes').expect(401);
    await request(fx.app.getHttpServer()).post('/recipes').send(fx.recipeBody()).expect(401);
  });

  it('keeps /health public', async () => {
    const res = await request(fx.app.getHttpServer()).get('/health');
    expect([200, 503]).toContain(res.status);
  });

  describe('create and read', () => {
    it('stores tags, ordered steps, normalized ingredients and derived rarity', async () => {
      const { ingredientIds } = fx;
      const created = await fx
        .api(fx.alice)
        .post('/recipes')
        .send(
          fx.recipeBody({
            ingredients: [
              { ingredientId: ingredientIds['Bột mì'], quantity: '1 1/2', unit: 'cup' },
              { ingredientId: ingredientIds['Sữa tươi'], quantity: 2, unit: 'tbsp', note: 'ấm' },
              { ingredientId: ingredientIds['Trứng gà'], quantity: 2 },
              { ingredientId: ingredientIds['Cá hồi'], quantity: 1, unit: 'handful' },
            ],
          }),
        )
        .expect(201);

      expect(created.body).toMatchObject({
        title: 'Cá hồi áp chảo',
        rarity: 'blue', // 25 min, difficulty 2
        baseServings: 2,
        steps: [
          { order: 1, text: 'Ướp cá' },
          { order: 2, text: 'Áp chảo 4 phút mỗi mặt', timerSeconds: 240, timerLabel: 'Áp chảo' },
        ],
      });
      expect(created.body.tags.map((t: { slug: string }) => t.slug).sort()).toEqual(['air-fryer', 'dinner', 'japanese']);
      // flour: 1.5 cup * 236.588 ml * 0.53 g/ml; milk: 2 tbsp = 29.57 ml; egg: bare number = pieces;
      // salmon: unknown unit contributes 0 g and keeps the wording in the note
      expect(created.body.ingredients).toEqual([
        { ingredient: expect.objectContaining({ name: 'Bột mì' }), quantity: 188.09, unit: 'g', note: null },
        { ingredient: expect.objectContaining({ name: 'Sữa tươi' }), quantity: 29.57, unit: 'ml', note: 'ấm' },
        { ingredient: expect.objectContaining({ name: 'Trứng gà' }), quantity: 2, unit: 'piece', note: null },
        { ingredient: expect.objectContaining({ name: 'Cá hồi' }), quantity: 0, unit: 'g', note: '1 handful' },
      ]);

      await fx.api(fx.alice).get(`/recipes/${created.body.id}`).expect(200);
    });

    it('rejects quantities that cannot be parsed with 400 (valid ingredient id)', async () => {
      const res = await fx
        .api(fx.alice)
        .post('/recipes')
        .send(fx.recipeBody({ ingredients: [{ ingredientId: fx.ingredientIds['Cá hồi'], quantity: 'lots', unit: 'g' }] }))
        .expect(400);
      expect(JSON.stringify(res.body)).toContain('Invalid quantity');
    });

    it.each([
      ['no steps', { steps: [] }],
      ['difficulty out of range', { difficulty: 9 }],
      ['non-http image url', { imageUrl: 'javascript:alert(1)' }],
      ['unknown tag', { tagIds: [999_999] }],
      ['duplicate tags', { tagIds: [1, 1] }],
    ])('rejects %s with 400', async (_name, overrides) => {
      await fx.api(fx.alice).post('/recipes').send(fx.recipeBody(overrides)).expect(400);
    });

    it('rejects an unknown ingredient and a repeated ingredient with 400', async () => {
      const unknown = { ingredientId: '00000000-0000-4000-8000-000000000000', quantity: 1, unit: 'g' };
      await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ ingredients: [unknown] })).expect(400);
      const item = { ingredientId: fx.ingredientIds['Cá hồi'], quantity: 1, unit: 'g' };
      await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ ingredients: [item, item] })).expect(400);
    });

    it('returns 400 for a malformed id', async () => {
      await fx.api(fx.alice).get('/recipes/not-a-uuid').expect(400);
    });
  });

  describe('ownership', () => {
    let recipeId: string;

    beforeAll(async () => {
      recipeId = (await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ title: 'Công thức riêng tư' })).expect(201)).body.id;
    });

    it("hides another user's recipe from reads, updates and deletes", async () => {
      await fx.api(fx.bob).get(`/recipes/${recipeId}`).expect(404);
      await fx.api(fx.bob).put(`/recipes/${recipeId}`).send(fx.recipeBody({ title: 'Hijacked' })).expect(404);
      await fx.api(fx.bob).delete(`/recipes/${recipeId}`).expect(404);
      expect((await fx.api(fx.bob).get('/recipes').expect(200)).body.items).toEqual([]);
      expect((await fx.api(fx.alice).get(`/recipes/${recipeId}`).expect(200)).body.title).toBe('Công thức riêng tư');
    });

    it('replaces ingredients, steps and tags on PUT and deletes with 204', async () => {
      const updated = await fx
        .api(fx.alice)
        .put(`/recipes/${recipeId}`)
        .send(fx.recipeBody({ title: 'Đã sửa', totalMinutes: 200, tagIds: [fx.tagIds['korean']], ingredients: [] }))
        .expect(200);
      expect(updated.body).toMatchObject({ title: 'Đã sửa', rarity: 'red', ingredients: [] });
      expect(updated.body.tags.map((t: { slug: string }) => t.slug)).toEqual(['korean']);
      expect(new Date(updated.body.updatedAt).getTime()).toBeGreaterThanOrEqual(new Date(updated.body.createdAt).getTime());

      await fx.api(fx.alice).delete(`/recipes/${recipeId}`).expect(204);
      await fx.api(fx.alice).get(`/recipes/${recipeId}`).expect(404);
    });
  });
});
