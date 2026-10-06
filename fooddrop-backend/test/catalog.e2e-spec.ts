import { deleteTestIngredients } from './support/test-app.js';
import { setupRecipeFixtures, type RecipeFixtures } from './support/recipe-fixtures.js';

// Requires `docker compose up -d`, `pnpm db:migrate` and `pnpm db:seed`.
describe('tags and ingredients catalog (e2e)', () => {
  let fx: RecipeFixtures;
  const createdIngredients: string[] = [];

  beforeAll(async () => {
    fx = await setupRecipeFixtures();
  });

  afterAll(async () => {
    await deleteTestIngredients(fx.app, createdIngredients);
    await fx.close();
  });

  it('lists the five seeded dimensions with their tags', async () => {
    const res = await fx.api(fx.alice).get('/tags').expect(200);
    expect(res.body.map((d: { slug: string }) => d.slug)).toEqual(['cuisine', 'equipment', 'meal_type', 'technique', 'diet']);
    expect(res.body.every((d: { tags: unknown[] }) => d.tags.length > 0)).toBe(true);
  });

  it('searches ingredients by name or alias, ignoring accents and case', async () => {
    const names = async (q: string) =>
      ((await fx.api(fx.alice).get('/ingredients').query({ q }).expect(200)).body as Array<{ name: string }>).map((i) => i.name);
    expect(await names('hanh la')).toContain('Hành lá');
    expect(await names('Scallion')).toContain('Hành lá');
    expect((await fx.api(fx.alice).get('/ingredients').query({ limit: 5 }).expect(200)).body).toHaveLength(5);
  });

  it('adds a user ingredient in the "other" aisle and rejects duplicates and alias clashes', async () => {
    const name = `Rau test ${Date.now()}`;
    createdIngredients.push(name);
    const created = await fx.api(fx.alice).post('/ingredients').send({ name }).expect(201);
    expect(created.body).toMatchObject({ name, aisle: 'other', defaultUnit: 'g', aliases: [] });
    await fx.api(fx.alice).post('/ingredients').send({ name: name.toUpperCase() }).expect(409);
    await fx.api(fx.alice).post('/ingredients').send({ name: 'hanh la' }).expect(409);
    await fx.api(fx.alice).post('/ingredients').send({ name: '' }).expect(400);
  });
});
