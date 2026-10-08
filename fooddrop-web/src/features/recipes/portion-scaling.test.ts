import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { roundForUnit, scaleIngredientQuantity } from "./portion-scaling";

interface Cases {
  round: { quantity: number; unit: string; expected: number }[];
  scale: { quantity: number; unit: string; servings: number; baseServings: number; expected: number }[];
}

const cases = JSON.parse(readFileSync(resolve(process.cwd(), "../docs/fixtures/portion-scaling-cases.json"), "utf8")) as Cases;

describe("roundForUnit (shared vectors)", () => {
  it.each(cases.round)("$quantity $unit -> $expected", ({ quantity, unit, expected }) => {
    expect(roundForUnit(quantity, unit)).toBe(expected);
  });
});

describe("scaleIngredientQuantity (shared vectors)", () => {
  it.each(cases.scale)("$quantity $unit x $servings/$baseServings -> $expected", (c) => {
    expect(scaleIngredientQuantity(c.quantity, c.unit, c.servings, c.baseServings)).toBe(c.expected);
  });
});
