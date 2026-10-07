import type { components } from "@/lib/api/schema";

type Schemas = components["schemas"];

export type RecipeSummary = Schemas["RecipeList"]["items"][number];
export type RecipeDetail = Schemas["RecipeDetail"];
export type RecipeInput = Schemas["RecipeInput"];
export type TagDimension = Schemas["TagDimension"];
export type Ingredient = Schemas["Ingredient"];
export type Rarity = RecipeDetail["rarity"];
export type IngredientUnit = RecipeDetail["ingredients"][number]["unit"];
export type Aisle = Ingredient["aisle"];
