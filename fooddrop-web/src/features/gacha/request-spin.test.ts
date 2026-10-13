import { ApiError } from "@/lib/api/api-error";
import { spinErrorMessage } from "./request-spin";

describe("spinErrorMessage", () => {
  it("explains an empty pool", () => {
    expect(spinErrorMessage(new ApiError(422, "No recipes match these filters"))).toMatch(/Hòm này chưa có món nào/);
  });

  it("uses the server's wait time for the rate limit", () => {
    expect(spinErrorMessage(new ApiError(429, "Too many spins", 42))).toContain("42 giây");
    expect(spinErrorMessage(new ApiError(429, "Too many spins"))).toContain("ít phút");
  });

  it("falls back to a generic line", () => {
    expect(spinErrorMessage(new Error("network"))).toMatch(/Không quay được/);
  });
});
