/** Post-login destination from `?next=`; only same-origin paths are allowed to prevent open redirects. */
export function safeRedirectPath(next: string | null | undefined, fallback = "/recipes"): string {
  if (!next || !next.startsWith("/") || next.startsWith("//") || next.startsWith("/\\")) return fallback;
  return next;
}
