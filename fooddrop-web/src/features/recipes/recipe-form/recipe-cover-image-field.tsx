"use client";

import { useState, type ChangeEvent } from "react";
import { useFormContext, useWatch } from "react-hook-form";
import { FormField } from "@/components/ui/form-field";
import { CloseIcon, ImageIcon } from "@/components/ui/icons";
import { uploadImage } from "@/lib/images/upload-image";
import type { RecipeFormValues } from "./recipe-form-schema";
import { cardClass, fieldClass } from "./recipe-form-styles";
import { useUploadActivity } from "./upload-activity";

const ACCEPTED_TYPES = "image/jpeg,image/png,image/webp";
const isHttpUrl = (value: string) => /^https?:\/\/\S+$/i.test(value.trim());

/** Recipe photo: uploaded from the device, or linked by URL. An upload replaces the URL. */
export function RecipeCoverImageField() {
  const {
    register,
    control,
    getValues,
    setValue,
    formState: { errors },
  } = useFormContext<RecipeFormValues>();
  const imageUrl = useWatch({ control, name: "imageUrl" });
  const coverImage = useWatch({ control, name: "coverImage" });
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const activity = useUploadActivity();

  const replaceCover = (next: RecipeFormValues["coverImage"]) => {
    const previous = getValues("coverImage");
    if (previous?.url?.startsWith("blob:")) URL.revokeObjectURL(previous.url);
    setValue("coverImage", next, { shouldDirty: true });
  };

  const onPick = async (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = "";
    if (!file) return;
    setError(null);
    setUploading(true);
    activity.begin(1);
    try {
      const key = await uploadImage(file, "recipe-cover");
      replaceCover({ key, url: URL.createObjectURL(file) });
    } catch (failure) {
      setError(failure instanceof Error ? failure.message : "Không tải được ảnh.");
    } finally {
      setUploading(false);
      activity.end(1);
    }
  };

  const preview = coverImage ? coverImage.url : isHttpUrl(imageUrl) ? imageUrl : null;

  return (
    <section aria-labelledby="cover-heading" className={cardClass}>
      <h2 id="cover-heading" className="text-base font-bold">
        Ảnh món
      </h2>
      <div className="relative flex aspect-[16/10] items-center justify-center overflow-hidden rounded-xl border border-dashed border-border bg-surface-raised">
        {preview ? (
          // eslint-disable-next-line @next/next/no-img-element -- external, signed or blob URLs, not optimizable
          <img src={preview} alt="Xem trước ảnh món" className="size-full object-cover" />
        ) : (
          <ImageIcon width={32} height={32} className="text-muted" />
        )}
        {coverImage && (
          <button
            type="button"
            aria-label="Xóa ảnh đã tải lên"
            onClick={() => replaceCover(null)}
            className="absolute right-2 top-2 flex size-9 items-center justify-center rounded-full border border-border bg-background text-foreground hover:border-danger hover:text-danger"
          >
            <CloseIcon width={14} height={14} />
          </button>
        )}
      </div>
      <label className="flex cursor-pointer items-center justify-center rounded-xl border border-dashed border-accent px-4 py-2.5 text-sm font-bold text-accent transition hover:bg-accent/10 has-[:disabled]:cursor-not-allowed has-[:disabled]:opacity-40 has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-accent">
        {uploading ? "Đang tải ảnh…" : coverImage ? "Đổi ảnh khác" : "Tải ảnh từ máy"}
        <input
          type="file"
          accept={ACCEPTED_TYPES}
          disabled={uploading}
          aria-label="Chọn ảnh món từ máy"
          onChange={(event) => void onPick(event)}
          className="sr-only"
        />
      </label>
      {error && (
        <span role="alert" className="text-xs text-danger">
          {error}
        </span>
      )}
      {!coverImage && (
        <FormField label="Hoặc dán đường dẫn ảnh" optional error={errors.imageUrl?.message}>
          <input
            {...register("imageUrl")}
            type="url"
            placeholder="https://"
            aria-invalid={!!errors.imageUrl}
            className={fieldClass()}
          />
        </FormField>
      )}
    </section>
  );
}
