import type { NextConfig } from "next";

const API_INTERNAL_URL = process.env.API_INTERNAL_URL ?? "http://localhost:4000";

const nextConfig: NextConfig = {
  async rewrites() {
    // Browser talks to the API through this same-origin proxy so the Better Auth session cookie
    // stays first-party and httpOnly, with no CORS or cross-site cookie issues.
    return [{ source: "/backend/:path*", destination: `${API_INTERNAL_URL}/:path*` }];
  },
};

export default nextConfig;
