import { z } from 'zod';
import { createZodDto } from '../../common/zod-dto.js';

export const IMAGE_CONTENT_TYPES = ['image/jpeg', 'image/png', 'image/webp'] as const;
// Claude rejects images above 5 MB, so larger uploads could never be parsed; clients downscale first.
export const MAX_IMAGE_BYTES = 5 * 1024 * 1024;

export const createUploadSchema = z.object({
  contentType: z.enum(IMAGE_CONTENT_TYPES),
  sizeBytes: z.number().int().min(1).max(MAX_IMAGE_BYTES),
});

export const uploadTargetSchema = z.object({
  /** Pass to `POST /parser/jobs` as `imageKey` once the PUT succeeds. */
  key: z.string(),
  uploadUrl: z.url(),
  /** Headers the PUT must send verbatim; they are part of the signature. */
  headers: z.record(z.string(), z.string()),
  expiresInSeconds: z.number().int(),
});

export class CreateUploadDto extends createZodDto('CreateUpload', createUploadSchema) {}
export class UploadTargetDto extends createZodDto('UploadTarget', uploadTargetSchema, 'output') {}

export type CreateUpload = z.output<typeof createUploadSchema>;
export type UploadTarget = z.output<typeof uploadTargetSchema>;
