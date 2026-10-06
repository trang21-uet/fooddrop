# Phase 01 — Setup monorepo and scaffold apps

## Context Links
- [plan.md](plan.md) · [system-architecture.md](../../docs/system-architecture.md) · [code-standards.md](../../docs/code-standards.md)

## Overview
- **Priority:** P0
- **Status:** In Progress (≈85%) — blocked on GitHub repo creation + first CI run
- Scaffold the three apps inside the existing folders, wire brand assets, local infra and CI.

## Key Insights
- `fooddrop-web/` and `fooddrop-backend/` already contain README/CLAUDE.md/.env.example/assets, so `create-next-app` and `nest new` will refuse a non-empty folder. Scaffold into a temp folder and move files in, keeping the existing docs.
- `flutter create` works in a non-empty folder and does not overwrite existing files.
- `--org com.trangnx` + `--project-name fooddrop` yields `com.trangnx.fooddrop` on Android and iOS.

## Requirements
- Functional: all three apps start locally; web shows the Food Drop favicon; mobile shows the Food Drop launcher icon.
- Non-functional: strict TS, lint + typecheck + test scripts in each app, CI runs them.

## Architecture
Independent apps in one git repo (no shared JS workspace yet; YAGNI). Contract between apps = `fooddrop-backend/openapi.json`.

## Related Code Files
- Create: scaffolded app sources, `.github/workflows/ci.yml`, `fooddrop-mobile/flutter_launcher_icons.yaml`
- Modify: `fooddrop-web/src/app/layout.tsx` (metadata/icons), Android/iOS app name
- Keep: all existing README.md, CLAUDE.md, `.env.example`, `public/` icons, `assets/icon/`

## Implementation Steps
1. `git init` at `fooddrop/`, create GitHub repo `fooddrop` (`gh repo create fooddrop --private --source . `).
2. **Backend**
   ```bash
   cd fooddrop && pnpm dlx @nestjs/cli new fooddrop-backend-tmp --package-manager pnpm --skip-git --strict
   ```
   Move contents into `fooddrop-backend/` (do not overwrite README.md), delete temp folder. Add `@nestjs/config`, `zod`, `@nestjs/swagger`, `drizzle-orm`, `drizzle-kit`, `pg`, `bullmq`, `ioredis`, `@nestjs/throttler`. Set port 4000, mount Swagger at `/docs`, add `GET /health`. Add `src/config/env.schema.ts` validating `.env`.
3. **Web**
   ```bash
   pnpm create next-app@latest fooddrop-web-tmp --ts --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm
   ```
   Move into `fooddrop-web/`, keep existing `public/` icons, delete the default `src/app/favicon.ico`. In `layout.tsx` set `metadata = { title: 'Food Drop', icons: { icon: '/favicon.ico', apple: '/apple-touch-icon.png' }, manifest: '/manifest.webmanifest' }`. Add `public/manifest.webmanifest` (name Food Drop, theme `#1a1a1f`, icons 192/512). Add TanStack Query, Zustand, Vitest, Playwright.
4. **Mobile**
   ```bash
   cd fooddrop-mobile && flutter create --org com.trangnx --project-name fooddrop --platforms android,ios .
   ```
   Set display name "Food Drop" (`AndroidManifest.xml` `android:label`, iOS `CFBundleDisplayName`). Add deps: `flutter_riverpod`, `riverpod_annotation`, `go_router`, `dio`, `drift`, `flutter_soloud`, `flutter_local_notifications`; dev: `build_runner`, `riverpod_generator`, `drift_dev`, `flutter_launcher_icons`.
5. Create `fooddrop-mobile/flutter_launcher_icons.yaml`:
   ```yaml
   flutter_launcher_icons:
     android: true
     ios: true
     image_path: assets/icon/app-icon.png
     adaptive_icon_background: "#1a1a1f"
     adaptive_icon_foreground: assets/icon/app-icon-foreground.png
     remove_alpha_ios: true
   ```
   Run `dart run flutter_launcher_icons`.
6. Start infra: `docker compose up -d`; verify backend `/health` connects to Postgres and Redis.
7. Add OpenAPI generation:
   - Backend: `pnpm openapi:generate` builds the app and outputs `openapi.json`.
   - Web: `pnpm api:generate` via `openapi-typescript` + `openapi-fetch`, generates TypeScript types and fetch client into `src/lib/api/`.
   - Mobile: `tool/generate-api-client.sh` via `openapi-generator-cli` (dart-dio) generates a full Dart package into `packages/fooddrop_api/`. Wrap the generated client in `lib/core/api/api_client_provider.dart` for Riverpod integration.
8. CI (`.github/workflows/ci.yml`): three jobs (backend, web, mobile) running lint, typecheck/analyze, tests, path-filtered.
9. Update `docs/project-changelog.md` and roadmap.

## Todo List
- [ ] git init + GitHub repo — ⚠️ PARTIAL: `git init` done (branch main), no commit yet; GitHub repo creation awaits user confirmation
- [x] Scaffold backend, health endpoint, env validation, Swagger
- [x] Scaffold web, favicon/manifest wired
- [x] Scaffold mobile with `com.trangnx.fooddrop`, launcher icons generated (debug APK builds)
- [x] OpenAPI generation scripts in all three apps
- [ ] CI workflow green — ⚠️ PARTIAL: workflow written in `.github/workflows/ci.yml`, cannot execute until pushed to GitHub
- [x] Docs updated

## Implementation Notes

**Framework versions & configuration:**
- **Next.js:** Pinned to version 15 via `create-next-app@15` per stack documentation.
- **pnpm:** Version 11 requires `allowBuilds: true` in each app's `pnpm-workspace.yaml` to permit build scripts in dependencies.
- **Nest CLI:** Version 12 scaffolds ESM modules + Vitest + oxlint out of the box.

**Critical fixes applied during implementation:**
- Postgres: Added error listener to idle connection pool to prevent unhandled errors crashing the process; configured `connectionTimeoutMillis: 2000` and `idleTimeoutMillis: 30000` to prevent health-check waiter buildup.
- Redis: Removed concurrent `connect()` race on health checks; now relies on `lazyConnect` mode and `ping()` only.
- CI: Added `permissions` block (`contents: read`, `pull-requests: read`) and regeneration check for Dart client drift.
- Android: Added INTERNET permission to main manifest (not just debug/profile); enabled `usesCleartextTraffic` for debug API access to localhost.
- iOS: Added `NSAllowsLocalNetworking` in `Info.plist` debug config to allow cleartext HTTP to 127.0.0.1.

## Success Criteria
- `pnpm start:dev`, `pnpm dev`, `flutter run` all start without errors.
- Browser tab shows Food Drop favicon; device home screen shows Food Drop icon and name.
- CI passes on an empty feature commit.

## Risk Assessment
- Adaptive icon cropping on Android: verify on a Pixel emulator; adjust foreground padding if the frame is clipped.
- `create-next-app` flags change between versions: check `--help` if a flag is rejected.

## Security Considerations
- `.env` ignored by git; only `.env.example` committed.
- Postgres dev password is local-only; production uses managed credentials.

## Next Steps
Phase 02 (database and core API).
