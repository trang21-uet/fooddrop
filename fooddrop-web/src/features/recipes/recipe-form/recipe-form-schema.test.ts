import type { RecipeDetail } from "../recipe-types";
import { EMPTY_RECIPE_FORM, recipeFormSchema, toFormValues, toRecipeInput, type RecipeFormValues } from "./recipe-form-schema";

const INGREDIENT_ID = "6f1c1f0e-5b1c-4d3c-9d1e-0a1b2c3d4e5f";

const validValues: RecipeFormValues = {
  ...EMPTY_RECIPE_FORM,
  title: "Phở bò",
  ingredients: [{ ingredientId: INGREDIENT_ID, ingredientName: "Beef", quantity: "1 1/2", unit: "kg", note: "" }],
  steps: [{ name: "Hầm", text: "Simmer the broth", timerMinutes: 90, images: [{ key: "recipes/u1/a.jpg", url: "blob:a" }] }],
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
      steps: [{ name: "", text: " ", images: [] }],
      ingredients: [{ ingredientId: "", ingredientName: "beef", quantity: "", unit: "", note: "" }],
    });
    expect(issues["steps.0.text"]).toBe("Hãy mô tả bước này");
    expect(issues["ingredients.0.ingredientId"]).toBe("Chọn một nguyên liệu trong danh sách");
    // Quantity and unit are optional ("muối, tùy khẩu vị").
    expect(issues["ingredients.0.quantity"]).toBeUndefined();
  });

  it("allows at most 10 photos per step", () => {
    const images = Array.from({ length: 11 }, (_, i) => ({ key: `recipes/u1/${i}.jpg`, url: null }));
    expect(issuesFor({ ...validValues, steps: [{ name: "", text: "x", images }] })["steps.0.images"]).toBeDefined();
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
    expect(input.steps).toEqual([
      { name: "Hầm", text: "Simmer the broth", images: ["recipes/u1/a.jpg"], timerSeconds: 5400 },
    ]);
    expect(input.description).toBeNull();
    expect(input.imageUrl).toBeNull();
    expect(input.ingredients).toEqual([{ ingredientId: INGREDIENT_ID, quantity: "1 1/2", unit: "kg", note: null }]);
  });

  it("drops a timer label when the timer is cleared", () => {
    const input = toRecipeInput({ ...validValues, steps: [{ name: "", text: "Stir", timerLabel: "Rest", images: [] }] });
    expect(input.steps).toEqual([{ text: "Stir", images: [] }]);
  });

  it("sends a unit only together with a quantity, and a blank quantity as null", () => {
    const row = { ingredientId: INGREDIENT_ID, ingredientName: "Salt", note: "" };
    const input = toRecipeInput({
      ...validValues,
      ingredients: [
        { ...row, quantity: "2", unit: "tbsp" },
        { ...row, quantity: "2", unit: "" },
        { ...row, quantity: "", unit: "tbsp" },
        { ...row, quantity: "", unit: "" },
      ],
    });
    expect(input.ingredients.map((item) => [item.quantity, item.unit])).toEqual([
      ["2", "tbsp"],
      ["2", null],
      [null, null],
      [null, null],
    ]);
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
    steps: [
      {
        order: 1,
        name: "Chiên",
        text: "Fry the egg",
        images: [{ key: "recipes/u1/a.jpg", url: "https://cdn.example/a.jpg" }],
        timerSeconds: 90,
        timerLabel: "Egg",
      },
    ],
    ingredients: [
      { ingredient: { id: INGREDIENT_ID, name: "Egg", aisle: "dairy" }, quantity: 2, unit: null, note: null, base: { quantity: 2, unit: "piece" } },
      {
        ingredient: { id: INGREDIENT_ID, name: "Oil", aisle: "pantry" },
        quantity: 1,
        unit: { code: "tbsp", nameVi: "thìa canh", nameEn: "tablespoon", kind: "volume" },
        note: "any",
        base: { quantity: 15, unit: "ml" },
      },
      { ingredient: { id: INGREDIENT_ID, name: "Salt", aisle: "spices" }, quantity: null, unit: null, note: null, base: { quantity: 0, unit: "g" } },
    ],
  };

  it("maps an API recipe back into editable form state", () => {
    const values = toFormValues(detail);
    expect(values.description).toBe("");
    expect(values.tagIds).toEqual([5]);
    expect(values.steps).toEqual([
      {
        name: "Chiên",
        text: "Fry the egg",
        images: [{ key: "recipes/u1/a.jpg", url: "https://cdn.example/a.jpg" }],
        timerMinutes: 2,
        timerLabel: "Egg",
      },
    ]);
    expect(values.ingredients.map((row) => [row.quantity, row.unit])).toEqual([
      ["2", ""],
      ["1", "tbsp"],
      ["", ""],
    ]);
    expect(recipeFormSchema.safeParse(values).success).toBe(true);
  });
});
