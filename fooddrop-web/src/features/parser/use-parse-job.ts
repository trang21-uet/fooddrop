"use client";

import { useQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";

const POLL_MS = 1500;

/** Polls a parse job until it reaches a terminal state. Pass null to stay idle. */
export function useParseJob(jobId: string | null) {
  return useQuery({
    queryKey: ["parse-job", jobId],
    enabled: jobId !== null,
    queryFn: async ({ signal }) =>
      unwrap(await apiClient.GET("/parser/jobs/{id}", { signal, params: { path: { id: jobId! } } })),
    refetchInterval: (query) =>
      query.state.data?.status === "succeeded" || query.state.data?.status === "failed" ? false : POLL_MS,
  });
}
