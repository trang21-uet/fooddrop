"use client";

import Link from "next/link";
import { useEffect, useRef } from "react";
import { buttonClass } from "@/components/ui/button";
import { useSignOutOnUnauthorized } from "@/features/auth/use-sign-out-on-unauthorized";
import { RecipeCard } from "./recipe-card";
import { RecipeFilterBar } from "./recipe-filter-bar";
import { hasActiveFilters } from "./recipe-filters";
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

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between gap-4">
        <h1 className="text-2xl font-bold tracking-tight">Công thức</h1>
        <Link href="/recipes/new" className={buttonClass("primary")}>
          Thêm công thức
        </Link>
      </div>

      {tags.data && <RecipeFilterBar filters={filters} dimensions={tags.data} onChange={setFilters} />}

      {recipes.isPending && <p className="text-muted">Đang tải công thức…</p>}
      {recipes.isError && (
        <p role="alert" className="text-danger">
          Không tải được công thức.{" "}
          <button type="button" onClick={() => void recipes.refetch()} className="underline">
            Thử lại
          </button>
        </p>
      )}
      {recipes.isSuccess && items.length === 0 && (
        <p className="rounded-xl border border-dashed border-border p-8 text-center text-muted">
          {hasActiveFilters(filters) ? "Không có công thức nào phù hợp với bộ lọc." : "Chưa có công thức nào. Hãy thêm công thức đầu tiên!"}
        </p>
      )}

      {items.length > 0 && (
        <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {items.map((recipe) => (
            <li key={recipe.id}>
              <RecipeCard recipe={recipe} />
            </li>
          ))}
        </ul>
      )}
      <div ref={sentinelRef} aria-hidden />
      {isFetchingNextPage && <p className="text-center text-sm text-muted">Đang tải thêm…</p>}
    </div>
  );
}
