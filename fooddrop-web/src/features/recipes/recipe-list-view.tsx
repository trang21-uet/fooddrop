"use client";

import Link from "next/link";
import { useEffect, useRef } from "react";
import { buttonClass } from "@/components/ui/button";
import { CubeIcon } from "@/components/ui/icons";
import { useSignOutOnUnauthorized } from "@/features/auth/use-sign-out-on-unauthorized";
import { RecipeCard } from "./recipe-card";
import { RecipeFilterBar } from "./recipe-filter-bar";
import { EMPTY_FILTERS, hasActiveFilters } from "./recipe-filters";
import { RecipeTagFilters } from "./recipe-tag-filters";
import { useRecipeFilters } from "./use-recipe-filters";
import { useRecipesQuery } from "./use-recipes-query";
import { useTagsQuery } from "./use-tags-query";

export function RecipeListView() {
  const { filters, setFilters } = useRecipeFilters();
  const tags = useTagsQuery();
  const recipes = useRecipesQuery(filters);
  useSignOutOnUnauthorized(recipes.error);
  const { hasNextPage, isFetchingNextPage, fetchNextPage } = recipes;

  // Infinite scroll: fetch the next page when the sentinel below the grid nears the viewport.
  const sentinelRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel || !hasNextPage) return;
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0]?.isIntersecting && !isFetchingNextPage) void fetchNextPage();
      },
      { rootMargin: "400px" },
    );
    observer.observe(sentinel);
    return () => observer.disconnect();
  }, [hasNextPage, isFetchingNextPage, fetchNextPage]);

  const items = recipes.data?.pages.flatMap((page) => page.items) ?? [];
  // The API is cursor-paginated and returns no total, so a "+" marks that more pages exist.
  const countLabel = recipes.isSuccess ? `${items.length}${hasNextPage ? "+" : ""} công thức trong thư viện của bạn` : "Đang tải…";

  return (
    <div className="flex flex-col gap-7">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-4xl leading-none font-extrabold tracking-tighter sm:text-[44px]">Công thức</h1>
          <p className="text-base text-muted">{countLabel}</p>
        </div>
        {/* Gacha page lands in a later phase; mirror the disabled nav item until then. */}
        <span
          aria-disabled="true"
          title="Sắp ra mắt"
          className={`${buttonClass("neon")} min-h-12 cursor-not-allowed opacity-60`}
        >
          <CubeIcon width={20} height={20} className="text-accent" />
          Quay món
        </span>
      </div>

      <RecipeFilterBar filters={filters} onChange={setFilters} />

      <div className="flex flex-col gap-8 lg:flex-row lg:items-start">
        {tags.data && <RecipeTagFilters filters={filters} dimensions={tags.data} onChange={setFilters} />}

        <section aria-label="Kết quả công thức" className="flex min-w-0 flex-1 flex-col gap-6">
          {recipes.isPending && <p className="text-muted">Đang tải công thức…</p>}
          {recipes.isError && (
            <p role="alert" className="text-danger">
              Không tải được công thức.{" "}
              <button type="button" onClick={() => void recipes.refetch()} className="underline">
                Thử lại
              </button>
            </p>
          )}
          {recipes.isSuccess && items.length === 0 && <EmptyState filtered={hasActiveFilters(filters)} onClear={() => setFilters(EMPTY_FILTERS)} />}

          {items.length > 0 && (
            <ul className="grid grid-cols-[repeat(auto-fill,minmax(240px,1fr))] gap-5">
              {items.map((recipe) => (
                <li key={recipe.id}>
                  <RecipeCard recipe={recipe} />
                </li>
              ))}
            </ul>
          )}
          <div ref={sentinelRef} aria-hidden />
          {isFetchingNextPage && <p className="text-center text-sm text-muted">Đang tải thêm…</p>}
        </section>
      </div>
    </div>
  );
}

function EmptyState({ filtered, onClear }: { filtered: boolean; onClear: () => void }) {
  if (!filtered) {
    return (
      <div className="flex flex-col items-center gap-3 rounded-2xl border border-dashed border-border px-6 py-16 text-center">
        <p className="text-lg font-bold">Chưa có công thức nào</p>
        <p className="text-sm text-muted">Hãy thêm công thức đầu tiên!</p>
        <Link href="/recipes/new" className={buttonClass("primary")}>
          Thêm công thức
        </Link>
      </div>
    );
  }
  return (
    <div className="flex flex-col items-center gap-3 rounded-2xl border border-dashed border-border px-6 py-16 text-center">
      <p className="text-lg font-bold">Không có công thức nào phù hợp</p>
      <p className="text-sm text-muted">Thử tăng thời gian hoặc bỏ bớt một thẻ.</p>
      <button type="button" onClick={onClear} className={buttonClass("secondary")}>
        Xóa bộ lọc
      </button>
    </div>
  );
}
