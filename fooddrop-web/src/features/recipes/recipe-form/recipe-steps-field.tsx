"use client";

import { useFieldArray, useFormContext } from "react-hook-form";
import { PlusIcon } from "@/components/ui/icons";
import { EMPTY_STEP, type RecipeFormValues } from "./recipe-form-schema";
import { addRowButtonClass, cardClass, cardHeadingClass } from "./recipe-form-styles";
import { RecipeStepCard } from "./recipe-step-card";

export function RecipeStepsField() {
  const {
    control,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const { fields, append, remove, move } = useFieldArray({ control, name: "steps" });

  return (
    <section aria-labelledby="steps-field-heading" className={cardClass}>
      <h2 id="steps-field-heading" className={cardHeadingClass}>
        Cách làm
      </h2>
      {errors.steps?.root?.message && (
        <p role="alert" className="text-sm text-danger">
          {errors.steps.root.message}
        </p>
      )}
      <ol className="flex flex-col gap-3">
        {fields.map((field, index) => (
          <RecipeStepCard
            key={field.id}
            index={index}
            isLast={index === fields.length - 1}
            canRemove={fields.length > 1}
            onMove={(to) => move(index, to)}
            onRemove={() => remove(index)}
          />
        ))}
      </ol>
      <button type="button" className={addRowButtonClass} onClick={() => append({ ...EMPTY_STEP, images: [] })}>
        <PlusIcon width={16} height={16} />
        Thêm bước
      </button>
    </section>
  );
}
