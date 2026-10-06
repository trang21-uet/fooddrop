import { formatQuantity } from "./format-quantity";

describe("formatQuantity", () => {
  it("appends mass and volume units", () => {
    expect(formatQuantity(250, "g")).toBe("250 g");
    expect(formatQuantity(15, "ml")).toBe("15 ml");
  });

  it("leaves counts bare", () => {
    expect(formatQuantity(2, "piece")).toBe("2");
  });

  it("trims floating point noise", () => {
    expect(formatQuantity(14.786800000000001, "ml")).toBe("14.79 ml");
    expect(formatQuantity(0.1 + 0.2, "g")).toBe("0.3 g");
  });
});
