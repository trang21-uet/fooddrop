/** Shared class names for the recipe form, matching the Web-Recipe-Form design board. */

/** A form section: surface card with a heading. */
export const cardClass = "flex flex-col gap-5 rounded-2xl border border-border bg-surface p-5 sm:p-6";

export const cardHeadingClass = "text-xl font-bold";

/** 48px text input. `raised` sits on a surface card; `surface` sits on a raised card (a step). */
export function fieldClass(on: "raised" | "surface" = "raised") {
  const background = on === "raised" ? "bg-surface-raised" : "bg-surface";
  return `min-h-12 w-full rounded-xl border border-border ${background} px-4 text-[15px] text-foreground placeholder:text-muted focus:border-accent aria-[invalid=true]:border-danger`;
}

export function textareaClass(on: "raised" | "surface" = "raised") {
  return `${fieldClass(on)} resize-y py-3 leading-relaxed`;
}

/** Dashed accent button for "add another row". */
export const addRowButtonClass =
  "flex min-h-11 items-center gap-2 self-start rounded-xl border border-dashed border-accent px-4 text-sm font-bold text-accent transition hover:bg-accent/10";

const iconButtonBase =
  "flex shrink-0 items-center justify-center rounded-xl border border-border text-foreground transition hover:border-accent disabled:cursor-not-allowed disabled:opacity-35 disabled:hover:border-border";

/** Square 44px icon button (move, delete a step). */
export const iconButtonClass = `${iconButtonBase} size-11`;

/** Square 48px icon button, level with a 48px input in the same row. */
export const rowIconButtonClass = `${iconButtonBase} size-12`;
