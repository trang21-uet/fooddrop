import { z } from "zod";
import type { RecipeDetail, RecipeInput } from "../recipe-types";

const numberField = (message: string) => z.number({ error: message });
const optionalUrl = z.union([z.literal(""), z.url({ protocol: /^https?$/, error: "Nhập đường dẫn http(s) hợp lệ" })]);

export const ingredientRowSchema = z.object({
  ingredientId: z.string().min(1, "Chọn một nguyên liệu trong danh sách"),
  ingredientName: z.string(),
  // Optional ("muối, tùy khẩu vị"). Raw text ("1 1/2", "2-3"); the backend parses it.
  quantity: z.string().trim().max(20),
  // A unit code from the catalog ("tbsp"); blank = none. Only sent together with a quantity.
  unit: z.string().trim().max(30),
  note: z.string().trim().max(200),
});

export const MAX_STEP_IMAGES = 10;

/** `url` is a local preview for a photo uploaded in this session, or the server's URL for a saved one. */
export const stepImageSchema = z.object({ key: z.string().min(1), url: z.string().nullable() });
export type StepImage = z.infer<typeof stepImageSchema>;

export const stepRowSchema = z.object({
  name: z.string().trim().max(100, "Tên bước tối đa 100 ký tự"),
  text: z.string().trim().min(1, "Hãy mô tả bước này").max(2000),
  note: z.string().trim().max(500, "Lưu ý tối đa 500 ký tự"),
  images: z.array(stepImageSchema).max(MAX_STEP_IMAGES),
  timerMinutes: numberField("Nhập số phút").int("Chỉ nhập số phút nguyên").min(1).max(1440).optional(),
  // Not editable in the UI yet; carried through so editing a recipe never drops an existing label.
  timerLabel: z.string().optional(),
});

export type StepRow = z.infer<typeof stepRowSchema>;
export const EMPTY_STEP: StepRow = { name: "", text: "", note: "", images: [] };

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
  steps: [EMPTY_STEP],
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
      ...(step.name ? { name: step.name } : {}),
      text: step.text,
      ...(step.note ? { note: step.note } : {}),
      images: step.images.map((image) => image.key),
      ...(step.timerMinutes ? { timerSeconds: step.timerMinutes * 60 } : {}),
      ...(step.timerMinutes && step.timerLabel ? { timerLabel: step.timerLabel } : {}),
    })),
    ingredients: values.ingredients.map((row) => ({
      ingredientId: row.ingredientId,
      quantity: row.quantity || null,
      unit: row.quantity && row.unit ? row.unit : null,
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
      quantity: item.quantity === null ? "" : String(Number.parseFloat(item.quantity.toFixed(2))),
      unit: item.unit?.code ?? "",
      note: item.note ?? "",
    })),
    steps: recipe.steps.map((step) => ({
      name: step.name ?? "",
      text: step.text,
      note: step.note ?? "",
      images: step.images,
      // Timers are stored in seconds; the form edits whole minutes (ceil keeps a sub-minute timer non-zero).
      timerMinutes: step.timerSeconds ? Math.ceil(step.timerSeconds / 60) : undefined,
      timerLabel: step.timerLabel,
    })),
    tagIds: recipe.tags.map((tag) => tag.id),
  };
}
