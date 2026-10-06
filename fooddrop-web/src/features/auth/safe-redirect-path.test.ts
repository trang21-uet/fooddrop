import { safeRedirectPath } from "./safe-redirect-path";

describe("safeRedirectPath", () => {
  it("keeps same-origin paths with query strings", () => {
    expect(safeRedirectPath("/recipes?tags=1,2")).toBe("/recipes?tags=1,2");
  });

  it.each([null, undefined, "", "recipes", "https://evil.test", "//evil.test", "/\\evil.test"])(
    "falls back for %s",
    (value) => {
      expect(safeRedirectPath(value)).toBe("/recipes");
    },
  );
});
