import { Logger } from '@nestjs/common';
import { MAX_IMAGE_BYTES } from '../media/media.schemas.js';
import type { ObjectStorageService } from '../media/object-storage.service.js';
import { sniffImageType } from './image-sniffer.js';
import type { RawRecipe } from './parser.schemas.js';
import { DEFAULT_FETCH_LIMITS, fetchPublicImage, type FetchLimits } from './url-fetcher.js';

export interface StepImage {
  key: string;
  url: string | null;
}

const MAX_IMPORTED_PHOTOS = 40;
const CONCURRENCY = 4;
// Clients give up on a job after 90 s; photos are a bonus, so they get a fixed share of that.
const IMPORT_BUDGET_MS = 30_000;
const IMAGE_LIMITS: FetchLimits = { ...DEFAULT_FETCH_LIMITS, maxBytes: MAX_IMAGE_BYTES, timeoutMs: 8_000 };

const logger = new Logger('StepImageImporter');

type Storage = Pick<ObjectStorageService, 'isConfigured' | 'storeRecipeImage' | 'viewUrl'>;

async function importOne(storage: Storage, userId: string, url: string, limits: FetchLimits): Promise<StepImage | null> {
  try {
    const bytes = await fetchPublicImage(url, limits);
    const type = sniffImageType(bytes);
    if (!type) return null;
    const key = await storage.storeRecipeImage(userId, bytes, type);
    return { key, url: await storage.viewUrl(key) };
  } catch (error) {
    logger.warn(`Step photo skipped: ${error instanceof Error ? error.message : String(error)}`);
    return null;
  }
}

/**
 * Copies the source's step photos into the user's recipe storage, so the draft carries keys the
 * recipe form saves like its own uploads. Returns one list per step; a photo that fails is
 * dropped, never the import. Nothing is fetched when storage is not configured.
 */
export async function importStepImages(
  storage: Storage,
  userId: string,
  steps: RawRecipe['steps'],
  baseUrl: string | null,
  limits: FetchLimits = IMAGE_LIMITS,
): Promise<StepImage[][]> {
  const perStep: StepImage[][] = steps.map(() => []);
  if (!storage.isConfigured) return perStep;

  const queue = steps
    .flatMap((step, index) =>
      (step.imageUrls ?? []).flatMap((src) => {
        try {
          return [{ index, url: new URL(src, baseUrl ?? undefined).toString() }];
        } catch {
          return [];
        }
      }),
    )
    .slice(0, MAX_IMPORTED_PHOTOS);
  const imported: Array<StepImage | null> = queue.map(() => null);
  const deadline = Date.now() + IMPORT_BUDGET_MS;
  let next = 0;
  const worker = async (): Promise<void> => {
    while (next < queue.length && Date.now() < deadline) {
      const slot = next++;
      imported[slot] = await importOne(storage, userId, queue[slot]!.url, limits);
    }
  };
  await Promise.all(Array.from({ length: Math.min(CONCURRENCY, queue.length) }, worker));

  queue.forEach((item, slot) => {
    const image = imported[slot];
    if (image) perStep[item.index]!.push(image);
  });
  return perStep;
}
