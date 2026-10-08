import { formatAmount, formatQuantity } from "./format-quantity";

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

describe("formatAmount", () => {
  it("writes the quantity with the unit the cook chose", () => {
    expect(formatAmount(2, { nameVi: "thìa canh" })).toBe("2 thìa canh");
    expect(formatAmount(1.5, { nameVi: "quả" })).toBe("1.5 quả");
  });

  it("leaves a quantity without a unit bare", () => {
    expect(formatAmount(2, null)).toBe("2");
  });

  it("is empty when there is no quantity", () => {
    expect(formatAmount(null, null)).toBe("");
  });

  it("trims floating point noise", () => {
    expect(formatAmount(0.1 + 0.2, { nameVi: "kg" })).toBe("0.3 kg");
  });
});
