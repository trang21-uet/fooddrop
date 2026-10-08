import type { components } from "@/lib/api/schema";

type Schemas = components["schemas"];

export type RecipeSummary = Schemas["RecipeList"]["items"][number];
export type RecipeDetail = Schemas["RecipeDetail"];
export type RecipeInput = Schemas["RecipeInput"];
export type TagDimension = Schemas["TagDimension"];
export type Ingredient = Schemas["Ingredient"];
export type Unit = Schemas["Unit"];
export type Rarity = RecipeDetail["rarity"];
/** What the grocery list sums in: the server converts every recipe line to one of these. */
export type BaseUnit = RecipeDetail["ingredients"][number]["base"]["unit"];
export type Aisle = Ingredient["aisle"];
