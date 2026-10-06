"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";
import type { RecipeFilters } from "./recipe-filters";

const PAGE_SIZE = 20;

export const recipesQueryKey = ["recipes"] as const;

export function useRecipesQuery(filters: RecipeFilters) {
  return useInfiniteQuery({
    queryKey: [...recipesQueryKey, filters],
    initialPageParam: undefined as string | undefined,
    queryFn: async ({ pageParam, signal }) =>
      unwrap(
        await apiClient.GET("/recipes", {
          signal,
          params: {
            query: {
              tags: filters.tagIds.length ? filters.tagIds.join(",") : undefined,
              rarity: filters.rarities.length ? filters.rarities.join(",") : undefined,
              maxMinutes: filters.maxMinutes,
              q: filters.q || undefined,
              cursor: pageParam,
              limit: PAGE_SIZE,
            },
          },
        }),
      ),
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
}
