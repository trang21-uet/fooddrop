import type { components } from "@/lib/api/schema";

type Schemas = components["schemas"];

export type GachaSpin = Schemas["GachaSpin"];
export type GachaRecipeCard = GachaSpin["result"];
export type GachaSpinHistory = Schemas["GachaSpinHistory"];
