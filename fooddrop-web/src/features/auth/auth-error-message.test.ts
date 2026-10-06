import { authErrorMessage } from "./auth-error-message";

describe("authErrorMessage", () => {
  it("translates known better-auth codes", () => {
    expect(authErrorMessage({ code: "INVALID_EMAIL_OR_PASSWORD" })).toBe("Email hoặc mật khẩu không đúng.");
  });

  it("falls back to a generic Vietnamese message for unknown or missing codes", () => {
    expect(authErrorMessage({ code: "SOMETHING_NEW" })).toBe("Đã có lỗi xảy ra. Thử lại nhé.");
    expect(authErrorMessage({})).toBe("Đã có lỗi xảy ra. Thử lại nhé.");
  });
});
