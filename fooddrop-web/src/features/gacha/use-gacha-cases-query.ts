"use client";

import { useQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";

/** Every case with its count, rarity mix and rarest dishes, as the backend groups the user's recipes. */
export function useGachaCasesQuery() {
  return useQuery({
    queryKey: ["gacha", "cases"],
    queryFn: async ({ signal }) => (unwrap(await apiClient.GET("/gacha/cases", { signal }))).items,
  });
}
