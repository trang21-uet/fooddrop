import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { createTestApp, deleteTestUsers, signUpTestUser, type TestUser } from './test-app.js';

const CATALOG_INGREDIENTS = ['Cá hồi', 'Bột mì', 'Sữa tươi', 'Trứng gà'] as const;

export interface RecipeFixtures {
  app: INestApplication<App>;
  alice: TestUser;
  bob: TestUser;
  tagIds: Record<string, number>;
  ingredientIds: Record<string, string>;
  /** Authenticated supertest helpers for one user. */
  api: (user: TestUser) => Record<'get' | 'post' | 'put' | 'delete', (url: string) => request.Test>;
  recipeBody: (overrides?: Record<string, unknown>) => Record<string, unknown>;
  close: () => Promise<void>;
}

/** Boots the app, signs up two users and resolves seeded tag/ingredient ids (needs `pnpm db:seed`). */
export async function setupRecipeFixtures(): Promise<RecipeFixtures> {
  const app = await createTestApp();
  const [alice, bob] = await Promise.all([signUpTestUser(app), signUpTestUser(app)]);

  const api: RecipeFixtures['api'] = (user) => {
    const call = (method: 'get' | 'post' | 'put' | 'delete') => (url: string) =>
      request(app.getHttpServer())[method](url).set('Authorization', user.authorization);
    return { get: call('get'), post: call('post'), put: call('put'), delete: call('delete') };
  };

  const tagIds: Record<string, number> = {};
  const dimensions = (await api(alice).get('/tags').expect(200)).body as Array<{
    tags: Array<{ id: number; slug: string }>;
  }>;
  for (const { tags } of dimensions) for (const tag of tags) tagIds[tag.slug] = tag.id;

  const ingredientIds: Record<string, string> = {};
  for (const name of CATALOG_INGREDIENTS) {
    const found = (await api(alice).get('/ingredients').query({ q: name }).expect(200)).body as Array<{
      id: string;
      name: string;
    }>;
    ingredientIds[name] = found.find((item) => item.name === name)!.id;
  }

  const recipeBody: RecipeFixtures['recipeBody'] = (overrides = {}) => ({
    title: 'Cá hồi áp chảo',
    totalMinutes: 25,
    difficulty: 2,
    steps: [{ text: 'Ướp cá' }, { text: 'Áp chảo 4 phút mỗi mặt', timerSeconds: 240, timerLabel: 'Áp chảo' }],
    ingredients: [{ ingredientId: ingredientIds['Cá hồi'], quantity: 300, unit: 'g' }],
    tagIds: [tagIds['japanese'], tagIds['air-fryer'], tagIds['dinner']],
    ...overrides,
  });

  return {
    app,
    alice,
    bob,
    tagIds,
    ingredientIds,
    api,
    recipeBody,
    close: async () => {
      await deleteTestUsers(app, [alice, bob]);
      await app.close();
    },
  };
}
