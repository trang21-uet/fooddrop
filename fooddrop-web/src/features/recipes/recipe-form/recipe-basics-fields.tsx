"use client";

import type { CSSProperties } from "react";
import { Controller, useFormContext } from "react-hook-form";
import { FormField } from "@/components/ui/form-field";
import type { RecipeFormValues } from "./recipe-form-schema";
import { cardClass, cardHeadingClass, fieldClass, textareaClass } from "./recipe-form-styles";

const DIFFICULTY_LABELS = ["Rất dễ", "Dễ", "Vừa", "Khó", "Rất khó"];
const MAX_SERVINGS = 100;

export function RecipeBasicsFields() {
  const {
    register,
    control,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();

  return (
    <section aria-labelledby="basics-heading" className={cardClass}>
      <h2 id="basics-heading" className={cardHeadingClass}>
        Thông tin chung
      </h2>
      <FormField label="Tên món" error={errors.title?.message}>
        <input
          {...register("title")}
          placeholder="Ví dụ: Bún chả Hà Nội"
          aria-invalid={!!errors.title}
          className={fieldClass()}
        />
      </FormField>
      <FormField label="Mô tả" optional error={errors.description?.message}>
        <textarea {...register("description")} rows={3} className={textareaClass()} />
      </FormField>

      <div className="flex flex-wrap gap-5">
        <Controller
          control={control}
          name="baseServings"
          render={({ field }) => (
            <div className="flex flex-col gap-1.5 text-sm">
              <span id="servings-label" className="font-medium">
                Khẩu phần
              </span>
              <div
                role="group"
                aria-labelledby="servings-label"
                className="flex items-center gap-1 rounded-xl border border-border bg-surface-raised p-1"
              >
                <button
                  type="button"
                  aria-label="Giảm khẩu phần"
                  disabled={field.value <= 1}
                  onClick={() => field.onChange(Math.max(1, field.value - 1))}
                  className="h-10 w-11 rounded-lg text-xl disabled:opacity-35"
                >
                  −
                </button>
                <output aria-live="polite" className="min-w-19 text-center text-[15px] font-semibold">
                  {field.value} người
                </output>
                <button
                  type="button"
                  aria-label="Tăng khẩu phần"
                  disabled={field.value >= MAX_SERVINGS}
                  onClick={() => field.onChange(Math.min(MAX_SERVINGS, field.value + 1))}
                  className="h-10 w-11 rounded-lg text-xl text-accent disabled:opacity-35"
                >
                  +
                </button>
              </div>
              {errors.baseServings && (
                <span role="alert" className="text-xs text-danger">
                  {errors.baseServings.message}
                </span>
              )}
            </div>
          )}
        />
        <div className="w-44">
          <FormField label="Tổng thời gian (phút)" error={errors.totalMinutes?.message}>
            <input
              {...register("totalMinutes", { valueAsNumber: true })}
              type="number"
              min={1}
              inputMode="numeric"
              aria-invalid={!!errors.totalMinutes}
              className={`${fieldClass()} font-mono font-semibold`}
            />
          </FormField>
        </div>
        <Controller
          control={control}
          name="difficulty"
          render={({ field }) => (
            <div className="flex min-w-64 flex-1 flex-col gap-1.5 text-sm">
              <label htmlFor="difficulty-input" className="font-medium">
                Độ khó
              </label>
              <div className="flex min-h-12 items-center gap-5 rounded-xl border border-border bg-surface-raised px-4 py-1">
                <input
                  id="difficulty-input"
                  type="range"
                  min={1}
                  max={5}
                  step={1}
                  value={field.value}
                  aria-valuetext={`${field.value} · ${DIFFICULTY_LABELS[field.value - 1]}`}
                  onChange={(event) => field.onChange(Number(event.target.value))}
                  style={{ "--fill": `${((field.value - 1) / 4) * 100}%` } as CSSProperties}
                  className="range-accent min-w-0 flex-1"
                />
                <output htmlFor="difficulty-input" className="min-w-16 text-right text-[15px] font-semibold">
                  <span className="font-mono text-accent">{field.value}</span> · {DIFFICULTY_LABELS[field.value - 1]}
                </output>
              </div>
              {errors.difficulty && (
                <span role="alert" className="text-xs text-danger">
                  {errors.difficulty.message}
                </span>
              )}
            </div>
          )}
        />
      </div>

      <FormField label="Link nguồn" optional error={errors.sourceUrl?.message}>
        <input
          {...register("sourceUrl")}
          type="url"
          placeholder="https://"
          aria-invalid={!!errors.sourceUrl}
          className={fieldClass()}
        />
      </FormField>
    </section>
  );
}
