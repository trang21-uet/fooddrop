import { createAuthClient } from "better-auth/react";

// Auth routes live on the backend at /api/auth/*, reached through the /backend proxy.
// baseURL needs an origin; the fallback only matters during SSR, where no request is made.
export const authClient = createAuthClient({
  baseURL: typeof window === "undefined" ? "http://localhost:3000" : window.location.origin,
  basePath: "/backend/api/auth",
});
