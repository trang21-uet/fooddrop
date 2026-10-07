import { ApiError } from "@/lib/api/api-error";
import { parseErrorMessage, startErrorMessage } from "./parse-error-message";

describe("parseErrorMessage", () => {
  it("has a Vietnamese message for every code and a generic fallback", () => {
    expect(parseErrorMessage("not_a_recipe")).toMatch(/công thức/);
    expect(parseErrorMessage("fetch_failed")).toMatch(/chụp ảnh/);
    expect(parseErrorMessage(null)).toBe(parseErrorMessage("internal_error"));
  });
});

describe("startErrorMessage", () => {
  it("explains quota and availability errors", () => {
    expect(startErrorMessage(new ApiError(429, "Daily recipe import limit reached"))).toMatch(/quá nhiều/);
    expect(startErrorMessage(new ApiError(503, "x"))).toMatch(/không khả dụng/);
  });

  it("hides raw English server messages behind a generic line", () => {
    expect(startErrorMessage(new ApiError(500, "Internal server error"))).toBe("Không bắt đầu được việc nhập công thức.");
  });

  it("keeps messages from client-side failures (e.g. unreadable image)", () => {
    expect(startErrorMessage(new Error("Không đọc được ảnh này."))).toBe("Không đọc được ảnh này.");
  });
});
