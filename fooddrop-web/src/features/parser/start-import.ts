import { apiClient } from "@/lib/api/api-client";
import { ApiError, unwrap } from "@/lib/api/api-error";
import { prepareImageUpload } from "./prepare-image-upload";

export async function startUrlImport(url: string): Promise<string> {
  return unwrap(await apiClient.POST("/parser/jobs", { body: { url } })).id;
}

/** Downscale, upload straight to object storage with a signed URL, then queue the parse job. */
export async function startImageImport(file: File): Promise<string> {
  const image = await prepareImageUpload(file);
  const target = unwrap(
    await apiClient.POST("/media/uploads", { body: { contentType: "image/jpeg", sizeBytes: image.size } }),
  );
  // The PUT goes to the storage origin, not the API; the signature covers these exact headers.
  const upload = await fetch(target.uploadUrl, { method: "PUT", headers: target.headers, body: image });
  if (!upload.ok) throw new ApiError(upload.status, "Tải ảnh lên thất bại");
  return unwrap(await apiClient.POST("/parser/jobs", { body: { imageKey: target.key } })).id;
}
