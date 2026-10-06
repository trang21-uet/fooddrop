"use client";

import { useFormContext } from "react-hook-form";
import { FormField, inputClass } from "@/components/ui/form-field";
import type { RecipeFormValues } from "./recipe-form-schema";

export function RecipeBasicsFields() {
  const {
    register,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();

  return (
    <section aria-labelledby="basics-heading" className="flex flex-col gap-4">
      <h2 id="basics-heading" className="text-lg font-semibold">
        Thông tin chung
      </h2>
      <FormField label="Tiêu đề" error={errors.title?.message}>
        <input {...register("title")} aria-invalid={!!errors.title} className={inputClass} />
      </FormField>
      <FormField label="Mô tả" error={errors.description?.message}>
        <textarea {...register("description")} rows={3} className={inputClass} />
      </FormField>
      <div className="grid gap-4 sm:grid-cols-3">
        <FormField label="Khẩu phần" error={errors.baseServings?.message}>
          <input
            {...register("baseServings", { valueAsNumber: true })}
            type="number"
            min={1}
            inputMode="numeric"
            aria-invalid={!!errors.baseServings}
            className={inputClass}
          />
        </FormField>
        <FormField label="Tổng số phút" error={errors.totalMinutes?.message}>
          <input
            {...register("totalMinutes", { valueAsNumber: true })}
            type="number"
            min={1}
            inputMode="numeric"
            aria-invalid={!!errors.totalMinutes}
            className={inputClass}
          />
        </FormField>
        <FormField label="Độ khó" error={errors.difficulty?.message}>
          <select {...register("difficulty", { valueAsNumber: true })} className={inputClass}>
            {[1, 2, 3, 4, 5].map((level) => (
              <option key={level} value={level}>
                {level} / 5
              </option>
            ))}
          </select>
        </FormField>
      </div>
      <FormField label="Đường dẫn ảnh (không bắt buộc)" error={errors.imageUrl?.message}>
        <input {...register("imageUrl")} type="url" aria-invalid={!!errors.imageUrl} className={inputClass} />
      </FormField>
      <FormField label="Đường dẫn nguồn (không bắt buộc)" error={errors.sourceUrl?.message}>
        <input {...register("sourceUrl")} type="url" aria-invalid={!!errors.sourceUrl} className={inputClass} />
      </FormField>
    </section>
  );
}
