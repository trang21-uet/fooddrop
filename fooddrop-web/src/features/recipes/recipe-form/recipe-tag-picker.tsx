"use client";

import { useFormContext, useWatch } from "react-hook-form";
import { Chip } from "@/components/ui/chip";
import { toggleItem } from "../recipe-filters";
import { useTagsQuery } from "../use-tags-query";
import type { RecipeFormValues } from "./recipe-form-schema";
import { cardClass } from "./recipe-form-styles";

export function RecipeTagPicker() {
  const { control, setValue } = useFormContext<RecipeFormValues>();
  const selected = useWatch({ control, name: "tagIds" });
  const tags = useTagsQuery();

  return (
    <section aria-labelledby="tags-heading" className={cardClass}>
      <h2 id="tags-heading" className="text-base font-bold">
        Thẻ
      </h2>
      {tags.isPending && <p className="text-sm text-muted">Đang tải thẻ…</p>}
      {tags.isError && (
        <p role="alert" className="text-sm text-danger">
          Không tải được thẻ.
        </p>
      )}
      {tags.data?.map((dimension) => (
        <fieldset key={dimension.id} className="flex flex-wrap items-center gap-2">
          <legend className="mb-2.5 text-xs font-semibold uppercase tracking-[0.08em] text-muted">{dimension.label}</legend>
          {dimension.tags.map((tag) => (
            <Chip
              key={tag.id}
              pressed={selected.includes(tag.id)}
              onClick={() => setValue("tagIds", toggleItem(selected, tag.id), { shouldDirty: true })}
            >
              {tag.label}
            </Chip>
          ))}
        </fieldset>
      ))}
    </section>
  );
}
