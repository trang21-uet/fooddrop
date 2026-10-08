"use client";

import { useFieldArray, useFormContext } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { FormField, inputClass } from "@/components/ui/form-field";
import type { RecipeFormValues } from "./recipe-form-schema";
import { StepImagesField } from "./step-images-field";

export function RecipeStepsField() {
  const {
    register,
    control,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const { fields, append, remove, move } = useFieldArray({ control, name: "steps" });

  return (
    <section aria-labelledby="steps-field-heading" className="flex flex-col gap-4">
      <h2 id="steps-field-heading" className="text-lg font-semibold">
        Các bước
      </h2>
      {errors.steps?.root?.message && (
        <p role="alert" className="text-sm text-danger">
          {errors.steps.root.message}
        </p>
      )}
      <ol className="flex flex-col gap-4">
        {fields.map((field, index) => (
          <li key={field.id} className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
            <FormField label={`Tên bước ${index + 1} (không bắt buộc)`} error={errors.steps?.[index]?.name?.message}>
              <input {...register(`steps.${index}.name`)} placeholder="ví dụ: Sơ chế" className={inputClass} />
            </FormField>
            <FormField label={`Nội dung bước ${index + 1}`} error={errors.steps?.[index]?.text?.message}>
              <textarea
                {...register(`steps.${index}.text`)}
                rows={3}
                aria-invalid={!!errors.steps?.[index]?.text}
                className={inputClass}
              />
            </FormField>
            <StepImagesField index={index} />
            <div className="flex flex-wrap items-end gap-3">
              <div className="w-40">
                <FormField label="Hẹn giờ (phút, không bắt buộc)" error={errors.steps?.[index]?.timerMinutes?.message}>
                  <input
                    {...register(`steps.${index}.timerMinutes`, {
                      setValueAs: (value) => (value === "" || value == null ? undefined : Number(value)),
                    })}
                    type="number"
                    min={1}
                    inputMode="numeric"
                    className={inputClass}
                  />
                </FormField>
              </div>
              <div className="ml-auto flex gap-2">
                <Button
                  variant="ghost"
                  aria-label={`Chuyển bước ${index + 1} lên`}
                  disabled={index === 0}
                  onClick={() => move(index, index - 1)}
                >
                  ↑
                </Button>
                <Button
                  variant="ghost"
                  aria-label={`Chuyển bước ${index + 1} xuống`}
                  disabled={index === fields.length - 1}
                  onClick={() => move(index, index + 1)}
                >
                  ↓
                </Button>
                <Button
                  variant="danger"
                  aria-label={`Xóa bước ${index + 1}`}
                  disabled={fields.length === 1}
                  onClick={() => remove(index)}
                >
                  Xóa
                </Button>
              </div>
            </div>
          </li>
        ))}
      </ol>
      <Button variant="secondary" className="self-start" onClick={() => append({ name: "", text: "", images: [] })}>
        Thêm bước
      </Button>
    </section>
  );
}
