import type { RecipeDetail } from "../recipe-types";
import { EMPTY_RECIPE_FORM, recipeFormSchema, toFormValues, toRecipeInput, type RecipeFormValues } from "./recipe-form-schema";

const INGREDIENT_ID = "6f1c1f0e-5b1c-4d3c-9d1e-0a1b2c3d4e5f";

const validValues: RecipeFormValues = {
  ...EMPTY_RECIPE_FORM,
  title: "Phở bò",
  ingredients: [{ ingredientId: INGREDIENT_ID, ingredientName: "Beef", quantity: "1 1/2", unit: "kg", note: "" }],
  steps: [{ text: "Simmer the broth", timerMinutes: 90 }],
  tagIds: [3],
};

function issuesFor(values: unknown): Record<string, string> {
  const result = recipeFormSchema.safeParse(values);
  if (result.success) return {};
  return Object.fromEntries(result.error.issues.map((issue) => [issue.path.join("."), issue.message]));
}

describe("recipeFormSchema", () => {
  it("accepts a complete recipe", () => {
    expect(recipeFormSchema.safeParse(validValues).success).toBe(true);
  });

  it("requires a title, a step and a positive time", () => {
    const issues = issuesFor({ ...validValues, title: "  ", steps: [], totalMinutes: Number.NaN });
    expect(issues.title).toBe("Cần nhập tiêu đề");
    expect(issues.steps).toBe("Thêm ít nhất một bước");
    expect(issues.totalMinutes).toBe("Nhập tổng số phút");
  });

  it("rejects blank step text and unpicked ingredients", () => {
    const issues = issuesFor({
      ...validValues,
      steps: [{ text: " " }],
      ingredients: [{ ingredientId: "", ingredientName: "beef", quantity: "", unit: "", note: "" }],
    });
    expect(issues["steps.0.text"]).toBe("Hãy mô tả bước này");
    expect(issues["ingredients.0.ingredientId"]).toBe("Chọn một nguyên liệu trong danh sách");
    expect(issues["ingredients.0.quantity"]).toBe("Bắt buộc");
  });

  it("rejects non-http image URLs", () => {
    expect(issuesFor({ ...validValues, imageUrl: "javascript:alert(1)" }).imageUrl).toBeDefined();
    expect(issuesFor({ ...validValues, imageUrl: "https://example.com/a.jpg" }).imageUrl).toBeUndefined();
  });

  it("limits difficulty to 1-5", () => {
    expect(issuesFor({ ...validValues, difficulty: 6 }).difficulty).toBeDefined();
    expect(issuesFor({ ...validValues, difficulty: 0 }).difficulty).toBeDefined();
  });
});

describe("toRecipeInput", () => {
  it("converts minutes to seconds and blanks to null", () => {
    const input = toRecipeInput(validValues);
    expect(input.steps).toEqual([{ text: "Simmer the broth", timerSeconds: 5400 }]);
    expect(input.description).toBeNull();
    expect(input.imageUrl).toBeNull();
    expect(input.ingredients).toEqual([{ ingredientId: INGREDIENT_ID, quantity: "1 1/2", unit: "kg", note: null }]);
  });

  it("drops a timer label when the timer is cleared", () => {
    const input = toRecipeInput({ ...validValues, steps: [{ text: "Stir", timerLabel: "Rest" }] });
    expect(input.steps).toEqual([{ text: "Stir" }]);
  });
});

describe("toFormValues", () => {
  const detail: RecipeDetail = {
    id: "11111111-1111-4111-8111-111111111111",
    title: "Egg rice",
    description: null,
    imageUrl: null,
    sourceUrl: null,
    baseServings: 1,
    totalMinutes: 10,
    difficulty: 1,
    rarity: "white",
    createdAt: "2026-10-06T00:00:00.000Z",
    updatedAt: "2026-10-06T00:00:00.000Z",
    tags: [{ id: 5, slug: "breakfast", label: "Breakfast", dimension: "meal_type" }],
    steps: [{ order: 1, text: "Fry the egg", timerSeconds: 90, timerLabel: "Egg" }],
    ingredients: [
      { ingredient: { id: INGREDIENT_ID, name: "Egg", aisle: "dairy" }, quantity: 2, unit: "piece", note: null },
      { ingredient: { id: INGREDIENT_ID, name: "Oil", aisle: "pantry" }, quantity: 14.79, unit: "ml", note: "any" },
    ],
  };

  it("maps an API recipe back into editable form state", () => {
    const values = toFormValues(detail);
    expect(values.description).toBe("");
    expect(values.tagIds).toEqual([5]);
    expect(values.steps).toEqual([{ text: "Fry the egg", timerMinutes: 2, timerLabel: "Egg" }]);
    expect(values.ingredients.map((row) => [row.quantity, row.unit])).toEqual([
      ["2", ""],
      ["14.79", "ml"],
    ]);
    expect(recipeFormSchema.safeParse(values).success).toBe(true);
  });
});
