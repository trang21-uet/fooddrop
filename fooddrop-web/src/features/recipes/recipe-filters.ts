import type { Rarity } from "./recipe-types";

export const RARITY_ORDER: readonly Rarity[] = ["white", "blue", "purple", "pink", "red"];
export const MAX_MINUTES_OPTIONS = [
  { minutes: 30, label: "30 phút" },
  { minutes: 60, label: "60 phút" },
  { minutes: 120, label: "2 giờ" },
] as const;

export interface RecipeFilters {
  tagIds: number[];
  rarities: Rarity[];
  maxMinutes?: number;
  q: string;
}

export const EMPTY_FILTERS: RecipeFilters = { tagIds: [], rarities: [], q: "" };

type ParamReader = { get(name: string): string | null };

function parseList(raw: string | null): string[] {
  return raw ? raw.split(",").map((part) => part.trim()).filter(Boolean) : [];
}

/** URL search params → filters. Unknown or malformed values are dropped so a hand-edited URL never breaks the page. */
export function parseFilters(params: ParamReader): RecipeFilters {
  const tagIds = parseList(params.get("tags"))
    .map(Number)
    .filter((id) => Number.isInteger(id) && id > 0);
  const rarities = parseList(params.get("rarity")).filter((value): value is Rarity =>
    (RARITY_ORDER as readonly string[]).includes(value),
  );
  const maxMinutes = Number(params.get("maxMinutes"));
  return {
    tagIds,
    rarities,
    maxMinutes: Number.isInteger(maxMinutes) && maxMinutes > 0 ? maxMinutes : undefined,
    q: (params.get("q") ?? "").trim().slice(0, 100),
  };
}

/** Filters → URL search params; empty filters are omitted so the unfiltered URL stays clean. */
export function filtersToSearchParams(filters: RecipeFilters): URLSearchParams {
  const params = new URLSearchParams();
  if (filters.tagIds.length) params.set("tags", filters.tagIds.join(","));
  if (filters.rarities.length) params.set("rarity", filters.rarities.join(","));
  if (filters.maxMinutes) params.set("maxMinutes", String(filters.maxMinutes));
  if (filters.q) params.set("q", filters.q);
  return params;
}

export function toggleItem<T>(items: readonly T[], item: T): T[] {
  return items.includes(item) ? items.filter((existing) => existing !== item) : [...items, item];
}

export function hasActiveFilters(filters: RecipeFilters): boolean {
  return Boolean(filters.tagIds.length || filters.rarities.length || filters.maxMinutes || filters.q);
}
