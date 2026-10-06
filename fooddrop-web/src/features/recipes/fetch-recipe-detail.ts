import "server-only";
import { cache } from "react";
import { notFound, redirect } from "next/navigation";
import { getServerApiClient } from "@/lib/api/server-api-client";

const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Loads a recipe for a Server Component (deduped per request via cache), mapping 401 → /login and 400/404 → not-found page. */
export const fetchRecipeDetail = cache(async (id: string) => {
  if (!UUID_PATTERN.test(id)) notFound();
  const client = await getServerApiClient();
  const { data, response } = await client.GET("/recipes/{id}", { params: { path: { id } } });
  if (response.status === 401) redirect(`/login?next=${encodeURIComponent(`/recipes/${id}`)}`);
  if (response.status === 404) notFound();
  if (!data) throw new Error(`Failed to load recipe (${response.status})`);
  return data;
});
