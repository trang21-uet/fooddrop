import { recipeFormSchema } from "../recipes/recipe-form/recipe-form-schema";
import { draftToFormValues } from "./draft-to-form-values";
import type { ParsedRecipeDraft } from "./parser-types";

const draft: ParsedRecipeDraft = {
  source: "json-ld",
  title: "Thịt kho trứng",
  description: null,
  imageUrl: "https://example.com/a.jpg",
  sourceUrl: "https://example.com/thit-kho",
  baseServings: 4,
  totalMinutes: null,
  difficulty: 2,
  ingredients: [
    {
      name: "pork belly",
      matchedName: "Thịt ba chỉ",
      ingredientId: "11111111-1111-4111-8111-111111111111",
      isNew: false,
      quantity: 500,
      unit: "g",
      note: null,
    },
    { name: "trứng cút", matchedName: null, ingredientId: null, isNew: true, quantity: 12.004, unit: "fruit", note: "luộc chín" },
    { name: "muối", matchedName: null, ingredientId: null, isNew: true, quantity: null, unit: null, note: "tùy khẩu vị" },
  ],
  steps: [{ text: "Ướp thịt." }, { text: "Hầm 45 phút.", timerSeconds: 2700 }],
  suggestedTagIds: [3, 7],
};

describe("draftToFormValues", () => {
  it("maps the draft to form fields, preferring the catalog name for matched ingredients", () => {
    const values = draftToFormValues(draft);
    expect(values).toMatchObject({
      title: "Thịt kho trứng",
      description: "",
      totalMinutes: 30,
      tagIds: [3, 7],
      steps: [
        { name: "", text: "Ướp thịt.", images: [], timerMinutes: undefined },
        { name: "", text: "Hầm 45 phút.", images: [], timerMinutes: 45 },
      ],
    });
    expect(values.ingredients).toEqual([
      { ingredientId: "11111111-1111-4111-8111-111111111111", ingredientName: "Thịt ba chỉ", quantity: "500", unit: "g", note: "" },
      { ingredientId: "", ingredientName: "trứng cút", quantity: "12", unit: "fruit", note: "luộc chín" },
      { ingredientId: "", ingredientName: "muối", quantity: "", unit: "", note: "tùy khẩu vị" },
    ]);
  });

  it("produces values the form schema accepts once new ingredients are resolved", () => {
    const values = draftToFormValues(draft);
    values.ingredients[1]!.ingredientId = "22222222-2222-4222-8222-222222222222";
    values.ingredients[2]!.ingredientId = "33333333-3333-4333-8333-333333333333";
    expect(recipeFormSchema.safeParse(values).success).toBe(true);
  });

  it("flags unresolved ingredients instead of silently saving them", () => {
    expect(recipeFormSchema.safeParse(draftToFormValues(draft)).success).toBe(false);
  });

  it("always leaves one editable step when the source had none", () => {
    expect(draftToFormValues({ ...draft, steps: [] }).steps).toEqual([{ name: "", text: "", images: [] }]);
  });
});
