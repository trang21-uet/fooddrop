import type { ButtonHTMLAttributes, CSSProperties } from "react";

/** Toggle chip. `color` tints the pressed state (used by rarity chips); defaults to the accent. */
export function Chip({
  pressed,
  color = "var(--accent)",
  className = "",
  ...props
}: ButtonHTMLAttributes<HTMLButtonElement> & { pressed: boolean; color?: string }) {
  const style = { "--chip": color } as CSSProperties;
  return (
    <button
      type="button"
      aria-pressed={pressed}
      style={style}
      className={`min-h-8 rounded-full border px-3 text-xs font-medium transition aria-pressed:border-(--chip) aria-pressed:bg-(--chip)/15 aria-pressed:text-(--chip) border-border text-muted hover:text-foreground ${className}`}
      {...props}
    />
  );
}
