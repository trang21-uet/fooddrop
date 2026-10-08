import { randomUUID } from 'node:crypto';
import { DeleteObjectsCommand, GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable, Logger, ServiceUnavailableException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Env } from '../../config/env.schema.js';
import type { CreateUpload, UploadTarget } from './media.schemas.js';

const UPLOAD_URL_TTL_SECONDS = 300;
const EXTENSIONS: Record<CreateUpload['contentType'], string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
};

/** Keys are namespaced by owner so a job can only read images its own user uploaded. */
export const userUploadPrefix = (userId: string): string => `parser/${userId}/`;
/** Step photos of a user's recipes; a recipe may only reference keys under its owner's prefix. */
export const recipeImagePrefix = (userId: string): string => `recipes/${userId}/`;

const PREFIX_BY_PURPOSE: Record<CreateUpload['purpose'], (userId: string) => string> = {
  parser: userUploadPrefix,
  'recipe-step': recipeImagePrefix,
};
// SigV4's maximum. Mobile keeps these URLs offline, so the longer the better; the app also refreshes them on sync.
const VIEW_URL_TTL_SECONDS = 7 * 24 * 3600;
// S3 accepts at most 1000 keys per DeleteObjects call.
const DELETE_BATCH = 1000;

@Injectable()
export class ObjectStorageService {
  private readonly logger = new Logger(ObjectStorageService.name);
  private readonly client: S3Client | null;
  private readonly bucket: string;
  private readonly publicUrl: string | undefined;

  constructor(config: ConfigService<Env, true>) {
    const accessKeyId = config.get('S3_ACCESS_KEY_ID', { infer: true });
    const secretAccessKey = config.get('S3_SECRET_ACCESS_KEY', { infer: true });
    const endpoint = config.get('S3_ENDPOINT', { infer: true });
    this.bucket = config.get('S3_BUCKET', { infer: true });
    this.publicUrl = config.get('S3_PUBLIC_URL', { infer: true })?.replace(/\/+$/, '');
    this.client =
      accessKeyId && secretAccessKey
        ? new S3Client({
            region: config.get('S3_REGION', { infer: true }),
            endpoint,
            // MinIO and most self-hosted endpoints need path-style addressing.
            forcePathStyle: Boolean(endpoint),
            // The SDK's default CRC32 would be baked into the presigned URL as the checksum of an empty
            // body, so every real upload fails (R2 and others reject it too).
            requestChecksumCalculation: 'WHEN_REQUIRED',
            credentials: { accessKeyId, secretAccessKey },
          })
        : null;
  }

  get isConfigured(): boolean {
    return this.client !== null;
  }

  /** Presigned PUT whose signature pins content type and length, so the 5 MB cap holds server-side. */
  async createUploadTarget(userId: string, upload: CreateUpload): Promise<UploadTarget> {
    const key = `${PREFIX_BY_PURPOSE[upload.purpose](userId)}${randomUUID()}.${EXTENSIONS[upload.contentType]}`;
    const command = new PutObjectCommand({
      Bucket: this.bucket,
      Key: key,
      ContentType: upload.contentType,
      ContentLength: upload.sizeBytes,
    });
    const uploadUrl = await getSignedUrl(this.requireClient(), command, {
      expiresIn: UPLOAD_URL_TTL_SECONDS,
      signableHeaders: new Set(['content-type', 'content-length']),
    });
    return {
      key,
      uploadUrl,
      headers: { 'Content-Type': upload.contentType },
      expiresInSeconds: UPLOAD_URL_TTL_SECONDS,
    };
  }

  /** A URL the browser or app can load the object from; null when storage is not configured at all. */
  async viewUrl(key: string): Promise<string | null> {
    if (this.publicUrl) return `${this.publicUrl}/${key}`;
    if (!this.client) return null;
    return getSignedUrl(this.client, new GetObjectCommand({ Bucket: this.bucket, Key: key }), {
      expiresIn: VIEW_URL_TTL_SECONDS,
    });
  }

  /**
   * Best-effort removal of photos nobody references any more. A failure is logged, never thrown: the
   * recipe change that triggered it has already been saved, and a leftover object is harmless.
   */
  async deleteObjects(keys: string[]): Promise<void> {
    if (!this.client || keys.length === 0) return;
    for (let start = 0; start < keys.length; start += DELETE_BATCH) {
      const batch = keys.slice(start, start + DELETE_BATCH);
      try {
        const result = await this.client.send(
          new DeleteObjectsCommand({
            Bucket: this.bucket,
            Delete: { Objects: batch.map((Key) => ({ Key })), Quiet: true },
          }),
        );
        // A rejected key does not make the call throw; it only shows up in `Errors`.
        if (result.Errors?.length) {
          this.logger.warn(`Could not delete ${result.Errors.length} stored photo(s): ${result.Errors[0]?.Code}`);
        }
      } catch (error) {
        this.logger.warn(`Could not delete ${batch.length} stored photo(s): ${String(error)}`);
      }
    }
  }

  /** Returns null when the object is missing or larger than `maxBytes`. */
  async readObject(key: string, maxBytes: number): Promise<{ bytes: Buffer; contentType: string } | null> {
    try {
      const response = await this.requireClient().send(new GetObjectCommand({ Bucket: this.bucket, Key: key }));
      if (!response.Body || (response.ContentLength ?? 0) > maxBytes) return null;
      const bytes = Buffer.from(await response.Body.transformToByteArray());
      if (bytes.length > maxBytes) return null;
      return { bytes, contentType: response.ContentType ?? 'application/octet-stream' };
    } catch (error) {
      if ((error as { name?: string }).name === 'NoSuchKey') return null;
      throw error;
    }
  }

  private requireClient(): S3Client {
    if (!this.client) throw new ServiceUnavailableException('Image uploads are not configured');
    return this.client;
  }
}
