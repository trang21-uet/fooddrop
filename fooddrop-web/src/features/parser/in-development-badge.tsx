/** Marks the AI recipe import as unfinished (live model checks and accuracy eval are still pending). */
export function InDevelopmentBadge() {
  return (
    <span className="rounded-full border border-accent/60 px-2 py-0.5 text-[11px] font-semibold leading-none text-accent">
      Đang phát triển
    </span>
  );
}
