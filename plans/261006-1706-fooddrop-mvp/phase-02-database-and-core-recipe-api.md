# Phase 02 — Database and core recipe API

## Context Links
- [plan.md](plan.md) · [database-schema.md](../../docs/database-schema.md) · [fooddrop-backend/CLAUDE.md](../../fooddrop-backend/CLAUDE.md)

## Overview
- **Priority:** P0
- **Status:** Complete
- Drizzle schema + migrations + seed, auth, and CRUD for recipes, tags and ingredients.

## Key Insights
- Ingredients relational (needed for aggregation); steps JSONB (read as a whole, carry timers).
- Rarity as a generated column keeps tier thresholds in one place.
- Unit conversion is needed already here (manual recipe entry), not only in the parser.

## Requirements
- Functional: sign up / sign in (email + Google); CRUD recipes with ingredients, steps, tags; list recipes filtered by tags (AND across dimensions, OR within one), rarity, max minutes, text search; list tag dimensions/tags; search ingredients by name/alias.
- Non-functional: all queries scoped by user; list endpoint p95 < 150ms on 1k recipes.

## Architecture
Modules: `auth`, `recipes`, `tags`, `ingredients`, `units`. `units` exposes a pure `normalizeQuantity(qty, unit, ingredient)` → `{quantity, unit: 'g'|'ml'|'piece'}` used by recipes and later by the parser.

## Related Code Files
- Create: `src/database/schema/*.schema.ts`, `src/database/seed/*.ts`, `drizzle.config.ts`, `src/modules/{auth,recipes,tags,ingredients,units}/**`
- Modify: `src/app.module.ts`

## Implementation Steps
1. Write Drizzle schema per `docs/database-schema.md` (users, ingredients, recipes with generated `rarity`, recipe_ingredients, tag_dimensions, tags, recipe_tags, weather_boosts, lazy_options, gacha_spins, parse_jobs).
2. `pnpm db:generate && pnpm db:migrate`.
3. Seed: 5 tag dimensions, ~60 tags (cuisine, equipment incl. air fryer / pressure cooker / oven, meal type, technique incl. fermented, diet), ~200 ingredients with aisle, aliases (vi/en), density.
4. Auth: Better Auth (email + Google) with bearer plugin for mobile; Nest guard exposing `currentUser`. (Confirm open question 1 first.)
5. `units` module: conversion table (cup, tbsp, tsp, oz, lb, fl oz, kg, l, ml, g, "quả/củ/tép" → piece) + density lookup; unit tests for edge cases (fractions "1 1/2", ranges "2-3", unknown units → keep as note).
6. Recipes module: create/update in a transaction (recipe + ingredients + tags), list with filters and cursor pagination, get detail, delete.
7. Tags + ingredients read endpoints; `POST /ingredients` for user-added ingredients (aisle `other` by default).
8. Regenerate `openapi.json`.

## Todo List
- [x] Drizzle schema + migrations
- [x] Seed data
- [x] Auth + guard
- [x] Units module + tests
- [x] Recipes CRUD + filters + tests
- [x] Tags & ingredients endpoints
- [x] OpenAPI regenerated

## Success Criteria
- E2E test: create recipe with 3 tags → filter by two dimensions returns it; other user cannot read it.
- Unit conversion tests pass (≥20 cases).

## Risk Assessment
- Tag filter SQL complexity: implement with `EXISTS` per dimension; add index `(tag_id, recipe_id)`.
- Ingredient duplicates via aliases: normalize lowercase + unaccent for matching.

## Security Considerations
- Ownership checks on every recipe query; Zod-validated bodies; password hashing handled by auth library.

## Next Steps
Phases 03, 04, 05, 07 unblock.
