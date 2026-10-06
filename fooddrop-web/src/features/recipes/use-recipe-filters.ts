"use client";

import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useCallback, useMemo } from "react";
import { filtersToSearchParams, parseFilters, type RecipeFilters } from "./recipe-filters";

/** Filter state lives in the URL so filtered views are shareable and survive the back button. */
export function useRecipeFilters() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const queryString = searchParams.toString();
  const filters = useMemo(() => parseFilters(new URLSearchParams(queryString)), [queryString]);

  const setFilters = useCallback(
    (next: RecipeFilters) => {
      const query = filtersToSearchParams(next).toString();
      // replace, not push: every chip click would otherwise add a history entry.
      router.replace(query ? `${pathname}?${query}` : pathname, { scroll: false });
    },
    [router, pathname],
  );

  return { filters, setFilters };
}
