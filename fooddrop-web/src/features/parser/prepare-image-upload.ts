const MAX_EDGE_PX = 2000;
const JPEG_QUALITY = 0.85;

/** Scale so the longer edge is at most `maxEdge`, never enlarging. */
export function fitWithin(width: number, height: number, maxEdge: number = MAX_EDGE_PX): { width: number; height: number } {
  const scale = Math.min(1, maxEdge / Math.max(width, height));
  return { width: Math.max(1, Math.round(width * scale)), height: Math.max(1, Math.round(height * scale)) };
}

/**
 * Downscales and re-encodes a camera photo as JPEG. Phone photos are often 8-12 MB; the server
 * accepts 5 MB, and 2000px is plenty for the model to read printed text.
 */
export async function prepareImageUpload(file: File): Promise<Blob> {
  let bitmap: ImageBitmap;
  try {
    bitmap = await createImageBitmap(file);
  } catch {
    throw new Error("Không đọc được ảnh này. Hãy chọn ảnh JPEG, PNG hoặc WebP.");
  }
  try {
    const { width, height } = fitWithin(bitmap.width, bitmap.height);
    const canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;
    const context = canvas.getContext("2d");
    if (!context) throw new Error("Trình duyệt không xử lý được ảnh này.");
    context.drawImage(bitmap, 0, 0, width, height);
    const blob = await new Promise<Blob | null>((resolve) => canvas.toBlob(resolve, "image/jpeg", JPEG_QUALITY));
    if (!blob) throw new Error("Không xử lý được ảnh này.");
    return blob;
  } finally {
    bitmap.close();
  }
}
