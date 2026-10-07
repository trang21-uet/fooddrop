import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { AppModule } from '../src/app.module.js';
import { DRIZZLE, type Database } from '../src/database/database.module.js';
import { parseJobs } from '../src/database/schema/index.js';
import { ParserWorkerModule } from '../src/modules/parser/parser-worker.module.js';
import { deleteTestUsers, signUpTestUser, type TestUser } from './support/test-app.js';

// Requires `docker compose up -d` (Postgres, Redis, s3 + s3-init) and `pnpm db:migrate && pnpm db:seed`.
// ANTHROPIC_API_KEY is expected to be unset, so LLM paths end in `parser_unavailable` without any API call.
describe('parser and media (e2e)', () => {
  let app: INestApplication<App>;
  let alice: TestUser;
  let bob: TestUser;

  const as = (user: TestUser) => ({
    get: (url: string) => request(app.getHttpServer()).get(url).set('Authorization', user.authorization),
    post: (url: string) => request(app.getHttpServer()).post(url).set('Authorization', user.authorization),
  });

  // A few bytes with a valid JPEG signature: enough for upload and type sniffing, not a real photo.
  const fakeJpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), Buffer.alloc(1020, 1)]);

  async function uploadImage(user: TestUser, body: Buffer = fakeJpeg): Promise<string> {
    const target = (
      await as(user).post('/media/uploads').send({ contentType: 'image/jpeg', sizeBytes: body.length }).expect(201)
    ).body as { key: string; uploadUrl: string; headers: Record<string, string> };
    const put = await fetch(target.uploadUrl, { method: 'PUT', headers: target.headers, body: new Uint8Array(body) });
    expect(put.status).toBe(200);
    return target.key;
  }

  async function waitForJob(user: TestUser, id: string) {
    for (let attempt = 0; attempt < 50; attempt++) {
      const body = (await as(user).get(`/parser/jobs/${id}`).expect(200)).body as { status: string; errorCode: string | null };
      if (body.status === 'succeeded' || body.status === 'failed') return body;
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    throw new Error(`Job ${id} did not finish`);
  }

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

  describe('POST /media/uploads', () => {
    it('rejects unsupported types and oversized files', async () => {
      await as(alice).post('/media/uploads').send({ contentType: 'image/gif', sizeBytes: 100 }).expect(400);
      await as(alice).post('/media/uploads').send({ contentType: 'image/png', sizeBytes: 5 * 1024 * 1024 + 1 }).expect(400);
      await as(alice).post('/media/uploads').send({ contentType: 'image/png', sizeBytes: 0 }).expect(400);
    });

    it('returns a user-scoped key and a presigned PUT that stores the exact bytes', async () => {
      const key = await uploadImage(alice);
      expect(key).toMatch(new RegExp(`^parser/${alice.id}/[0-9a-f-]{36}\\.jpg$`));
    });

    it('pins the declared size: a larger body than signed is refused', async () => {
      const target = (
        await as(alice).post('/media/uploads').send({ contentType: 'image/jpeg', sizeBytes: 1024 }).expect(201)
      ).body as { uploadUrl: string; headers: Record<string, string> };
      const put = await fetch(target.uploadUrl, { method: 'PUT', headers: target.headers, body: new Uint8Array(4096) });
      expect(put.ok).toBe(false);
    });

    it('requires authentication', async () => {
      await request(app.getHttpServer()).post('/media/uploads').send({ contentType: 'image/png', sizeBytes: 10 }).expect(401);
    });
  });

  describe('parser jobs', () => {
    it('validates the request body', async () => {
      await as(alice).post('/parser/jobs').send({}).expect(400);
      await as(alice).post('/parser/jobs').send({ url: 'https://a.example', imageKey: 'k' }).expect(400);
      await as(alice).post('/parser/jobs').send({ url: 'ftp://example.com/recipe' }).expect(400);
      await as(alice).post('/parser/jobs').send({ url: 'not a url' }).expect(400);
    });

    it('fails URL jobs that point at private addresses without fetching anything', async () => {
      const created = await as(alice).post('/parser/jobs').send({ url: 'http://localhost/recipe' }).expect(201);
      expect(created.body).toMatchObject({ status: 'queued', sourceType: 'url', result: null, errorCode: null });
      expect(await waitForJob(alice, created.body.id)).toMatchObject({ status: 'failed', errorCode: 'url_blocked' });
    });

    it('runs an uploaded image through the pipeline up to the model call', async () => {
      const key = await uploadImage(alice);
      const created = await as(alice).post('/parser/jobs').send({ imageKey: key }).expect(201);
      // No API key in the test environment: reaching parser_unavailable proves read + sniff succeeded.
      expect(await waitForJob(alice, created.body.id)).toMatchObject({ status: 'failed', errorCode: 'parser_unavailable' });
    });

    it('fails image jobs whose object is missing or not an image', async () => {
      const missing = await as(alice).post('/parser/jobs').send({ imageKey: `parser/${alice.id}/does-not-exist.jpg` }).expect(201);
      expect(await waitForJob(alice, missing.body.id)).toMatchObject({ status: 'failed', errorCode: 'image_unreadable' });

      const key = await uploadImage(alice, Buffer.from('<svg xmlns="http://www.w3.org/2000/svg"/>'));
      const notImage = await as(alice).post('/parser/jobs').send({ imageKey: key }).expect(201);
      expect(await waitForJob(alice, notImage.body.id)).toMatchObject({ status: 'failed', errorCode: 'image_unreadable' });
    });

    it('refuses image keys that belong to another user or escape the prefix', async () => {
      const bobsKey = await uploadImage(bob);
      await as(alice).post('/parser/jobs').send({ imageKey: bobsKey }).expect(400);
      await as(alice).post('/parser/jobs').send({ imageKey: `parser/${alice.id}/../${bob.id}/x.jpg` }).expect(400);
    });

    it("hides other users' jobs", async () => {
      const created = await as(bob).post('/parser/jobs').send({ url: 'http://localhost/x' }).expect(201);
      await as(alice).get(`/parser/jobs/${created.body.id}`).expect(404);
      await as(bob).get(`/parser/jobs/${created.body.id}`).expect(200);
      await as(alice).get('/parser/jobs/not-a-uuid').expect(400);
    });

    it('enforces the daily quota', async () => {
      const carol = await signUpTestUser(app);
      try {
        // Default quota is 30 per rolling 24h; seed that many finished jobs instead of queueing 30.
        await app
          .get<Database>(DRIZZLE)
          .insert(parseJobs)
          .values(
            Array.from({ length: 30 }, () => ({
              userId: carol.id,
              sourceType: 'url' as const,
              source: 'http://localhost/q',
              status: 'failed' as const,
            })),
          );
        await as(carol).post('/parser/jobs').send({ url: 'http://localhost/q' }).expect(429);
        // Quotas are per user.
        await as(alice).post('/parser/jobs').send({ url: 'http://localhost/q' }).expect(201);
      } finally {
        await deleteTestUsers(app, [carol]);
      }
    });
  });
});
