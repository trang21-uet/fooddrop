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
    it('stores tags, ordered steps, ingredients as written and derived rarity', async () => {
      const { ingredientIds } = fx;
      const created = await fx
        .api(fx.alice)
        .post('/recipes')
        .send(
          fx.recipeBody({
            ingredients: [
              { ingredientId: ingredientIds['Bột mì'], quantity: '1 1/2', unit: 'tbsp' },
              { ingredientId: ingredientIds['Sữa tươi'], quantity: 2, unit: 'tsp', note: 'ấm' },
              { ingredientId: ingredientIds['Trứng gà'], quantity: 2 },
              { ingredientId: ingredientIds['Cá hồi'] },
            ],
          }),
        )
        .expect(201);

      expect(created.body).toMatchObject({
        title: 'Cá hồi áp chảo',
        rarity: 'blue', // 25 min, difficulty 2
        baseServings: 2,
        steps: [
          { order: 1, text: 'Ướp cá', images: [] },
          { order: 2, text: 'Áp chảo 4 phút mỗi mặt', timerSeconds: 240, timerLabel: 'Áp chảo', images: [] },
        ],
      });
      expect(created.body.tags.map((t: { slug: string }) => t.slug).sort()).toEqual(['air-fryer', 'dinner', 'japanese']);
      // Quantity and unit come back exactly as written; `base` is what the grocery list sums.
      // Milk is summed in ml (2 tsp = 10 ml), a bare number is pieces, no quantity contributes 0.
      expect(created.body.ingredients).toEqual([
        {
          ingredient: expect.objectContaining({ name: 'Bột mì' }),
          quantity: 1.5,
          unit: { code: 'tbsp', nameVi: 'thìa canh', nameEn: 'tablespoon', kind: 'volume' },
          note: null,
          base: expect.objectContaining({ unit: 'g' }),
        },
        {
          ingredient: expect.objectContaining({ name: 'Sữa tươi' }),
          quantity: 2,
          unit: { code: 'tsp', nameVi: 'thìa cafe', nameEn: 'teaspoon', kind: 'volume' },
          note: 'ấm',
          base: { quantity: 10, unit: 'ml' },
        },
        {
          ingredient: expect.objectContaining({ name: 'Trứng gà' }),
          quantity: 2,
          unit: null,
          note: null,
          base: { quantity: 2, unit: 'piece' },
        },
        {
          ingredient: expect.objectContaining({ name: 'Cá hồi' }),
          quantity: null,
          unit: null,
          note: null,
          base: expect.objectContaining({ quantity: 0 }),
        },
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

    it('rejects a unit that is not in the catalog and a unit without a quantity', async () => {
      const id = fx.ingredientIds['Cá hồi'];
      const unknown = await fx
        .api(fx.alice)
        .post('/recipes')
        .send(fx.recipeBody({ ingredients: [{ ingredientId: id, quantity: 1, unit: 'cup' }] }))
        .expect(400);
      expect(JSON.stringify(unknown.body)).toContain('Unknown unit');
      await fx
        .api(fx.alice)
        .post('/recipes')
        .send(fx.recipeBody({ ingredients: [{ ingredientId: id, unit: 'g' }] }))
        .expect(400);
    });

    it('stores step names and photos, and only accepts photos the owner uploaded', async () => {
      const upload = async (user: typeof fx.alice) =>
        (
          await fx
            .api(user)
            .post('/media/uploads')
            .send({ purpose: 'recipe-step', contentType: 'image/jpeg', sizeBytes: 1024 })
            .expect(201)
        ).body.key as string;
      const aliceKey = await upload(fx.alice);
      const bobKey = await upload(fx.bob);
      expect(aliceKey).toMatch(new RegExp(`^recipes/${fx.alice.id}/[0-9a-f-]{36}\\.jpg$`));

      const steps = [{ name: 'Sơ chế', text: 'Rửa cá', images: [aliceKey] }, { text: 'Áp chảo' }];
      const created = await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ steps })).expect(201);
      expect(created.body.steps).toMatchObject([
        { order: 1, name: 'Sơ chế', text: 'Rửa cá', images: [{ key: aliceKey, url: expect.any(String) }] },
        { order: 2, text: 'Áp chảo', images: [] },
      ]);
      expect(created.body.steps[1]).not.toHaveProperty('name');

      await fx
        .api(fx.alice)
        .post('/recipes')
        .send(fx.recipeBody({ steps: [{ text: 'Rửa cá', images: [bobKey] }] }))
        .expect(400);
      await fx
        .api(fx.alice)
        .post('/recipes')
        .send(fx.recipeBody({ steps: [{ text: 'Rửa cá', images: [`recipes/${fx.alice.id}/../${fx.bob.id}/x.jpg`] }] }))
        .expect(400);
    });

    describe('stored step photos', () => {
      const bytes = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3, 4]);

      /** Uploads a real object for alice and returns its key. */
      async function uploadPhoto(): Promise<string> {
        const target = (
          await fx
            .api(fx.alice)
            .post('/media/uploads')
            .send({ purpose: 'recipe-step', contentType: 'image/jpeg', sizeBytes: bytes.length })
            .expect(201)
        ).body as { key: string; uploadUrl: string; headers: Record<string, string> };
        const put = await fetch(target.uploadUrl, { method: 'PUT', headers: target.headers, body: bytes });
        expect(put.status).toBe(200);
        return target.key;
      }

      const urlOf = (recipe: { steps: Array<{ images: Array<{ url: string }> }> }, step = 0) => recipe.steps[step]!.images[0]!.url;
      const loads = async (url: string) => (await fetch(url)).ok;

      it('serves an uploaded photo, and removes it from storage when the step stops using it', async () => {
        const key = await uploadPhoto();
        const created = (await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ steps: [{ text: 'Rửa', images: [key] }] })).expect(201)).body;
        const url = urlOf(created);
        expect(await loads(url)).toBe(true);

        await fx.api(fx.alice).put(`/recipes/${created.id}`).send(fx.recipeBody({ steps: [{ text: 'Rửa' }] })).expect(200);
        expect(await loads(url)).toBe(false);
      });

      it('keeps photos that are still referenced when other photos are replaced', async () => {
        const [keep, drop] = [await uploadPhoto(), await uploadPhoto()];
        const created = (
          await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ steps: [{ text: 'Rửa', images: [keep, drop] }] })).expect(201)
        ).body;
        const [keepUrl, dropUrl] = created.steps[0].images.map((image: { url: string }) => image.url);

        await fx.api(fx.alice).put(`/recipes/${created.id}`).send(fx.recipeBody({ steps: [{ text: 'Rửa', images: [keep] }] })).expect(200);
        expect(await loads(keepUrl)).toBe(true);
        expect(await loads(dropUrl)).toBe(false);
      });

      it('removes the photos of a deleted recipe, but not ones another recipe of the owner still uses', async () => {
        const [own, shared] = [await uploadPhoto(), await uploadPhoto()];
        const first = (
          await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ steps: [{ text: 'A', images: [own, shared] }] })).expect(201)
        ).body;
        const second = (
          await fx.api(fx.alice).post('/recipes').send(fx.recipeBody({ steps: [{ text: 'B', images: [shared] }] })).expect(201)
        ).body;
        const [ownUrl, sharedUrl] = first.steps[0].images.map((image: { url: string }) => image.url);

        await fx.api(fx.alice).delete(`/recipes/${first.id}`).expect(204);

        expect(await loads(ownUrl)).toBe(false);
        expect(await loads(sharedUrl)).toBe(true);
        expect(urlOf(second)).toBeDefined();
      });
    });

    it('lists the unit catalog with both languages', async () => {
      const units = (await fx.api(fx.alice).get('/units').expect(200)).body as Array<{ code: string; nameVi: string; nameEn: string }>;
      expect(units).toEqual(
        expect.arrayContaining([
          expect.objectContaining({ code: 'tsp', nameVi: 'thìa cafe', nameEn: 'teaspoon' }),
          expect.objectContaining({ code: 'fruit', nameVi: 'quả' }),
          expect.objectContaining({ code: 'sprig', nameVi: 'nhánh' }),
        ]),
      );
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
