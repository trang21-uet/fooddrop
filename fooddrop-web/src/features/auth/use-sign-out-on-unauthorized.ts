"use client";

import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { ApiError } from "@/lib/api/api-error";
import { authClient } from "@/lib/auth-client";

/**
 * A 401 while the session cookie is still present means the session expired server-side.
 * Middleware would keep bouncing /login back to /recipes, so clear the cookie before leaving.
 */
export function useSignOutOnUnauthorized(error: unknown) {
  const router = useRouter();
  useEffect(() => {
    if (!(error instanceof ApiError) || error.status !== 401) return;
    void authClient.signOut().finally(() => router.replace("/login"));
  }, [error, router]);
}
