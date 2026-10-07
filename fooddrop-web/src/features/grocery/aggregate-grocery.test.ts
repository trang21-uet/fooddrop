import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { aggregateGrocery, type GroceryAisleGroup, type GroceryRecipe, type GrocerySelection } from "./aggregate-grocery";

interface Case {
  name: string;
  selections: GrocerySelection[];
  recipes: GroceryRecipe[];
  expected: GroceryAisleGroup[];
}

const { cases } = JSON.parse(
  readFileSync(resolve(process.cwd(), "../docs/fixtures/grocery-aggregation-cases.json"), "utf8"),
) as { cases: Case[] };

describe("aggregateGrocery (shared vectors)", () => {
  it.each(cases)("$name", ({ selections, recipes, expected }) => {
    const byId = new Map(recipes.map((recipe) => [recipe.id, recipe]));
    expect(aggregateGrocery(selections, byId)).toEqual(expected);
  });
});
