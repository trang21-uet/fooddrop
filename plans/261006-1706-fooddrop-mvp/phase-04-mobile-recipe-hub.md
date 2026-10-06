# Phase 04 — Mobile Recipe Hub

## Context Links
- [plan.md](plan.md) · [fooddrop-mobile/CLAUDE.md](../../fooddrop-mobile/CLAUDE.md) · [phase-02](phase-02-database-and-core-recipe-api.md)

## Overview
- **Priority:** P0
- **Status:** Pending
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
- [ ] Bootstrap, theme, router
- [ ] Auth + secure token storage
- [ ] Drift DB + sync
- [ ] List + filters
- [ ] Detail + form
- [ ] Tests

## Success Criteria
- Airplane mode: previously synced recipes still open; edits sync after reconnect.

## Risk Assessment
- Sync conflicts: acceptable LWW for single-user data; revisit if sharing is added.

## Security Considerations
- Tokens only in secure storage; no API keys in the app.

## Next Steps
Phases 06, 07 mobile UI.
