"use client";

export const MIN_SERVINGS = 1;
export const MAX_SERVINGS = 50;

export function ServingsStepper({
  value,
  onChange,
  label = "Khẩu phần",
}: {
  value: number;
  onChange: (value: number) => void;
  label?: string;
}) {
  const buttonClass = "flex size-9 items-center justify-center rounded-lg border border-border text-lg hover:border-accent disabled:opacity-40";
  return (
    <div role="group" aria-label={label} className="flex items-center gap-3">
      <button type="button" aria-label={`Giảm ${label.toLowerCase()}`} className={buttonClass} disabled={value <= MIN_SERVINGS} onClick={() => onChange(value - 1)}>
        −
      </button>
      <output aria-label={label} className="min-w-8 text-center font-mono text-lg font-bold">
        {value}
      </output>
      <button type="button" aria-label={`Tăng ${label.toLowerCase()}`} className={buttonClass} disabled={value >= MAX_SERVINGS} onClick={() => onChange(value + 1)}>
        +
      </button>
    </div>
  );
}
