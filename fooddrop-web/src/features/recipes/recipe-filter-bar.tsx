"use client";

import { useEffect, useState, type CSSProperties } from "react";
import { inputClass } from "@/components/ui/form-field";
import { SearchIcon } from "@/components/ui/icons";
import { MAX_MINUTES_OPTIONS, RARITY_ORDER, toggleItem, type RecipeFilters } from "./recipe-filters";
import { RARITY_STYLES } from "./rarity-badge";

const SEARCH_DEBOUNCE_MS = 300;

interface RecipeFilterBarProps {
  filters: RecipeFilters;
  onChange: (filters: RecipeFilters) => void;
}

function RarityPill({
  label,
  color,
  pressed,
  onClick,
}: {
  label: string;
  color: string;
  pressed: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      aria-pressed={pressed}
      onClick={onClick}
      style={{ "--pill": color } as CSSProperties}
      className="flex min-h-11 items-center gap-2 rounded-full border border-border px-4 text-sm font-semibold text-muted transition hover:text-foreground aria-pressed:border-(--pill) aria-pressed:bg-surface-raised aria-pressed:text-foreground"
    >
      <span
        aria-hidden
        className="size-2.5 rounded-full"
        style={{ backgroundColor: color, boxShadow: `0 0 8px ${color}` }}
      />
      {label}
    </button>
  );
}

/** Search, max-time and rarity controls. Tag filters live in `RecipeTagFilters`. */
export function RecipeFilterBar({ filters, onChange }: RecipeFilterBarProps) {
  const [search, setSearch] = useState(filters.q);

  // Pick up external changes (back button, "Xóa bộ lọc") without fighting the user's typing.
  useEffect(() => setSearch(filters.q), [filters.q]);

  useEffect(() => {
    if (search.trim() === filters.q) return;
    const timer = setTimeout(() => onChange({ ...filters, q: search.trim() }), SEARCH_DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [search, filters, onChange]);

  return (
    <section aria-label="Lọc công thức" className="flex flex-col gap-4">
      <div className="flex flex-wrap gap-3">
        <label className="relative block flex-[1_1_280px]">
          <span className="sr-only">Tìm công thức</span>
          <SearchIcon className="pointer-events-none absolute top-3.5 left-4 text-muted" />
          <input
            type="search"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Tìm công thức…"
            className={`${inputClass} h-12 rounded-xl bg-surface pr-4 pl-11 text-[15px]`}
          />
        </label>
        <label className="flex h-12 items-center gap-2.5 rounded-xl border border-border bg-surface px-4 text-sm text-muted">
          Thời gian tối đa
          <select
            value={filters.maxMinutes ?? ""}
            onChange={(event) => onChange({ ...filters, maxMinutes: Number(event.target.value) || undefined })}
            className="h-9 rounded-lg bg-surface-raised px-2.5 text-sm font-semibold text-foreground"
          >
            <option value="">Bất kỳ</option>
            {MAX_MINUTES_OPTIONS.map(({ minutes, label }) => (
              <option key={minutes} value={minutes}>
                {label}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div role="group" aria-label="Lọc theo độ hiếm" className="flex flex-wrap gap-2">
        <RarityPill
          label="Tất cả"
          color="var(--accent)"
          pressed={filters.rarities.length === 0}
          onClick={() => onChange({ ...filters, rarities: [] })}
        />
        {RARITY_ORDER.map((rarity) => (
          <RarityPill
            key={rarity}
            label={RARITY_STYLES[rarity].label}
            color={RARITY_STYLES[rarity].color}
            pressed={filters.rarities.includes(rarity)}
            onClick={() => onChange({ ...filters, rarities: toggleItem(filters.rarities, rarity) })}
          />
        ))}
      </div>
    </section>
  );
}
