import { randomUUID } from 'node:crypto';
import { GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable, ServiceUnavailableException } from '@nestjs/common';
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

@Injectable()
export class ObjectStorageService {
  private readonly client: S3Client | null;
  private readonly bucket: string;

  constructor(config: ConfigService<Env, true>) {
    const accessKeyId = config.get('S3_ACCESS_KEY_ID', { infer: true });
    const secretAccessKey = config.get('S3_SECRET_ACCESS_KEY', { infer: true });
    const endpoint = config.get('S3_ENDPOINT', { infer: true });
    this.bucket = config.get('S3_BUCKET', { infer: true });
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
    const key = `${userUploadPrefix(userId)}${randomUUID()}.${EXTENSIONS[upload.contentType]}`;
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
