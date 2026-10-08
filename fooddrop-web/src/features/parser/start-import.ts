import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";
import { uploadImage } from "@/lib/images/upload-image";

export async function startUrlImport(url: string): Promise<string> {
  return unwrap(await apiClient.POST("/parser/jobs", { body: { url } })).id;
}

/** Upload the photo, then queue the parse job. */
export async function startImageImport(file: File): Promise<string> {
  const imageKey = await uploadImage(file, "parser");
  return unwrap(await apiClient.POST("/parser/jobs", { body: { imageKey } })).id;
}
