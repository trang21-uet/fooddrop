"use client";

import Link from "next/link";
import { useState } from "react";
import { Button, buttonClass } from "@/components/ui/button";
import { MAX_SERVINGS, MIN_SERVINGS, ServingsStepper } from "../recipes/servings-stepper";
import { groceryItemKey } from "./aggregate-grocery";
import { AISLE_LABELS } from "./aisle-labels";
import { groceryItemLine, groceryShareText } from "./grocery-share-text";
import { useGroceryList } from "./use-grocery-list";
import { useGroceryStore } from "./use-grocery-store";

export function GroceryView() {
  const hydrated = useGroceryStore((state) => state.hydrated);
  const selections = useGroceryStore((state) => state.selections);
  const recipes = useGroceryStore((state) => state.recipes);
  const checked = useGroceryStore((state) => state.checked);
  const { setServings, removeRecipe, toggleChecked, uncheckAll, clearAll } = useGroceryStore.getState();
  const groups = useGroceryList();
  const [shareStatus, setShareStatus] = useState<string | null>(null);

  if (!hydrated) return null;

  const checkedSet = new Set(checked);

  const onShare = async () => {
    const text = groceryShareText(groups, checkedSet);
    try {
      if (navigator.share) await navigator.share({ title: "Danh sách đi chợ", text });
      else {
        await navigator.clipboard.writeText(text);
        setShareStatus("Đã sao chép danh sách.");
      }
    } catch (error) {
      // Dismissing the native share sheet rejects with AbortError; that is not a failure.
      if (!(error instanceof DOMException && error.name === "AbortError")) setShareStatus("Không chia sẻ được. Thử lại nhé.");
    }
  };

  const onClearAll = () => {
    if (window.confirm("Xóa toàn bộ danh sách đi chợ?")) void clearAll();
  };

  return (
    <div className="flex flex-col gap-7">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-4xl leading-none font-extrabold tracking-tighter sm:text-[44px]">Đi chợ</h1>
          <p className="text-base text-muted">Gộp nguyên liệu từ {selections.length} công thức.</p>
        </div>
        {groups.length > 0 && (
          <div className="flex flex-wrap items-center gap-2">
            <Button variant="secondary" onClick={() => void onShare()}>
              Chia sẻ
            </Button>
            <Button variant="ghost" onClick={() => void uncheckAll()} disabled={checked.length === 0}>
              Bỏ chọn hết
            </Button>
            <Button variant="danger" onClick={onClearAll}>
              Xóa danh sách
            </Button>
          </div>
        )}
      </div>
      {shareStatus && (
        <p role="status" className="text-sm text-muted">
          {shareStatus}
        </p>
      )}

      {selections.length === 0 ? (
        <div className="flex flex-col items-start gap-3 rounded-2xl border border-border bg-surface p-6">
          <p className="text-muted">Chưa có món nào. Mở một công thức và chọn “Thêm vào đi chợ”.</p>
          <Link href="/recipes" className={buttonClass("secondary")}>
            Xem công thức
          </Link>
        </div>
      ) : (
        <div className="grid gap-8 md:grid-cols-[1fr_2fr]">
          <section aria-labelledby="grocery-recipes-heading" className="flex flex-col gap-3">
            <h2 id="grocery-recipes-heading" className="text-lg font-semibold">
              Món đã chọn
            </h2>
            <ul className="flex flex-col gap-2">
              {selections.map((selection) => (
                <li key={selection.recipeId} className="flex flex-col gap-2 rounded-xl border border-border bg-surface p-3">
                  <div className="flex items-start justify-between gap-2">
                    <Link href={`/recipes/${selection.recipeId}`} className="font-medium hover:text-accent">
                      {recipes[selection.recipeId]?.title ?? "Công thức"}
                    </Link>
                    <button
                      type="button"
                      className="text-sm text-muted hover:text-danger"
                      aria-label={`Bỏ ${recipes[selection.recipeId]?.title ?? "công thức"} khỏi danh sách`}
                      onClick={() => void removeRecipe(selection.recipeId)}
                    >
                      Bỏ
                    </button>
                  </div>
                  <ServingsStepper
                    value={Math.min(MAX_SERVINGS, Math.max(MIN_SERVINGS, selection.servings))}
                    onChange={(value) => void setServings(selection.recipeId, value)}
                  />
                </li>
              ))}
            </ul>
          </section>

          <section aria-labelledby="grocery-items-heading" className="flex flex-col gap-5">
            <h2 id="grocery-items-heading" className="sr-only">
              Cần mua
            </h2>
            {groups.map((group) => (
              <div key={group.aisle} className="flex flex-col gap-2">
                <h3 className="text-sm font-semibold tracking-wide text-muted uppercase">{AISLE_LABELS[group.aisle]}</h3>
                <ul className="flex flex-col divide-y divide-border rounded-xl border border-border bg-surface">
                  {group.items.map((item) => {
                    const key = groceryItemKey(item);
                    const isChecked = checkedSet.has(key);
                    return (
                      <li key={key}>
                        <label className="flex min-h-11 cursor-pointer items-center gap-3 px-4 py-2.5 text-sm">
                          <input type="checkbox" className="size-4 accent-accent" checked={isChecked} onChange={() => void toggleChecked(key)} />
                          <span className={isChecked ? "text-muted line-through" : ""}>{groceryItemLine(item)}</span>
                        </label>
                      </li>
                    );
                  })}
                </ul>
              </div>
            ))}
          </section>
        </div>
      )}
    </div>
  );
}
