const MESSAGES: Record<string, string> = {
  INVALID_EMAIL_OR_PASSWORD: "Email hoặc mật khẩu không đúng.",
  INVALID_EMAIL: "Email không hợp lệ.",
  USER_ALREADY_EXISTS: "Email này đã được dùng. Hãy đăng nhập hoặc dùng email khác.",
  USER_ALREADY_EXISTS_USE_ANOTHER_EMAIL: "Email này đã được dùng. Hãy đăng nhập hoặc dùng email khác.",
  PASSWORD_TOO_SHORT: "Mật khẩu cần ít nhất 8 ký tự.",
  PASSWORD_TOO_LONG: "Mật khẩu quá dài.",
};

/** better-auth returns English messages; map its stable error `code` to Vietnamese and fall back to a generic line. */
export function authErrorMessage(error: { code?: string }): string {
  return (error.code && MESSAGES[error.code]) || "Đã có lỗi xảy ra. Thử lại nhé.";
}
