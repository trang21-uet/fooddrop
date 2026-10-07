"use client";

import { useState } from "react";
import { Chip } from "@/components/ui/chip";
import { EMPTY_FILTERS, toggleItem, type RecipeFilters } from "./recipe-filters";
import type { TagDimension } from "./recipe-types";

const CHIPS_ID = "recipe-tag-filter-chips";

interface RecipeTagFiltersProps {
  filters: RecipeFilters;
  dimensions: TagDimension[];
  onChange: (filters: RecipeFilters) => void;
}

/** Sidebar of tag chips grouped by dimension. Collapsible below `lg` so results stay near the top on phones. */
export function RecipeTagFilters({ filters, dimensions, onChange }: RecipeTagFiltersProps) {
  const [expanded, setExpanded] = useState(false);

  return (
    <aside
      aria-label="Lọc theo thẻ"
      className="flex flex-col gap-5 rounded-2xl border border-border bg-surface p-5 lg:w-70 lg:shrink-0"
    >
      <div className="flex items-center justify-between">
        <h2 className="text-[15px] font-bold">
          Thẻ{filters.tagIds.length > 0 ? ` (${filters.tagIds.length})` : ""}
        </h2>
        <div className="flex items-center">
          <button
            type="button"
            onClick={() => onChange(EMPTY_FILTERS)}
            className="min-h-11 px-2 text-[13px] font-semibold text-accent"
          >
            Xóa tất cả
          </button>
          <button
            type="button"
            aria-expanded={expanded}
            aria-controls={CHIPS_ID}
            onClick={() => setExpanded((value) => !value)}
            className="min-h-11 px-2 text-[13px] font-semibold text-muted lg:hidden"
          >
            {expanded ? "Thu gọn" : "Mở rộng"}
          </button>
        </div>
      </div>

      <div id={CHIPS_ID} className={`${expanded ? "flex" : "hidden"} flex-col gap-5 lg:flex`}>
        {dimensions.map((dimension) => (
          <fieldset key={dimension.id} className="flex flex-col gap-2.5">
            <legend className="sr-only">{dimension.label}</legend>
            <span aria-hidden className="text-xs font-semibold tracking-widest text-muted uppercase">
              {dimension.label}
            </span>
            <div className="flex flex-wrap gap-2">
              {dimension.tags.map((tag) => (
                <Chip
                  key={tag.id}
                  pressed={filters.tagIds.includes(tag.id)}
                  onClick={() => onChange({ ...filters, tagIds: toggleItem(filters.tagIds, tag.id) })}
                >
                  {tag.label}
                </Chip>
              ))}
            </div>
          </fieldset>
        ))}
      </div>
    </aside>
  );
}
