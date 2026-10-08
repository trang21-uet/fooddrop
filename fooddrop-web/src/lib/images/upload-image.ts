import { apiClient } from "@/lib/api/api-client";
import { ApiError, unwrap } from "@/lib/api/api-error";
import { prepareImageUpload } from "./prepare-image-upload";

export type UploadPurpose = "parser" | "recipe-step";

/** Downscales a photo and uploads it straight to object storage with a signed URL; resolves to its key. */
export async function uploadImage(file: File, purpose: UploadPurpose): Promise<string> {
  const image = await prepareImageUpload(file);
  const created = await apiClient.POST("/media/uploads", { body: { purpose, contentType: "image/jpeg", sizeBytes: image.size } });
  // The API answers 503 when no object storage is configured; its message is English.
  if (created.response.status === 503) throw new ApiError(503, "Máy chủ chưa bật tính năng tải ảnh.");
  const target = unwrap(created);
  // The PUT goes to the storage origin, not the API; the signature covers these exact headers.
  const upload = await fetch(target.uploadUrl, { method: "PUT", headers: target.headers, body: image });
  if (!upload.ok) throw new ApiError(upload.status, "Tải ảnh lên thất bại");
  return target.key;
}
