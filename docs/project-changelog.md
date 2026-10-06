# Changelog

All notable changes to Food Drop. Format based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- 2026-10-06: **Phase 03 — Web Recipe Hub** (Complete)
  - **Shell and theme**: dark neon theme tokens (accent, five rarity colours, glow utilities) in `globals.css`; sticky header with logo and nav; responsive down to phone width
  - **Auth**: `/login` (sign in / create account) with Better Auth client; session cookie stays httpOnly and first-party through the `/backend` proxy rewrite; middleware redirects signed-out visitors to `/login?next=...` (same-origin paths only); expired sessions (401) sign out and return to login
  - **Recipe list** `/recipes`: tag chips grouped by dimension, rarity and max-time filters, debounced search; all filter state lives in the URL; infinite scroll over the keyset-paginated API
  - **Recipe detail** `/recipes/[id]` (Server Component): ingredients, steps, tags, rarity badge, edit and delete; user text rendered as plain text
  - **Create/edit form**: React Hook Form + Zod, ingredient autocomplete (debounced, diacritic-insensitive, can add a missing ingredient), unit suggestions, steps editor with optional timer and reordering, tag picker per dimension
  - **Login redesign and Vietnamese UI**: two-panel login from the Web-Login design board (hero image `public/auth-hero.jpg` faded into the background, password show/hide, sign-in/sign-up toggle); all UI copy is Vietnamese with `lang="vi"` and Geist `latin-ext`; better-auth error codes are mapped to Vietnamese; global pointer cursor for links and buttons
  - Regenerated `src/lib/api/schema.d.ts` from the Phase 02 OpenAPI; added `react-hook-form`, `zod`, `@hookform/resolvers`, `better-auth`, `server-only`
  - Tests: 50 Vitest tests; Playwright full-flow spec (sign up, create, filter, edit, delete, sign out), skipped when the backend is unreachable
  - Fixed during verification: sign-in silently did nothing because the hidden `name` field failed validation; form errors leaked into input accessible names; logo link had no name on phones; heading order on the list page
- 2026-10-06: **Phase 02 — Database and core recipe API** (Complete)
  - **Schema (Drizzle, migrations in `src/database/migrations`)**: all 14 tables from `docs/database-schema.md` plus Better Auth tables (`sessions`, `accounts`, `verifications`); generated `rarity` column; `unaccent` extension for diacritic-insensitive search
  - **Seed (`pnpm db:seed`, idempotent)**: 5 tag dimensions, 57 tags, 230 ingredients with aliases (vi/en), aisle, default unit, density
  - **Auth**: Better Auth (email + password, optional Google, bearer plugin for mobile) mounted at `/api/auth/*`; global guard, routes are protected unless `@AllowAnonymous()`; `@CurrentUser()` decorator
  - **Units module**: pure `normalizeQuantity` / `parseQuantity` (fractions, ranges, comma decimals, Vietnamese units, density-based g↔ml)
  - **Recipes API**: `POST/PUT/DELETE /recipes`, `GET /recipes/:id`, `GET /recipes` with tag filter (AND across dimensions, OR within), rarity, max minutes, text search and keyset pagination; every query scoped by owner
  - **Tags / ingredients API**: `GET /tags`, `GET/POST /ingredients` (diacritic-insensitive search by name or alias)
  - Zod-backed DTOs (`createZodDto`) feed validation and the OpenAPI components in `openapi.json`
  - CI backend job now migrates and seeds Postgres before e2e; `AUTH_SECRET` required in env
  - Tests: unit-conversion cases, cursor/filter unit tests, 26 e2e tests split across `recipes-crud`, `recipes-filters` and `catalog` specs (filters, ownership, validation, pagination)
  - Review fixes: thousands-separator parsing, strict cursor validation (400 instead of 500), CORS `credentials` + exposed `set-auth-token`, unknown units contribute 0, bare "oz" for liquids, foreign-key indexes, e2e cleanup of shared-catalog rows
- 2026-10-06: Repository structure (`fooddrop-web`, `fooddrop-mobile`, `fooddrop-backend`), docs, MVP plan, brand assets (logo, favicon, app icon source), `docker-compose.yml` for Postgres and Redis.
- 2026-10-06: **Phase 01 — Setup monorepo and scaffold apps** (Complete)
  - Git repository initialized and published at https://github.com/trang21-uet/fooddrop; CI green on first run
  - **Backend (NestJS 12 ESM, TypeScript 6 strict)**
    - Health check endpoint (`GET /health`) with Postgres and Redis dependency checks
    - Swagger UI at `/docs` (non-production only)
    - Environment validation via Zod (`src/config/env.schema.ts`)
    - Global `DatabaseModule` (pg Pool) and `RedisModule` (ioredis)
    - OpenAPI generation (`pnpm openapi:generate`)
    - Build tools: Vitest (testing), oxlint (linting)
    - Dependencies installed for later phases: drizzle-orm, drizzle-kit, bullmq, @nestjs/throttler, @nestjs/swagger, @nestjs/config, zod
  - **Web (Next.js 15 App Router, React 19)**
    - Metadata: title "Food Drop", favicon, apple icon, manifest, theme color `#1a1a1f`
    - TanStack Query provider setup
    - Zustand state management
    - OpenAPI-generated TypeScript client (`pnpm api:generate`)
    - Testing: Vitest (unit) and Playwright (e2e)
  - **Mobile (Flutter 3.44.8, Riverpod)**
    - Package ID: `com.trangnx.fooddrop`
    - Display name: "Food Drop"
    - Launcher icons generated from `assets/icon/` via `flutter_launcher_icons`
    - OpenAPI-generated Dart client (dart-dio) into `packages/fooddrop_api`
    - Riverpod + go_router skeleton
    - Core library desugaring enabled for local notifications
  - **CI/CD** (`.github/workflows/ci.yml`)
    - Path-filtered jobs for backend, web, mobile
    - Backend: lint (oxlint), typecheck, unit tests (Vitest), e2e (Supertest)
    - Web: typecheck, lint, unit tests (Vitest), e2e (Playwright)
    - Mobile: analyze, test (flutter test), API client drift check
