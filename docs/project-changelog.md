# Changelog

All notable changes to Food Drop. Format based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- 2026-10-06: Repository structure (`fooddrop-web`, `fooddrop-mobile`, `fooddrop-backend`), docs, MVP plan, brand assets (logo, favicon, app icon source), `docker-compose.yml` for Postgres and Redis.
- 2026-10-06: **Phase 01 — Setup monorepo and scaffold apps** (Complete)
  - Git repository initialized (monorepo root, main branch)
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
