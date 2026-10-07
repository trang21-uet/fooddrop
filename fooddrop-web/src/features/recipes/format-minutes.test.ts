import { formatMinutes } from "./format-minutes";

describe("formatMinutes", () => {
  it("keeps short durations in minutes", () => {
    expect(formatMinutes(45)).toBe("45 phút");
  });

  it("switches to hours from 60 minutes", () => {
    expect(formatMinutes(60)).toBe("1 giờ");
    expect(formatMinutes(180)).toBe("3 giờ");
    expect(formatMinutes(150)).toBe("2 giờ 30 phút");
  });
});
