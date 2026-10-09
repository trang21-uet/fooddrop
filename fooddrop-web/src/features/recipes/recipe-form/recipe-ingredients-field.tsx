"use client";

import { useState } from "react";
import { useFieldArray, useFormContext, useWatch } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { PlusIcon } from "@/components/ui/icons";
import { defaultUnitForRowUnit, ensureIngredient } from "./ensure-ingredient";
import { useUnitsQuery } from "../use-units-query";
import type { RecipeFormValues } from "./recipe-form-schema";
import { addRowButtonClass, cardClass, cardHeadingClass } from "./recipe-form-styles";
import { RecipeIngredientRow } from "./recipe-ingredient-row";

/** `offerBulkAdd` is for imported drafts, where several names arrive unresolved at once. */
export function RecipeIngredientsField({ offerBulkAdd = false }: { offerBulkAdd?: boolean }) {
  const { control, setValue } = useFormContext<RecipeFormValues>();
  const { fields, append, remove } = useFieldArray({ control, name: "ingredients" });
  const units = useUnitsQuery().data ?? [];
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
        const ingredient = await ensureIngredient(row.ingredientName.trim(), defaultUnitForRowUnit(row.unit, units));
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
    <section aria-labelledby="ingredients-field-heading" className={cardClass}>
      <h2 id="ingredients-field-heading" className={cardHeadingClass}>
        Nguyên liệu
      </h2>
      {fields.length > 0 && (
        <ul className="flex flex-col gap-3">
          {fields.map((field, index) => (
            <RecipeIngredientRow key={field.id} index={index} units={units} onRemove={() => remove(index)} />
          ))}
        </ul>
      )}
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
      <button
        type="button"
        className={addRowButtonClass}
        onClick={() => append({ ingredientId: "", ingredientName: "", quantity: "", unit: "", note: "" })}
      >
        <PlusIcon width={16} height={16} />
        Thêm nguyên liệu
      </button>
    </section>
  );
}
