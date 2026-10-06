# Code review — Phase 01 scaffold

Score 7.5/10 · Critical 0 · High 2 · Medium 6 · Low 7. Lint/typecheck/tests green at review time.

| # | Sev | Finding | Resolution |
|---|---|---|---|
| 1 | High | pg Pool had no `'error'` listener → idle-client error crashes process | Fixed: listener in `database.module.ts` |
| 2 | High | No pg `connectionTimeoutMillis` → health waiters pile up, pool starves | Fixed: 2000ms connect timeout, 30s idle |
| 3 | Med | Redis health `connect()` race on concurrent requests | Fixed: rely on lazyConnect, just `ping()` |
| 4 | Med | `.gitignore` Playwright entries anchored to root | Fixed: unanchored + blob-report, playwright/.cache |
| 5 | Med | CI mobile job ignored `openapi.json`, no Dart client drift check | Fixed: filter path + regenerate & `git status --porcelain` check |
| 6 | Med | CI had no `permissions` block | Fixed: `contents: read`, `pull-requests: read` |
| 7 | Med | INTERNET permission only in debug/profile manifests | Fixed: added to main manifest |
| 8 | Med | Cleartext HTTP to local API blocked (Android 9+, iOS ATS) | Fixed: debug `usesCleartextTraffic`, iOS `NSAllowsLocalNetworking` |
| 9 | Low | CORS origins not trimmed | Fixed |
| 10 | Low | Swagger UI public in production | Fixed: only when `NODE_ENV !== production` |
| 11 | Low | Redis shutdown connects just to quit when never used | Fixed |
| 12 | Low | `openapi:generate` needs DATABASE_URL/REDIS_URL | Open: documented; CI sets them |
| 13 | Low | Redundant `vite-tsconfig-paths` | Fixed: `resolve.tsconfigPaths` |
| 14 | Low | Web API base URL silently falls back to localhost | Open: acceptable for now |
| 15 | Low | Deps installed ahead of use (throttler, bullmq, drift, ...) | Open: required by plan |

## Unresolved questions
- Split `/health` into `/health/live` and `/health/ready` before deployment?
