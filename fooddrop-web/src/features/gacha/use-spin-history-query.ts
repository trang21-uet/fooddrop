"use client";

import { useQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";

export const SPIN_HISTORY_KEY = ["gacha", "spins"] as const;

export function useSpinHistoryQuery() {
  return useQuery({
    queryKey: SPIN_HISTORY_KEY,
    queryFn: async ({ signal }) =>
      unwrap(await apiClient.GET("/gacha/spins", { params: { query: { limit: 8 } }, signal })),
  });
}
