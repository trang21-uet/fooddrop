import "server-only";
import { cookies } from "next/headers";
import createClient from "openapi-fetch";
import type { paths } from "./schema";

/** Server Component client: calls the backend directly and forwards the visitor's session cookie. */
export async function getServerApiClient() {
  const cookieHeader = (await cookies()).toString();
  return createClient<paths>({
    baseUrl: process.env.API_INTERNAL_URL ?? "http://localhost:4000",
    headers: { cookie: cookieHeader },
    // Recipes are private and mutable; never serve a cached copy.
    cache: "no-store",
  });
}
