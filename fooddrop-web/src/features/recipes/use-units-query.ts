"use client";

import { useQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";

/** The unit catalog (thìa canh, quả, nhánh, ...); seeded reference data, so cache it for a while. */
export function useUnitsQuery() {
  return useQuery({
    queryKey: ["units"],
    queryFn: async ({ signal }) => unwrap(await apiClient.GET("/units", { signal })),
    staleTime: 60 * 60_000,
  });
}
