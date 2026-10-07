"use client";

import { useState } from "react";
import { Controller, useFieldArray, useFormContext, useWatch } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { FormField, inputClass } from "@/components/ui/form-field";
import { defaultUnitForRowUnit, ensureIngredient } from "./ensure-ingredient";
import { IngredientAutocomplete } from "./ingredient-autocomplete";
import type { RecipeFormValues } from "./recipe-form-schema";

const UNIT_SUGGESTIONS = ["g", "kg", "ml", "l", "tsp", "tbsp", "cup", "clove", "slice"];
const UNIT_LIST_ID = "ingredient-unit-suggestions";

/** `offerBulkAdd` is for imported drafts, where several names arrive unresolved at once. */
export function RecipeIngredientsField({ offerBulkAdd = false }: { offerBulkAdd?: boolean }) {
  const {
    register,
    control,
    setValue,
    getValues,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const { fields, append, remove } = useFieldArray({ control, name: "ingredients" });
  const [addingAll, setAddingAll] = useState(false);
  const [addAllError, setAddAllError] = useState<string | null>(null);

  // Rows with a name but no catalog pick: typically ingredients an import could not match.
  const rows = useWatch({ control, name: "ingredients" });
  const unresolved = rows.flatMap((row, index) => (!row.ingredientId && row.ingredientName.trim() ? [{ index, row }] : []));

  const addAllToCatalog = async () => {
    setAddingAll(true);
    setAddAllError(null);
    try {
      for (const { index, row } of unresolved) {
        const ingredient = await ensureIngredient(row.ingredientName.trim(), defaultUnitForRowUnit(row.unit));
        setValue(`ingredients.${index}.ingredientId`, ingredient.id, { shouldDirty: true, shouldValidate: true });
        setValue(`ingredients.${index}.ingredientName`, ingredient.name);
      }
    } catch {
      setAddAllError("Không thêm được một số nguyên liệu. Hãy thử lại hoặc chọn từng dòng.");
    } finally {
      setAddingAll(false);
    }
  };

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
      {offerBulkAdd && unresolved.length > 0 && (
        <div className="flex flex-col items-start gap-2 rounded-xl border border-accent/40 bg-accent/5 p-4 text-sm">
          <p>
            {unresolved.length} nguyên liệu chưa có trong danh mục:{" "}
            <span className="font-medium">{unresolved.map(({ row }) => row.ingredientName.trim()).join(", ")}</span>
          </p>
          <Button variant="secondary" disabled={addingAll} onClick={() => void addAllToCatalog()}>
            {addingAll ? "Đang thêm…" : `Thêm ${unresolved.length} nguyên liệu mới vào danh mục`}
          </Button>
          {addAllError && (
            <span role="alert" className="text-xs text-danger">
              {addAllError}
            </span>
          )}
        </div>
      )}
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
