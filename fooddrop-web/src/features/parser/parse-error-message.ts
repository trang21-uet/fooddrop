import { ApiError } from "@/lib/api/api-error";
import type { ParseErrorCode } from "./parser-types";

const MESSAGES: Record<ParseErrorCode, string> = {
  url_blocked: "Liên kết này không hợp lệ hoặc không được phép truy cập. Hãy dùng đường dẫn công khai bắt đầu bằng http(s).",
  fetch_failed: "Không tải được trang này (có thể trang chặn truy cập tự động). Hãy thử chụp ảnh công thức hoặc nhập tay.",
  not_a_recipe: "Không tìm thấy công thức nấu ăn trong nội dung này.",
  image_unreadable: "Không đọc được ảnh. Hãy chụp rõ hơn, đủ sáng và thử lại.",
  parser_unavailable: "Dịch vụ đọc công thức đang bận hoặc chưa sẵn sàng. Vui lòng thử lại sau.",
  internal_error: "Có lỗi khi đọc công thức. Vui lòng thử lại.",
};

export function parseErrorMessage(code: ParseErrorCode | null): string {
  return code ? MESSAGES[code] : MESSAGES.internal_error;
}

/** Errors thrown while starting a job (before any job exists). */
export function startErrorMessage(error: unknown): string {
  if (error instanceof ApiError) {
    if (error.status === 429) return "Bạn đã nhập quá nhiều công thức. Hãy thử lại sau.";
    if (error.status === 503) return "Tính năng nhập công thức tạm thời không khả dụng.";
    return "Không bắt đầu được việc nhập công thức.";
  }
  // Client-side failures (unreadable image) already carry a Vietnamese message.
  return error instanceof Error ? error.message : "Không bắt đầu được việc nhập công thức.";
}
