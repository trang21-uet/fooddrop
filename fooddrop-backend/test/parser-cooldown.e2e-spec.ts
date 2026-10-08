import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { AppModule } from '../src/app.module.js';
import { ParserWorkerModule } from '../src/modules/parser/parser-worker.module.js';
import { deleteTestUsers, signUpTestUser, type TestUser } from './support/test-app.js';

// Requires `docker compose up -d` and `pnpm db:migrate && pnpm db:seed`. Runs with the default 60 s cooldown;
// parser.e2e-spec.ts turns it off so its many imports per user are not throttled.
describe('parser import cooldown (e2e)', () => {
  let app: INestApplication<App>;
  let alice: TestUser;
  let bob: TestUser;

  const create = (user: TestUser, body: object) =>
    request(app.getHttpServer()).post('/parser/jobs').set('Authorization', user.authorization).send(body);

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule, ParserWorkerModule] }).compile();
    app = moduleRef.createNestApplication<INestApplication<App>>({ bodyParser: false });
    await app.init();
    [alice, bob] = await Promise.all([signUpTestUser(app), signUpTestUser(app)]);
  });

  afterAll(async () => {
    await deleteTestUsers(app, [alice, bob]);
    await app.close();
  });

  it('allows one import per minute per user', async () => {
    const created = await create(alice, { url: 'http://localhost/a' }).expect(201);
    expect(created.body.cooldownSeconds).toBe(60);

    const blocked = await create(alice, { url: 'http://localhost/b' }).expect(429);
    expect(blocked.body).toMatchObject({ code: 'parse_cooldown' });
    expect(blocked.body.retryAfterSeconds).toBeGreaterThan(0);
    expect(blocked.body.retryAfterSeconds).toBeLessThanOrEqual(60);
    expect(blocked.headers['retry-after']).toBe(String(blocked.body.retryAfterSeconds));

    await create(bob, { url: 'http://localhost/c' }).expect(201);
  });

  it('does not charge the minute for rejected requests', async () => {
    await create(bob, { url: 'not a url' }).expect(400);
    await create(bob, { imageKey: `parser/${alice.id}/x.jpg` }).expect(400);
    const blocked = await create(bob, { url: 'http://localhost/d' }).expect(429);
    // Still bob's first import's minute, not extended by the 400s above.
    expect(blocked.body.retryAfterSeconds).toBeLessThanOrEqual(60);
  });
});
