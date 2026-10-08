"use client";

import { useState, type ChangeEvent } from "react";
import { useFormContext, useWatch } from "react-hook-form";
import { uploadImage } from "@/lib/images/upload-image";
import { MAX_STEP_IMAGES, type RecipeFormValues, type StepImage } from "./recipe-form-schema";
import { useUploadActivity } from "./upload-activity";

const ACCEPTED_TYPES = "image/jpeg,image/png,image/webp";

/** Photos for one step: pick one or many, each is uploaded straight to storage and previewed. */
export function StepImagesField({ index }: { index: number }) {
  const { control, getValues, setValue } = useFormContext<RecipeFormValues>();
  const name = `steps.${index}.images` as const;
  const images = useWatch({ control, name });
  const [pending, setPending] = useState(0);
  const [error, setError] = useState<string | null>(null);
  const activity = useUploadActivity();

  const onPick = async (event: ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(event.target.files ?? []);
    event.target.value = "";
    if (files.length === 0) return;
    setError(null);

    const accepted = files.slice(0, Math.max(0, MAX_STEP_IMAGES - getValues(name).length));
    if (accepted.length < files.length) setError(`Mỗi bước tối đa ${MAX_STEP_IMAGES} ảnh.`);
    setPending((count) => count + accepted.length);
    activity.begin(accepted.length);

    const results = await Promise.allSettled(
      accepted.map(async (file): Promise<StepImage> => ({ key: await uploadImage(file, "recipe-step"), url: URL.createObjectURL(file) })),
    );
    const uploaded = results.flatMap((result) => (result.status === "fulfilled" ? [result.value] : []));
    const failed = results.find((result): result is PromiseRejectedResult => result.status === "rejected");
    if (failed) setError(failed.reason instanceof Error ? failed.reason.message : "Không tải được ảnh.");
    // Read the latest list: other uploads may have finished while these were in flight.
    setValue(name, [...getValues(name), ...uploaded], { shouldDirty: true });
    setPending((count) => count - accepted.length);
    activity.end(accepted.length);
  };

  const remove = (position: number) => {
    const removed = getValues(name)[position];
    if (removed?.url?.startsWith("blob:")) URL.revokeObjectURL(removed.url);
    setValue(
      name,
      getValues(name).filter((_, i) => i !== position),
      { shouldDirty: true },
    );
  };

  return (
    <div className="flex flex-col gap-2">
      <span className="text-sm font-medium">Ảnh minh họa (không bắt buộc)</span>
      {images.length > 0 && (
        <ul className="flex flex-wrap gap-2">
          {images.map((image, position) => (
            <li key={image.key} className="relative size-24 overflow-hidden rounded-lg border border-border bg-background">
              {image.url ? (
                // eslint-disable-next-line @next/next/no-img-element -- signed or blob URLs, not optimizable
                <img src={image.url} alt={`Ảnh ${position + 1} của bước ${index + 1}`} className="size-full object-cover" />
              ) : (
                <span className="flex size-full items-center justify-center text-xs text-muted">Ảnh</span>
              )}
              <button
                type="button"
                aria-label={`Xóa ảnh ${position + 1} của bước ${index + 1}`}
                onClick={() => remove(position)}
                className="absolute right-1 top-1 flex size-6 items-center justify-center rounded-full bg-background/90 text-xs font-bold text-danger"
              >
                ✕
              </button>
            </li>
          ))}
        </ul>
      )}
      <label className="flex w-fit cursor-pointer items-center gap-2 rounded-lg border border-border px-3 py-2 text-sm hover:border-accent">
        <span>{pending > 0 ? `Đang tải ${pending} ảnh…` : "Thêm ảnh"}</span>
        <input
          type="file"
          accept={ACCEPTED_TYPES}
          multiple
          disabled={images.length >= MAX_STEP_IMAGES}
          aria-label={`Chọn ảnh cho bước ${index + 1}`}
          onChange={(event) => void onPick(event)}
          className="sr-only"
        />
      </label>
      {error && (
        <span role="alert" className="text-xs text-danger">
          {error}
        </span>
      )}
    </div>
  );
}
