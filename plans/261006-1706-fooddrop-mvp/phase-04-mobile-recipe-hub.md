# Phase 04 — Mobile Recipe Hub

## Context Links
- [plan.md](plan.md) · [fooddrop-mobile/CLAUDE.md](../../fooddrop-mobile/CLAUDE.md) · [phase-02](phase-02-database-and-core-recipe-api.md)

## Overview
- **Priority:** P0
- **Status:** Complete (2026-10-06)
- Flutter equivalent of Phase 03 with local-first storage.

## Key Insights
- Local-first (Drift) keeps recipes available offline in the kitchen and supermarket.
- Sync strategy for MVP: pull on launch/refresh, push mutations from an outbox table; last-write-wins on `updated_at`.

## Requirements
- Functional: sign in (email, Google), recipe list with tag filter sheet, detail, create/edit.
- Non-functional: works offline for reading; theme matches web; 60fps scrolling.

## Architecture
- `lib/core/db/` Drift database (recipes, recipe_ingredients, tags, outbox).
- `lib/features/recipes/data/recipe_repository.dart` merges remote (generated Dio client) + local.
- `go_router` routes: `/login`, `/recipes`, `/recipes/:id`, `/recipes/new`, `/recipes/:id/edit`.

## Related Code Files
- Create: `lib/app/**`, `lib/core/{api,db,auth}/**`, `lib/features/recipes/**`
- Modify: `pubspec.yaml`, `lib/main.dart`

## Implementation Steps
1. App bootstrap: `ProviderScope`, router, dark theme (rarity colors as `ThemeExtension`).
2. Auth: bearer token stored in `flutter_secure_storage`; Dio interceptor.
3. Drift schema + outbox sync service.
4. Recipe list with filter bottom sheet grouped by dimension.
5. Detail and create/edit screens.
6. Widget tests for filter sheet and form validation.

## Todo List
- [x] Bootstrap, theme, router
- [x] Auth + secure token storage
- [x] Drift DB + sync
- [x] List + filters
- [x] Detail + form
- [x] Tests

## Success Criteria
- Airplane mode: previously synced recipes still open; edits sync after reconnect.

## Risk Assessment
- Sync conflicts: acceptable LWW for single-user data; revisit if sharing is added.

## Security Considerations
- Tokens only in secure storage; no API keys in the app.

## Implementation Notes
- **Design source:** Login, Register, Recipes and Recipe-Detail boards of the Food Drop design canvas (neon dark tokens, Geist via `google_fonts`, Vietnamese copy). The form has no board; it reuses the same components.
- **Auth:** Better Auth over `/api/auth/sign-in|sign-up|sign-out/email` (not in OpenAPI, so `core/auth/auth_remote.dart` uses Dio directly). The signed bearer token comes from the `set-auth-token` response header and lives only in `flutter_secure_storage`. Launch trusts the stored session (works offline); any 401 clears it and wipes the local DB. Google sign-in is deferred (needs OAuth client ids and a native flow; the design has no Google button).
- **Local-first:** Drift tables `recipes`, `recipe_ingredients`, `recipe_tags`, `tags`, `outbox`. All reads (list, filters, search, detail) come from Drift, so filtering is on-device and works offline. Writes land in Drift and the outbox first; `RecipeSyncService` pushes the outbox (create/update/delete, repeated edits coalesced into one queued write) and then pulls. Push-before-pull plus "skip recipes with pending edits" gives last-write-wins without needing `updatedAt` from the list endpoint. Permanently rejected changes (4xx) are dropped, the server copy restored, and the user told. Recipe details are fetched for recipes that have none, and refreshed when a detail screen opens.
- **Quantities:** offline edits keep the raw text ("1 1/2 thìa") for display until the server normalizes it (units stay a backend concern).
- **Deviations from the design board:** the bottom nav (Quay món / Đi chợ / Hẹn giờ) is not rendered until those screens exist (Phases 06/07); the detail bottom bar shows Edit/Delete instead of "Thêm vào đi chợ"/timer; step timers show the duration only; a filter button next to search opens the tag/max-time sheet.
- **API client generation:** `tool/generate-api-client.sh` now normalizes the spec for dart-dio (quantity `anyOf` → string; defaults on enum/array properties dropped) and raises the package SDK constraint. Needs JDK 11+ (the machine default is Java 8; use Temurin 21).
- **Tests:** 71 (filters/search, draft validation, Drift store + outbox, sync service with a fake remote, auth controller with a stubbed HTTP adapter, filter sheet, form, list, detail, login/register, router redirects, and a real-backend flow that skips when the API is down).
- **Not verified:** on-device visuals and the airplane-mode flow were not run on an emulator (none available here); the same behaviour is covered by the Drift/sync tests. `flutter build apk --debug` succeeds.

## Next Steps
Phases 06, 07 mobile UI.
