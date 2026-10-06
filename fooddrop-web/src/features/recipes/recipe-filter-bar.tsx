"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { inputClass } from "@/components/ui/form-field";
import { Chip } from "@/components/ui/chip";
import { MAX_MINUTES_OPTIONS, RARITY_ORDER, hasActiveFilters, toggleItem, type RecipeFilters } from "./recipe-filters";
import { RARITY_STYLES } from "./rarity-badge";
import type { TagDimension } from "./recipe-types";

const SEARCH_DEBOUNCE_MS = 300;
const CHIPS_ID = "recipe-filter-chips";

interface RecipeFilterBarProps {
  filters: RecipeFilters;
  dimensions: TagDimension[];
  onChange: (filters: RecipeFilters) => void;
}

function FilterGroup({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <fieldset className="flex flex-wrap items-center gap-2">
      <legend className="sr-only">{label}</legend>
      <span aria-hidden className="w-20 shrink-0 text-xs font-semibold uppercase tracking-wide text-muted">
        {label}
      </span>
      {children}
    </fieldset>
  );
}

export function RecipeFilterBar({ filters, dimensions, onChange }: RecipeFilterBarProps) {
  const [search, setSearch] = useState(filters.q);
  // Chips are always visible from md up; on phones they collapse so results stay near the top.
  const [expanded, setExpanded] = useState(false);
  const activeCount = filters.tagIds.length + filters.rarities.length + (filters.maxMinutes ? 1 : 0);

  // Pick up external changes (back button, "Xóa bộ lọc") without fighting the user's typing.
  useEffect(() => setSearch(filters.q), [filters.q]);

  useEffect(() => {
    if (search.trim() === filters.q) return;
    const timer = setTimeout(() => onChange({ ...filters, q: search.trim() }), SEARCH_DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [search, filters, onChange]);

  return (
    <section aria-label="Lọc công thức" className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
      <div className="flex gap-2">
        <input
          type="search"
          value={search}
          onChange={(event) => setSearch(event.target.value)}
          placeholder="Tìm công thức…"
          aria-label="Tìm công thức"
          className={inputClass}
        />
        <Button
          variant="secondary"
          aria-expanded={expanded}
          aria-controls={CHIPS_ID}
          onClick={() => setExpanded((value) => !value)}
          className="shrink-0 md:hidden"
        >
          Bộ lọc{activeCount > 0 ? ` (${activeCount})` : ""}
        </Button>
      </div>

      <div id={CHIPS_ID} className={`${expanded ? "flex" : "hidden"} flex-col gap-3 md:flex`}>
        {dimensions.map((dimension) => (
          <FilterGroup key={dimension.id} label={dimension.label}>
            {dimension.tags.map((tag) => (
              <Chip
                key={tag.id}
                pressed={filters.tagIds.includes(tag.id)}
                onClick={() => onChange({ ...filters, tagIds: toggleItem(filters.tagIds, tag.id) })}
              >
                {tag.label}
              </Chip>
            ))}
          </FilterGroup>
        ))}

        <FilterGroup label="Độ hiếm">
          {RARITY_ORDER.map((rarity) => (
            <Chip
              key={rarity}
              color={RARITY_STYLES[rarity].color}
              pressed={filters.rarities.includes(rarity)}
              onClick={() => onChange({ ...filters, rarities: toggleItem(filters.rarities, rarity) })}
            >
              {RARITY_STYLES[rarity].label}
            </Chip>
          ))}
        </FilterGroup>

        <FilterGroup label="Thời gian">
          {MAX_MINUTES_OPTIONS.map((minutes) => (
            <Chip
              key={minutes}
              pressed={filters.maxMinutes === minutes}
              onClick={() => onChange({ ...filters, maxMinutes: filters.maxMinutes === minutes ? undefined : minutes })}
            >
              ≤ {minutes} phút
            </Chip>
          ))}
        </FilterGroup>

        {hasActiveFilters(filters) && (
          <button
            type="button"
            onClick={() => onChange({ tagIds: [], rarities: [], q: "" })}
            className="self-start text-sm text-accent underline-offset-4 hover:underline"
          >
            Xóa bộ lọc
          </button>
        )}
      </div>
    </section>
  );
}
