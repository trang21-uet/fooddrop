import type { ButtonHTMLAttributes } from "react";

/** Toggle chip for tags: filled accent when pressed, raised surface otherwise. */
export function Chip({
  pressed,
  className = "",
  ...props
}: ButtonHTMLAttributes<HTMLButtonElement> & { pressed: boolean }) {
  return (
    <button
      type="button"
      aria-pressed={pressed}
      className={`min-h-9 rounded-full border border-border bg-surface-raised px-3.5 text-[13px] font-semibold text-foreground transition hover:border-accent aria-pressed:border-accent aria-pressed:bg-accent aria-pressed:text-background ${className}`}
      {...props}
    />
  );
}
