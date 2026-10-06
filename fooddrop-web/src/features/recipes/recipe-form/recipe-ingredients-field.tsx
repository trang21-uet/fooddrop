"use client";

import { Controller, useFieldArray, useFormContext } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { FormField, inputClass } from "@/components/ui/form-field";
import { IngredientAutocomplete } from "./ingredient-autocomplete";
import type { RecipeFormValues } from "./recipe-form-schema";

const UNIT_SUGGESTIONS = ["g", "kg", "ml", "l", "tsp", "tbsp", "cup", "clove", "slice"];
const UNIT_LIST_ID = "ingredient-unit-suggestions";

export function RecipeIngredientsField() {
  const {
    register,
    control,
    setValue,
    getValues,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const { fields, append, remove } = useFieldArray({ control, name: "ingredients" });

  return (
    <section aria-labelledby="ingredients-field-heading" className="flex flex-col gap-4">
      <h2 id="ingredients-field-heading" className="text-lg font-semibold">
        Nguyên liệu
      </h2>
      <datalist id={UNIT_LIST_ID}>
        {UNIT_SUGGESTIONS.map((unit) => (
          <option key={unit} value={unit} />
        ))}
      </datalist>
      <ul className="flex flex-col gap-4">
        {fields.map((field, index) => {
          const rowErrors = errors.ingredients?.[index];
          return (
            <li key={field.id} className="grid gap-3 rounded-xl border border-border bg-surface p-4 sm:grid-cols-[2fr_1fr_1fr]">
              <div className="flex flex-col gap-1.5 sm:col-span-3">
                <span className="text-sm font-medium">Nguyên liệu {index + 1}</span>
                <Controller
                  control={control}
                  name={`ingredients.${index}.ingredientName`}
                  render={({ field: nameField }) => (
                    <IngredientAutocomplete
                      label={`Tên nguyên liệu ${index + 1}`}
                      name={nameField.value}
                      invalid={!!rowErrors?.ingredientId}
                      // Typing invalidates an earlier pick: the user must choose from the list again.
                      onNameChange={(name) => {
                        nameField.onChange(name);
                        setValue(`ingredients.${index}.ingredientId`, "", { shouldDirty: true });
                      }}
                      onSelect={(ingredient) => {
                        nameField.onChange(ingredient.name);
                        setValue(`ingredients.${index}.ingredientId`, ingredient.id, {
                          shouldDirty: true,
                          shouldValidate: true,
                        });
                        if (!getValues(`ingredients.${index}.unit`) && ingredient.defaultUnit !== "piece") {
                          setValue(`ingredients.${index}.unit`, ingredient.defaultUnit);
                        }
                      }}
                    />
                  )}
                />
                {rowErrors?.ingredientId && (
                  <span role="alert" className="text-xs text-danger">
                    {rowErrors.ingredientId.message}
                  </span>
                )}
              </div>
              <FormField label="Số lượng" error={rowErrors?.quantity?.message}>
                <input
                  {...register(`ingredients.${index}.quantity`)}
                  placeholder="ví dụ 1 1/2"
                  aria-invalid={!!rowErrors?.quantity}
                  className={inputClass}
                />
              </FormField>
              <FormField label="Đơn vị" hint="Để trống = cái" error={rowErrors?.unit?.message}>
                <input {...register(`ingredients.${index}.unit`)} list={UNIT_LIST_ID} className={inputClass} />
              </FormField>
              <FormField label="Ghi chú (không bắt buộc)" error={rowErrors?.note?.message}>
                <input {...register(`ingredients.${index}.note`)} className={inputClass} />
              </FormField>
              <div className="sm:col-span-3">
                <Button variant="danger" aria-label={`Xóa nguyên liệu ${index + 1}`} onClick={() => remove(index)}>
                  Xóa
                </Button>
              </div>
            </li>
          );
        })}
      </ul>
      <Button
        variant="secondary"
        className="self-start"
        onClick={() => append({ ingredientId: "", ingredientName: "", quantity: "", unit: "", note: "" })}
      >
        Thêm nguyên liệu
      </Button>
    </section>
  );
}
