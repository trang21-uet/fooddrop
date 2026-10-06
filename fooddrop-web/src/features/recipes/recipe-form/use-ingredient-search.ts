"use client";

import { useQuery } from "@tanstack/react-query";
import { useEffect, useState } from "react";
import { apiClient } from "@/lib/api/api-client";
import { unwrap } from "@/lib/api/api-error";

const DEBOUNCE_MS = 250;

/** Debounced catalog search; stays idle until there is something to search for. */
export function useIngredientSearch(term: string) {
  const [debounced, setDebounced] = useState(term);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(term.trim()), DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [term]);

  return useQuery({
    queryKey: ["ingredients", debounced],
    enabled: debounced.length > 0,
    queryFn: async ({ signal }) =>
      unwrap(await apiClient.GET("/ingredients", { signal, params: { query: { q: debounced, limit: 8 } } })),
    staleTime: 60_000,
  });
}

export async function createIngredient(name: string) {
  return unwrap(await apiClient.POST("/ingredients", { body: { name, aliases: [], aisle: "other", defaultUnit: "g", densityGPerMl: null } }));
}
