import type { ButtonHTMLAttributes } from "react";

const variants = {
  primary: "bg-accent text-black hover:brightness-110",
  secondary: "border border-border bg-surface-raised text-foreground hover:border-accent",
  danger: "border border-danger/60 text-danger hover:bg-danger/10",
  ghost: "text-muted hover:text-foreground",
} as const;

const sizes = {
  md: "min-h-10 rounded-lg text-sm font-semibold",
  lg: "min-h-13 rounded-xl text-base font-bold",
} as const;

type Variant = keyof typeof variants;
type Size = keyof typeof sizes;

/** Shared with <Link> call sites so links and buttons look identical. */
export function buttonClass(variant: Variant = "primary", size: Size = "md") {
  return `inline-flex items-center justify-center gap-2 px-4 transition disabled:cursor-not-allowed disabled:opacity-50 ${sizes[size]} ${variants[variant]}`;
}

export function Button({
  variant = "primary",
  size = "md",
  className = "",
  type = "button",
  ...props
}: ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant; size?: Size }) {
  return <button type={type} className={`${buttonClass(variant, size)} ${className}`} {...props} />;
}
