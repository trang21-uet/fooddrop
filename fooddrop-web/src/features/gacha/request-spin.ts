import { apiClient } from "@/lib/api/api-client";
import { ApiError, unwrap } from "@/lib/api/api-error";
import type { CaseId } from "./gacha-case-styles";
import type { GachaSpin } from "./gacha-types";

/** Opens a cook case. The server draws the result from the case's recipes. */
export async function requestSpin(caseId: CaseId): Promise<GachaSpin> {
  const result = await apiClient.POST("/gacha/spins", { body: { caseType: "cook", caseId } });
  // 422 (empty case) and 429 (too many spins) share the GachaError body.
  if ((result.response.status === 422 || result.response.status === 429) && result.error) {
    throw new ApiError(result.response.status, result.error.message, result.error.retryAfterSeconds);
  }
  return unwrap(result);
}

/** Vietnamese copy for a failed spin; the server's messages are English. */
export function spinErrorMessage(error: unknown): string {
  if (error instanceof ApiError && error.status === 422) {
    return "Hòm này chưa có món nào. Chọn hòm khác hoặc thêm công thức nhé.";
  }
  if (error instanceof ApiError && error.status === 429) {
    const wait = error.retryAfterSeconds ? ` sau ${error.retryAfterSeconds} giây` : " sau ít phút";
    return `Bạn quay nhanh quá, thử lại${wait}.`;
  }
  return "Không quay được lúc này. Thử lại sau nhé.";
}
