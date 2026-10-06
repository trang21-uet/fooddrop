import { z } from "zod";
import type { RecipeDetail, RecipeInput } from "../recipe-types";

const numberField = (message: string) => z.number({ error: message });
const optionalUrl = z.union([z.literal(""), z.url({ protocol: /^https?$/, error: "Nhập đường dẫn http(s) hợp lệ" })]);

export const ingredientRowSchema = z.object({
  ingredientId: z.string().min(1, "Chọn một nguyên liệu trong danh sách"),
  ingredientName: z.string(),
  // Raw text ("1 1/2", "2-3"); the backend parses and normalizes it to g | ml | piece.
  quantity: z.string().trim().min(1, "Bắt buộc").max(20),
  // Blank means pieces.
  unit: z.string().trim().max(30),
  note: z.string().trim().max(200),
});

export const stepRowSchema = z.object({
  text: z.string().trim().min(1, "Hãy mô tả bước này").max(2000),
  timerMinutes: numberField("Nhập số phút").int("Chỉ nhập số phút nguyên").min(1).max(1440).optional(),
  // Not editable in the UI yet; carried through so editing a recipe never drops an existing label.
  timerLabel: z.string().optional(),
});

export const recipeFormSchema = z.object({
  title: z.string().trim().min(1, "Cần nhập tiêu đề").max(200),
  description: z.string().trim().max(2000),
  imageUrl: optionalUrl,
  sourceUrl: optionalUrl,
  baseServings: numberField("Nhập số khẩu phần").int("Chỉ nhập số khẩu phần nguyên").min(1).max(100),
  totalMinutes: numberField("Nhập tổng số phút").int("Chỉ nhập số phút nguyên").min(1).max(10_080),
  difficulty: numberField("Chọn độ khó").int().min(1).max(5),
  ingredients: z.array(ingredientRowSchema).max(100),
  steps: z.array(stepRowSchema).min(1, "Thêm ít nhất một bước").max(100),
  tagIds: z.array(z.number().int().positive()).max(30),
});

export type RecipeFormValues = z.infer<typeof recipeFormSchema>;

export const EMPTY_RECIPE_FORM: RecipeFormValues = {
  title: "",
  description: "",
  imageUrl: "",
  sourceUrl: "",
  baseServings: 2,
  totalMinutes: 30,
  difficulty: 2,
  ingredients: [],
  steps: [{ text: "" }],
  tagIds: [],
};

/** Form state → API payload. Blank optional fields become null so edits can clear them. */
export function toRecipeInput(values: RecipeFormValues): RecipeInput {
  return {
    title: values.title,
    description: values.description || null,
    imageUrl: values.imageUrl || null,
    sourceUrl: values.sourceUrl || null,
    baseServings: values.baseServings,
    totalMinutes: values.totalMinutes,
    difficulty: values.difficulty,
    steps: values.steps.map((step) => ({
      text: step.text,
      ...(step.timerMinutes ? { timerSeconds: step.timerMinutes * 60 } : {}),
      ...(step.timerMinutes && step.timerLabel ? { timerLabel: step.timerLabel } : {}),
    })),
    ingredients: values.ingredients.map((row) => ({
      ingredientId: row.ingredientId,
      quantity: row.quantity,
      unit: row.unit || null,
      note: row.note || null,
    })),
    tagIds: values.tagIds,
  };
}

/** API detail → form state, for the edit page. */
export function toFormValues(recipe: RecipeDetail): RecipeFormValues {
  return {
    title: recipe.title,
    description: recipe.description ?? "",
    imageUrl: recipe.imageUrl ?? "",
    sourceUrl: recipe.sourceUrl ?? "",
    baseServings: recipe.baseServings,
    totalMinutes: recipe.totalMinutes,
    difficulty: recipe.difficulty,
    ingredients: recipe.ingredients.map((item) => ({
      ingredientId: item.ingredient.id,
      ingredientName: item.ingredient.name,
      quantity: String(Number.parseFloat(item.quantity.toFixed(2))),
      unit: item.unit === "piece" ? "" : item.unit,
      note: item.note ?? "",
    })),
    steps: recipe.steps.map((step) => ({
      text: step.text,
      // Timers are stored in seconds; the form edits whole minutes (ceil keeps a sub-minute timer non-zero).
      timerMinutes: step.timerSeconds ? Math.ceil(step.timerSeconds / 60) : undefined,
      timerLabel: step.timerLabel,
    })),
    tagIds: recipe.tags.map((tag) => tag.id),
  };
}
