import type { ObjectStorageService } from '../media/object-storage.service.js';
import { importStepImages } from './step-image-importer.js';
import { fetchPublicImage } from './url-fetcher.js';

vi.mock('./url-fetcher.js', async (importOriginal) => ({
  ...(await importOriginal<typeof import('./url-fetcher.js')>()),
  fetchPublicImage: vi.fn(),
}));

const jpeg = Buffer.from([0xff, 0xd8, 0xff, 0xe0, 0, 0]);

function storage(isConfigured = true) {
  let n = 0;
  return {
    isConfigured,
    storeRecipeImage: vi.fn<ObjectStorageService['storeRecipeImage']>(() => Promise.resolve(`recipes/u1/${++n}.jpg`)),
    viewUrl: vi.fn<ObjectStorageService['viewUrl']>((key) => Promise.resolve(`https://cdn.example/${key}`)),
  };
}

beforeEach(() => vi.mocked(fetchPublicImage).mockReset());

describe('importStepImages', () => {
  it('copies each step’s photos into the owner’s storage, keeping step order and dropping failures', async () => {
    // Workers start in queue order: a.jpg, broken.jpg, x.svg, c.jpg.
    vi.mocked(fetchPublicImage)
      .mockResolvedValueOnce(jpeg)
      .mockRejectedValueOnce(new Error('HTTP 404'))
      .mockResolvedValueOnce(Buffer.from('<svg/>'))
      .mockResolvedValueOnce(jpeg);
    const store = storage();

    const images = await importStepImages(
      store,
      'u1',
      [
        { text: 'A', imageUrls: ['/a.jpg', 'https://cdn.example/broken.jpg'] },
        { text: 'B' },
        { text: 'C', imageUrls: ['https://cdn.example/x.svg', 'https://cdn.example/c.jpg'] },
      ],
      'https://site.example/recipe',
    );

    expect(fetchPublicImage).toHaveBeenCalledWith('https://site.example/a.jpg', expect.anything());
    expect(store.storeRecipeImage).toHaveBeenCalledWith('u1', jpeg, 'image/jpeg');
    expect(images.map((step) => step.length)).toEqual([1, 0, 1]);
    expect(images[0]![0]).toEqual({ key: expect.stringMatching(/^recipes\/u1\//), url: expect.stringContaining('recipes/u1/') });
  });

  it('fetches nothing when storage is not configured', async () => {
    const images = await importStepImages(storage(false), 'u1', [{ text: 'A', imageUrls: ['https://cdn.example/a.jpg'] }], null);
    expect(images).toEqual([[]]);
    expect(fetchPublicImage).not.toHaveBeenCalled();
  });
});
