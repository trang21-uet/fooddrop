import { readFileSync } from 'node:fs';
import type { Redis } from 'ioredis';
import type { Database } from '../../database/database.module.js';
import type { ObjectStorageService } from '../media/object-storage.service.js';
import type { ClaudeRecipeExtractor } from './claude-recipe-extractor.js';
import { ParseJobError } from './parse-job-error.js';
import type { RawRecipe } from './parser.schemas.js';
import { RecipeParsePipeline } from './recipe-parse-pipeline.service.js';
import { fetchPublicImage, fetchPublicPage } from './url-fetcher.js';

vi.mock('./url-fetcher.js', async (importOriginal) => ({
  ...(await importOriginal<typeof import('./url-fetcher.js')>()),
  fetchPublicPage: vi.fn(),
  fetchPublicImage: vi.fn(),
}));

const fixture = (name: string): string => readFileSync(new URL(`./fixtures/${name}`, import.meta.url), 'utf8');
const URL_ = 'https://blog.example/pancakes';

const catalog = [{ id: 'flour-id', name: 'Bột mì', aliases: ['all-purpose flour'], defaultUnit: 'g' as const, densityGPerMl: 0.53 }];
const tagRows = [{ id: 1, slug: 'breakfast', label: 'Bữa sáng' }];

function setup(cache: Record<string, string> = {}) {
  // select().from(table) resolves the ingredient catalog or the tag list depending on call order.
  const results = [catalog, tagRows];
  let call = 0;
  const db = { select: () => ({ from: () => Promise.resolve(results[call++ % 2]) }) } as unknown as Database;
  const redis = {
    get: vi.fn((key: string) => Promise.resolve(cache[key] ?? null)),
    set: vi.fn(() => Promise.resolve('OK')),
  };
  const extractor = {
    extractFromText: vi.fn<ClaudeRecipeExtractor['extractFromText']>(),
    extractFromImage: vi.fn<ClaudeRecipeExtractor['extractFromImage']>(),
  };
  const storage = {
    isConfigured: true,
    readObject: vi.fn<ObjectStorageService['readObject']>(),
    storeRecipeImage: vi.fn<ObjectStorageService['storeRecipeImage']>(() => Promise.resolve('recipes/u1/p.jpg')),
    viewUrl: vi.fn<ObjectStorageService['viewUrl']>((key) => Promise.resolve(`https://cdn.example/${key}`)),
  };
  const pipeline = new RecipeParsePipeline(
    db,
    redis as unknown as Redis,
    extractor as unknown as ClaudeRecipeExtractor,
    storage as unknown as ObjectStorageService,
  );
  return { pipeline, redis, extractor, storage };
}

const llmRecipe: RawRecipe = {
  title: 'Bánh kếp',
  ingredients: [{ name: 'bột mì', quantity: '200', unit: 'g' }],
  steps: [{ text: 'Trộn.' }],
  suggestedTags: ['breakfast'],
};

beforeEach(() => {
  vi.mocked(fetchPublicPage).mockReset();
  vi.mocked(fetchPublicImage).mockReset();
});

describe('RecipeParsePipeline', () => {
  it('uses JSON-LD without calling the LLM, then caches the extractor output', async () => {
    vi.mocked(fetchPublicPage).mockResolvedValue({ finalUrl: URL_, html: fixture('yoast-graph.html') });
    const { pipeline, extractor, redis } = setup();

    const draft = await pipeline.run({ userId: 'u1', sourceType: 'url', source: URL_ });

    expect(extractor.extractFromText).not.toHaveBeenCalled();
    expect(draft).toMatchObject({
      source: 'json-ld',
      title: 'Classic & Fluffy Pancakes',
      sourceUrl: URL_,
      suggestedTagIds: [1],
      imageUrl: 'https://blog.example/img/pancakes.jpg',
    });
    // "all-purpose flour" is a catalog alias, so it matches; cups are outside the catalog, so 1.5 cups becomes ml.
    expect(draft.ingredients[0]).toMatchObject({ ingredientId: 'flour-id', quantity: 354.88, unit: 'ml', isNew: false });
    expect(redis.set).toHaveBeenCalledWith(expect.stringMatching(/^parser:url:v\d+:[0-9a-f]{64}$/), expect.any(String), 'EX', 604800);
  });

  it('takes ingredients and steps of the first version from Điện máy XANH markup, with step photos', async () => {
    const pageUrl = 'https://www.dienmayxanh.com/vao-bep/cach-lam-heo-quay-00061';
    vi.mocked(fetchPublicPage).mockResolvedValue({ finalUrl: pageUrl, html: fixture('dienmayxanh-two-versions.html') });
    vi.mocked(fetchPublicImage).mockResolvedValue(Buffer.from([0xff, 0xd8, 0xff, 0xe0]));
    const { pipeline } = setup();

    const draft = await pipeline.run({ userId: 'u1', sourceType: 'url', source: pageUrl });

    expect(draft).toMatchObject({ source: 'json-ld', title: 'Heo quay', totalMinutes: 80, difficulty: 3 });
    expect(draft.ingredients.map((item) => item.name)).toEqual(['Thịt ba chỉ heo', 'Giấm', 'Muối']);
    expect(draft.steps).toEqual([
      {
        name: 'Luộc thịt',
        text: 'Thịt mua về rửa sạch.\nLuộc 7 phút.',
        note: 'Để ý không luộc quá lâu.',
        images: [
          { key: 'recipes/u1/p.jpg', url: 'https://cdn.example/recipes/u1/p.jpg' },
          { key: 'recipes/u1/p.jpg', url: 'https://cdn.example/recipes/u1/p.jpg' },
        ],
      },
      { name: 'Thành phẩm', text: 'Cắt khúc, dọn ra đĩa.', note: null, images: [] },
    ]);
  });

  it('falls back to the LLM for pages without usable JSON-LD', async () => {
    vi.mocked(fetchPublicPage).mockResolvedValue({ finalUrl: URL_, html: fixture('no-structured-data.html') });
    const { pipeline, extractor } = setup();
    extractor.extractFromText.mockResolvedValue(llmRecipe);

    const draft = await pipeline.run({ userId: 'u1', sourceType: 'url', source: URL_ });

    expect(extractor.extractFromText).toHaveBeenCalledWith(expect.stringContaining('Bún chả'), URL_, ['breakfast']);
    expect(draft).toMatchObject({ source: 'llm-text', title: 'Bánh kếp', suggestedTagIds: [1] });
    expect(draft.ingredients[0]).toMatchObject({ ingredientId: 'flour-id', quantity: 200, unit: 'g' });
  });

  it('fails with not_a_recipe instead of calling the LLM when structuredOnly is set', async () => {
    vi.mocked(fetchPublicPage).mockResolvedValue({ finalUrl: URL_, html: fixture('no-structured-data.html') });
    const { pipeline, extractor, redis } = setup();

    await expect(pipeline.run({ userId: 'u1', sourceType: 'url', source: URL_, structuredOnly: true })).rejects.toMatchObject({
      code: 'not_a_recipe',
    });
    expect(extractor.extractFromText).not.toHaveBeenCalled();
    expect(redis.set).not.toHaveBeenCalled();
  });

  it('serves cached extractor output without fetching, rematching against the current catalog', async () => {
    const { pipeline, redis, extractor } = setup();
    redis.get.mockResolvedValue(JSON.stringify({ raw: llmRecipe, source: 'llm-text', finalUrl: URL_ }));

    const draft = await pipeline.run({ userId: 'u1', sourceType: 'url', source: URL_ });

    expect(fetchPublicPage).not.toHaveBeenCalled();
    expect(extractor.extractFromText).not.toHaveBeenCalled();
    expect(draft.ingredients[0]!.ingredientId).toBe('flour-id');
  });

  it('survives a Redis outage', async () => {
    vi.mocked(fetchPublicPage).mockResolvedValue({ finalUrl: URL_, html: fixture('yoast-graph.html') });
    const { pipeline, redis } = setup();
    redis.get.mockRejectedValue(new Error('down'));
    redis.set.mockRejectedValue(new Error('down'));
    await expect(pipeline.run({ userId: 'u1', sourceType: 'url', source: URL_ })).resolves.toMatchObject({ source: 'json-ld' });
  });

  it('rejects blocked URLs before touching the cache or network', async () => {
    const { pipeline, redis } = setup();
    await expect(pipeline.run({ userId: 'u1', sourceType: 'url', source: 'http://127.0.0.1/' })).rejects.toMatchObject({ code: 'url_blocked' });
    expect(redis.get).not.toHaveBeenCalled();
    expect(fetchPublicPage).not.toHaveBeenCalled();
  });

  describe('images', () => {
    const jpeg = Buffer.from([0xff, 0xd8, 0xff, 0xe0, 0, 0]);

    it('reads the owner’s object, sniffs its type and sends it to the vision model', async () => {
      const { pipeline, extractor, storage } = setup();
      storage.readObject.mockResolvedValue({ bytes: jpeg, contentType: 'application/octet-stream' });
      extractor.extractFromImage.mockResolvedValue(llmRecipe);

      const draft = await pipeline.run({ userId: 'u1', sourceType: 'image', source: 'parser/u1/a.jpg' });

      expect(extractor.extractFromImage).toHaveBeenCalledWith(jpeg, 'image/jpeg', ['breakfast']);
      expect(draft).toMatchObject({ source: 'llm-vision', sourceUrl: null });
    });

    it.each([
      ['another user’s key', 'parser/u2/a.jpg', jpeg],
      ['a path escape', 'parser/u1/../u2/a.jpg', jpeg],
      ['a missing object', 'parser/u1/missing.jpg', null],
      ['non-image bytes', 'parser/u1/a.jpg', Buffer.from('<svg/>')],
    ])('refuses %s', async (_label, key, bytes) => {
      const { pipeline, extractor, storage } = setup();
      storage.readObject.mockResolvedValue(bytes ? { bytes, contentType: 'image/jpeg' } : null);
      await expect(pipeline.run({ userId: 'u1', sourceType: 'image', source: key })).rejects.toBeInstanceOf(ParseJobError);
      await expect(pipeline.run({ userId: 'u1', sourceType: 'image', source: key })).rejects.toMatchObject({ code: 'image_unreadable' });
      expect(extractor.extractFromImage).not.toHaveBeenCalled();
    });
  });
});
