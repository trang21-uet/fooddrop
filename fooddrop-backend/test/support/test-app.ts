import { randomUUID } from 'node:crypto';
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { eq, inArray } from 'drizzle-orm';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { AppModule } from '../../src/app.module.js';
import { DRIZZLE, type Database } from '../../src/database/database.module.js';
import { ingredients, users } from '../../src/database/schema/index.js';

export interface TestUser {
  id: string;
  email: string;
  /** Value for the Authorization header. */
  authorization: string;
}

export async function createTestApp(): Promise<INestApplication<App>> {
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
  // Same as main.ts: Better Auth needs the raw body, AuthModule re-adds parsers for other routes.
  const app = moduleRef.createNestApplication<INestApplication<App>>({ bodyParser: false });
  await app.init();
  return app;
}

/** Signs up a throwaway user through the real auth endpoint and returns its bearer token. */
export async function signUpTestUser(app: INestApplication<App>): Promise<TestUser> {
  const email = `e2e-${randomUUID()}@fooddrop.test`;
  const response = await request(app.getHttpServer())
    .post('/api/auth/sign-up/email')
    .send({ email, password: 'correct-horse-battery', name: 'E2E User' })
    .expect(200);
  const token = response.headers['set-auth-token'];
  if (typeof token !== 'string') throw new Error('Bearer plugin did not return set-auth-token');
  return { id: response.body.user.id, email, authorization: `Bearer ${token}` };
}

/** Recipes, sessions and accounts cascade from the user row. */
export async function deleteTestUsers(app: INestApplication<App>, testUsers: TestUser[]): Promise<void> {
  const db = app.get<Database>(DRIZZLE);
  for (const user of testUsers) await db.delete(users).where(eq(users.id, user.id));
}

/** The ingredient catalog is shared and has no owner, so tests must remove what they add. */
export async function deleteTestIngredients(app: INestApplication<App>, names: string[]): Promise<void> {
  if (names.length === 0) return;
  await app.get<Database>(DRIZZLE).delete(ingredients).where(inArray(ingredients.name, names));
}
