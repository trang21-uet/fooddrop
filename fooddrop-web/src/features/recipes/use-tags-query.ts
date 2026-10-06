"use client";

import { useQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";

/** Tag dimensions and their tags; seeded reference data, so cache it for a while. */
export function useTagsQuery() {
  return useQuery({
    queryKey: ["tags"],
    queryFn: async ({ signal }) => unwrap(await apiClient.GET("/tags", { signal })),
    staleTime: 10 * 60_000,
  });
}
