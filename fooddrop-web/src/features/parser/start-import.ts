import { apiClient } from "@/lib/api/api-client";
import { ApiError, unwrap } from "@/lib/api/api-error";
import { uploadImage } from "@/lib/images/upload-image";
import type { ParseJob } from "./parser-types";

/** The created job; its `cooldownSeconds` is how long the server makes the user wait before the next import. */
export async function startUrlImport(url: string): Promise<ParseJob> {
  return createJob({ url });
}

/** Upload the photo, then queue the parse job. */
export async function startImageImport(file: File): Promise<ParseJob> {
  const imageKey = await uploadImage(file, "parser");
  return createJob({ imageKey });
}

async function createJob(body: { url: string } | { imageKey: string }): Promise<ParseJob> {
  const result = await apiClient.POST("/parser/jobs", { body });
  // The 429 body is typed by the contract (ParseRateLimitError); only the cooldown carries `retryAfterSeconds`.
  if (result.response.status === 429 && result.error) {
    throw new ApiError(429, result.error.message, result.error.retryAfterSeconds);
  }
  return unwrap(result);
}
