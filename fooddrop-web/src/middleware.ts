import { NextResponse, type NextRequest } from "next/server";

// Better Auth's default session cookie; it gets a `__Secure-` prefix when the API is served over https.
// Checked by name instead of importing better-auth/cookies, which drags a JWT library into the Edge bundle.
const SESSION_COOKIE = "better-auth.session_token";

/**
 * Optimistic gate: only checks that a session cookie exists so signed-out visitors are sent to
 * /login without a flash of protected UI. The backend still validates the session on every call.
 */
export function middleware(request: NextRequest) {
  const { pathname, search } = request.nextUrl;
  const hasSession = request.cookies.has(SESSION_COOKIE) || request.cookies.has(`__Secure-${SESSION_COOKIE}`);

  if (pathname === "/login") {
    return hasSession ? NextResponse.redirect(new URL("/recipes", request.url)) : NextResponse.next();
  }
  if (!hasSession) {
    const login = new URL("/login", request.url);
    login.searchParams.set("next", pathname + search);
    return NextResponse.redirect(login);
  }
  return NextResponse.next();
}

export const config = {
  matcher: ["/", "/login", "/recipes/:path*"],
};
