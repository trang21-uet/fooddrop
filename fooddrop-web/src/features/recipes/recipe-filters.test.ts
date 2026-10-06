import {
  filtersToSearchParams,
  hasActiveFilters,
  parseFilters,
  toggleItem,
  type RecipeFilters,
} from "./recipe-filters";

const parse = (query: string) => parseFilters(new URLSearchParams(query));

describe("parseFilters", () => {
  it("returns empty filters for an empty query", () => {
    expect(parse("")).toEqual({ tagIds: [], rarities: [], maxMinutes: undefined, q: "" });
  });

  it("reads every dimension", () => {
    expect(parse("tags=3,7&rarity=blue,red&maxMinutes=30&q=pho")).toEqual({
      tagIds: [3, 7],
      rarities: ["blue", "red"],
      maxMinutes: 30,
      q: "pho",
    });
  });

  it("drops malformed values instead of throwing", () => {
    expect(parse("tags=1,abc,-2,0,2.5&rarity=gold,white&maxMinutes=-5")).toEqual({
      tagIds: [1],
      rarities: ["white"],
      maxMinutes: undefined,
      q: "",
    });
  });
});

describe("filtersToSearchParams", () => {
  it("omits empty filters", () => {
    expect(filtersToSearchParams({ tagIds: [], rarities: [], q: "" }).toString()).toBe("");
  });

  it("round-trips through parseFilters", () => {
    const filters: RecipeFilters = { tagIds: [4, 9], rarities: ["purple"], maxMinutes: 60, q: "gà" };
    expect(parseFilters(filtersToSearchParams(filters))).toEqual(filters);
  });
});

describe("toggleItem / hasActiveFilters", () => {
  it("adds then removes an item without mutating the input", () => {
    const original = [1, 2];
    expect(toggleItem(original, 3)).toEqual([1, 2, 3]);
    expect(toggleItem(original, 2)).toEqual([1]);
    expect(original).toEqual([1, 2]);
  });

  it("detects active filters", () => {
    expect(hasActiveFilters({ tagIds: [], rarities: [], q: "" })).toBe(false);
    expect(hasActiveFilters({ tagIds: [], rarities: [], q: "x" })).toBe(true);
  });
});
