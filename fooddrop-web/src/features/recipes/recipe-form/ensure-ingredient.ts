import { apiClient } from "@/lib/api/api-client";
import { ApiError, unwrap } from "@/lib/api/api-error";
import type { Ingredient } from "../recipe-types";
import { createIngredient } from "./use-ingredient-search";

type DefaultUnit = Ingredient["defaultUnit"];

/** The form's unit text decides how a new catalog entry is summed later: blank = counted pieces. */
export function defaultUnitForRowUnit(unit: string): DefaultUnit {
  const folded = unit.trim().toLowerCase();
  if (folded === "") return "piece";
  return folded === "ml" || folded === "l" ? "ml" : "g";
}

/** Creates the ingredient, or returns the existing catalog entry when the name or an alias is already taken. */
export async function ensureIngredient(name: string, defaultUnit: DefaultUnit): Promise<Ingredient> {
  try {
    return await createIngredient(name, defaultUnit);
  } catch (error) {
    if (!(error instanceof ApiError) || error.status !== 409) throw error;
    const found = unwrap(await apiClient.GET("/ingredients", { params: { query: { q: name, limit: 8 } } }));
    const folded = name.trim().toLowerCase();
    const match = found.find((item) => item.name.toLowerCase() === folded || item.aliases.some((alias) => alias.toLowerCase() === folded));
    if (!match) throw error;
    return match;
  }
}
