import { clearParseCooldown, parseCooldownSecondsLeft, startParseCooldown } from "./parse-cooldown";

describe("parse cooldown", () => {
  beforeEach(() => clearParseCooldown());

  it("is not running until an import starts", () => {
    expect(parseCooldownSecondsLeft()).toBe(0);
  });

  it("counts down from the server's length and ends at zero", () => {
    startParseCooldown(60, 1_000_000);
    expect(parseCooldownSecondsLeft(1_000_000)).toBe(60);
    expect(parseCooldownSecondsLeft(1_000_000 + 59_001)).toBe(1);
    expect(parseCooldownSecondsLeft(1_000_000 + 60_000)).toBe(0);
    expect(parseCooldownSecondsLeft(1_000_000 + 90_000)).toBe(0);
  });

  it("uses the server's remaining time when given", () => {
    startParseCooldown(25, 1_000_000);
    expect(parseCooldownSecondsLeft(1_000_000)).toBe(25);
  });

  it("does not block when the server's cooldown is off", () => {
    startParseCooldown(0, 1_000_000);
    expect(parseCooldownSecondsLeft(1_000_000)).toBe(0);
  });

  it("survives a reload because the end time is stored", () => {
    startParseCooldown(60, Date.now());
    expect(Number(window.localStorage.getItem("fooddrop:parse-cooldown-ends-at"))).toBeGreaterThan(Date.now());
  });

  it("still works when storage is blocked", () => {
    const setItem = vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new Error("blocked");
    });
    startParseCooldown(60, Date.now());
    expect(parseCooldownSecondsLeft()).toBeGreaterThan(0);
    setItem.mockRestore();
  });

  it("is cleared on sign-out", () => {
    startParseCooldown(60);
    clearParseCooldown();
    expect(parseCooldownSecondsLeft()).toBe(0);
  });
});
