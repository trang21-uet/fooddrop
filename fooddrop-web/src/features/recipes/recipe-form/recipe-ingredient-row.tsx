"use client";

import type { ReactNode } from "react";
import { Controller, useFormContext } from "react-hook-form";
import { TrashIcon } from "@/components/ui/icons";
import type { Unit } from "../recipe-types";
import { IngredientAutocomplete } from "./ingredient-autocomplete";
import type { RecipeFormValues } from "./recipe-form-schema";
import { fieldClass, rowIconButtonClass } from "./recipe-form-styles";

/**
 * Column captions show above the first row only (design), but on every row on narrow screens where
 * the columns wrap. Inputs carry their own row-numbered aria-label, so hiding a caption never hides a name.
 */
function Column({ first, caption, className, children }: { first: boolean; caption: string; className: string; children: ReactNode }) {
  return (
    <div className={`flex min-w-0 flex-col gap-1.5 ${className}`}>
      <span aria-hidden className={`text-[13px] font-semibold ${first ? "" : "sm:hidden"}`}>
        {caption}
      </span>
      {children}
    </div>
  );
}

export function RecipeIngredientRow({ index, units, onRemove }: { index: number; units: Unit[]; onRemove: () => void }) {
  const {
    register,
    control,
    setValue,
    getValues,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const rowErrors = errors.ingredients?.[index];
  const first = index === 0;
  const n = index + 1;

  return (
    <li className="flex flex-wrap items-start gap-2">
      <Column first={first} caption="Tên nguyên liệu" className="flex-[1_1_220px]">
        <Controller
          control={control}
          name={`ingredients.${index}.ingredientName`}
          render={({ field: nameField }) => (
            <IngredientAutocomplete
              label={`Tên nguyên liệu ${n}`}
              name={nameField.value}
              invalid={!!rowErrors?.ingredientId}
              // Typing invalidates an earlier pick: the user must choose from the list again.
              onNameChange={(name) => {
                nameField.onChange(name);
                setValue(`ingredients.${index}.ingredientId`, "", { shouldDirty: true });
              }}
              onSelect={(ingredient) => {
                nameField.onChange(ingredient.name);
                setValue(`ingredients.${index}.ingredientId`, ingredient.id, { shouldDirty: true, shouldValidate: true });
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
      </Column>
      <Column first={first} caption="Số lượng" className="w-24">
        <input
          {...register(`ingredients.${index}.quantity`)}
          aria-label={`Số lượng ${n}`}
          placeholder="1 1/2"
          aria-invalid={!!rowErrors?.quantity}
          className={`${fieldClass()} px-3 text-right font-mono font-semibold text-accent`}
        />
      </Column>
      <Column first={first} caption="Đơn vị" className="w-32">
        {/* Controlled, so a saved unit is selected once the catalog finishes loading. A unit is only saved with a quantity. */}
        <Controller
          control={control}
          name={`ingredients.${index}.unit`}
          render={({ field: unitField }) => (
            <select {...unitField} aria-label={`Đơn vị ${n}`} className={`${fieldClass()} px-3`}>
              <option value="">Không có</option>
              {/* Catalog still loading (or failed): keep a saved unit visible instead of showing "Không có". */}
              {unitField.value && !units.some((unit) => unit.code === unitField.value) && (
                <option value={unitField.value}>{unitField.value}</option>
              )}
              {units.map((unit) => (
                <option key={unit.code} value={unit.code}>
                  {unit.nameVi}
                </option>
              ))}
            </select>
          )}
        />
      </Column>
      <Column first={first} caption="Ghi chú" className="flex-[1_1_160px]">
        <input
          {...register(`ingredients.${index}.note`)}
          aria-label={`Ghi chú nguyên liệu ${n}`}
          placeholder="thái mỏng"
          className={fieldClass()}
        />
      </Column>
      <button
        type="button"
        aria-label={`Xóa nguyên liệu ${n}`}
        onClick={onRemove}
        className={`${rowIconButtonClass} mt-[26px] text-danger ${first ? "" : "sm:mt-0"}`}
      >
        <TrashIcon />
      </button>
    </li>
  );
}
