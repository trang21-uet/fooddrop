"use client";

import { useState } from "react";
import { useFormContext } from "react-hook-form";
import { FormField } from "@/components/ui/form-field";
import { ChevronDownIcon, ChevronUpIcon, StopwatchIcon, TrashIcon } from "@/components/ui/icons";
import type { RecipeFormValues } from "./recipe-form-schema";
import { fieldClass, iconButtonClass, textareaClass } from "./recipe-form-styles";
import { StepImagesField } from "./step-images-field";

const DEFAULT_TIMER_MINUTES = 10;

interface RecipeStepCardProps {
  index: number;
  isLast: boolean;
  canRemove: boolean;
  onMove: (to: number) => void;
  onRemove: () => void;
}

/** One step: name, instructions, an optional note, photos and an optional timer. */
export function RecipeStepCard({ index, isLast, canRemove, onMove, onRemove }: RecipeStepCardProps) {
  const {
    register,
    getValues,
    setValue,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const stepErrors = errors.steps?.[index];
  const n = index + 1;
  // Local, so clearing the minutes while typing does not hide the input.
  const [timerOn, setTimerOn] = useState(() => getValues(`steps.${index}.timerMinutes`) != null);

  const toggleTimer = () => {
    setValue(`steps.${index}.timerMinutes`, timerOn ? undefined : DEFAULT_TIMER_MINUTES, { shouldDirty: true });
    setTimerOn(!timerOn);
  };

  return (
    <li className="flex gap-3.5 rounded-2xl border border-border bg-surface-raised p-4">
      <span
        aria-hidden
        className="flex size-8.5 shrink-0 items-center justify-center rounded-full border border-accent font-mono text-sm font-semibold text-accent"
      >
        {n}
      </span>
      <div className="flex min-w-0 flex-1 flex-col gap-3">
        <FormField label="Tên bước" optional error={stepErrors?.name?.message}>
          <input
            {...register(`steps.${index}.name`)}
            aria-label={`Tên bước ${n}`}
            placeholder="Ví dụ: Ướp thịt"
            className={fieldClass("surface")}
          />
        </FormField>
        <FormField label="Nội dung" error={stepErrors?.text?.message}>
          <textarea
            {...register(`steps.${index}.text`)}
            aria-label={`Nội dung bước ${n}`}
            rows={3}
            placeholder="Mô tả bước này"
            aria-invalid={!!stepErrors?.text}
            className={textareaClass("surface")}
          />
        </FormField>
        <FormField label="Lưu ý" optional error={stepErrors?.note?.message}>
          <textarea
            {...register(`steps.${index}.note`)}
            aria-label={`Lưu ý bước ${n}`}
            rows={2}
            placeholder="Mẹo hoặc điều cần tránh ở bước này"
            aria-invalid={!!stepErrors?.note}
            className={`${textareaClass("surface")} text-sm`}
          />
        </FormField>
        <StepImagesField index={index} />

        <div className="flex flex-wrap items-center gap-2.5">
          <button
            type="button"
            aria-pressed={timerOn}
            onClick={toggleTimer}
            className="flex min-h-11 items-center gap-2 rounded-xl border border-border px-3.5 text-sm font-semibold transition hover:border-accent aria-pressed:border-accent aria-pressed:bg-accent aria-pressed:text-background"
          >
            <StopwatchIcon width={16} height={16} />
            {timerOn ? "Có hẹn giờ" : "Thêm hẹn giờ"}
          </button>
          {timerOn && (
            <label className="flex h-11 items-center gap-2 rounded-xl border border-border bg-surface px-3 text-sm text-muted">
              <input
                {...register(`steps.${index}.timerMinutes`, {
                  setValueAs: (value) => (value === "" || value == null ? undefined : Number(value)),
                })}
                type="number"
                min={1}
                inputMode="numeric"
                aria-label={`Số phút hẹn giờ bước ${n}`}
                aria-invalid={!!stepErrors?.timerMinutes}
                className="w-14 bg-transparent font-mono text-[15px] font-semibold text-accent"
              />
              phút
            </label>
          )}
          <span className="flex-1" />
          <button
            type="button"
            aria-label={`Chuyển bước ${n} lên`}
            disabled={index === 0}
            onClick={() => onMove(index - 1)}
            className={iconButtonClass}
          >
            <ChevronUpIcon />
          </button>
          <button
            type="button"
            aria-label={`Chuyển bước ${n} xuống`}
            disabled={isLast}
            onClick={() => onMove(index + 1)}
            className={iconButtonClass}
          >
            <ChevronDownIcon />
          </button>
          <button
            type="button"
            aria-label={`Xóa bước ${n}`}
            disabled={!canRemove}
            onClick={onRemove}
            className={`${iconButtonClass} text-danger`}
          >
            <TrashIcon />
          </button>
        </div>
        {stepErrors?.timerMinutes && (
          <span role="alert" className="text-xs text-danger">
            {stepErrors.timerMinutes.message}
          </span>
        )}
      </div>
    </li>
  );
}
