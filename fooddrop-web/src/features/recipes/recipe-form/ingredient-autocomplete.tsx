"use client";

import { useId, useState } from "react";
import type { Ingredient } from "../recipe-types";
import { fieldClass } from "./recipe-form-styles";
import { createIngredient, useIngredientSearch } from "./use-ingredient-search";

interface IngredientAutocompleteProps {
  label: string;
  name: string;
  invalid?: boolean;
  onNameChange: (name: string) => void;
  onSelect: (ingredient: Ingredient) => void;
}

/** ARIA combobox over the shared ingredient catalog, with an "add new" escape hatch for missing items. */
export function IngredientAutocomplete({ label, name, invalid, onNameChange, onSelect }: IngredientAutocompleteProps) {
  const listId = useId();
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const search = useIngredientSearch(name);

  const matches = search.data ?? [];
  const trimmed = name.trim();
  const exactMatch = matches.some((item) => item.name.toLowerCase() === trimmed.toLowerCase());
  const canCreate = trimmed.length > 0 && !exactMatch && search.isSuccess;
  const optionCount = matches.length + (canCreate ? 1 : 0);

  const choose = (ingredient: Ingredient) => {
    onSelect(ingredient);
    setOpen(false);
  };

  const addNew = async () => {
    setCreating(true);
    setError(null);
    try {
      choose(await createIngredient(trimmed));
    } catch {
      setError("Không thêm được nguyên liệu này.");
    } finally {
      setCreating(false);
    }
  };

  const activate = (index: number) => {
    const match = matches[index];
    if (match) choose(match);
    else if (canCreate) void addNew();
  };

  const onKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      setOpen(true);
      setActive((index) => Math.min(index + 1, optionCount - 1));
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      setActive((index) => Math.max(index - 1, 0));
    } else if (event.key === "Enter" && open && optionCount > 0) {
      event.preventDefault();
      activate(active);
    } else if (event.key === "Escape") {
      setOpen(false);
    }
  };

  const showList = open && trimmed.length > 0 && optionCount > 0;
  return (
    <div className="relative">
      <input
        role="combobox"
        aria-label={label}
        aria-expanded={showList}
        aria-controls={listId}
        aria-autocomplete="list"
        aria-invalid={invalid}
        autoComplete="off"
        value={name}
        className={fieldClass()}
        placeholder="Tìm nguyên liệu…"
        onChange={(event) => {
          onNameChange(event.target.value);
          setOpen(true);
          setActive(0);
        }}
        onFocus={() => setOpen(true)}
        // Delay so a click on an option lands before the list unmounts.
        onBlur={() => setTimeout(() => setOpen(false), 120)}
        onKeyDown={onKeyDown}
      />
      {showList && (
        <ul
          id={listId}
          role="listbox"
          className="absolute z-10 mt-1.5 max-h-60 w-full overflow-auto rounded-xl border border-accent bg-surface-raised p-1.5 shadow-[0_12px_32px_rgb(0_0_0/0.5)]"
        >
          {matches.map((item, index) => (
            <li
              key={item.id}
              role="option"
              aria-selected={index === active}
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => choose(item)}
              className="flex min-h-11 cursor-pointer items-center rounded-lg px-3 text-[15px] aria-selected:bg-accent/20"
            >
              {item.name}
            </li>
          ))}
          {canCreate && (
            <li
              role="option"
              aria-selected={active === matches.length}
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => void addNew()}
              className="flex min-h-11 cursor-pointer items-center rounded-lg border-t border-border px-3 text-sm font-semibold text-accent aria-selected:bg-accent/20"
            >
              {creating ? "Đang thêm…" : `Thêm “${trimmed}” làm nguyên liệu mới`}
            </li>
          )}
        </ul>
      )}
      {error && (
        <span role="alert" className="text-xs text-danger">
          {error}
        </span>
      )}
    </div>
  );
}
