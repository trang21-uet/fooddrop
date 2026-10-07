import { describe, expect, it } from "vitest";
import { formatCountdown } from "./format-countdown";

describe("formatCountdown", () => {
  it.each([
    [0, "0:00"],
    [-500, "0:00"],
    [1, "0:01"],
    [83_000, "1:23"],
    [600_000, "10:00"],
    [3_725_000, "1:02:05"],
  ])("%i ms -> %s", (ms, expected) => {
    expect(formatCountdown(ms)).toBe(expected);
  });
});
