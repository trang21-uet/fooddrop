"use client";

import { useFormContext, useWatch } from "react-hook-form";
import { FormField } from "@/components/ui/form-field";
import { ImageIcon } from "@/components/ui/icons";
import type { RecipeFormValues } from "./recipe-form-schema";
import { cardClass, fieldClass } from "./recipe-form-styles";

const isHttpUrl = (value: string) => /^https?:\/\/\S+$/i.test(value.trim());

/** Recipe photo by URL, with a live preview. */
export function RecipeCoverImageField() {
  const {
    register,
    control,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const imageUrl = useWatch({ control, name: "imageUrl" });

  return (
    <section aria-labelledby="cover-heading" className={cardClass}>
      <h2 id="cover-heading" className="text-base font-bold">
        Ảnh món
      </h2>
      <div className="flex aspect-[16/10] items-center justify-center overflow-hidden rounded-xl border border-dashed border-border bg-surface-raised">
        {isHttpUrl(imageUrl) ? (
          // eslint-disable-next-line @next/next/no-img-element -- arbitrary external URL, not optimizable
          <img src={imageUrl} alt="Xem trước ảnh món" className="size-full object-cover" />
        ) : (
          <ImageIcon width={32} height={32} className="text-muted" />
        )}
      </div>
      <FormField label="Đường dẫn ảnh" optional error={errors.imageUrl?.message}>
        <input
          {...register("imageUrl")}
          type="url"
          placeholder="https://"
          aria-invalid={!!errors.imageUrl}
          className={fieldClass()}
        />
      </FormField>
    </section>
  );
}
