# Phase 03 — Web Recipe Hub

## Context Links
- [plan.md](plan.md) · [fooddrop-web/CLAUDE.md](../../fooddrop-web/CLAUDE.md) · [phase-02](phase-02-database-and-core-recipe-api.md)

## Overview
- **Priority:** P0
- **Status:** Complete (2026-10-06)
- Auth screens, recipe list with multi-dimension tag filters, recipe detail, create/edit form, app shell with Food Drop branding.

## Key Insights
- Filter state belongs in the URL (search params) so filtered views are shareable and back-button friendly.
- Recipe detail is a Server Component; only the servings control and timer buttons are client components.

## Requirements
- Functional: sign in/out; list + filter chips grouped by dimension; rarity badge colors (white, blue, purple, pink, red); detail page with ingredients, steps; create/edit form with ingredient autocomplete and tag picker.
- Non-functional: responsive (mobile web), dark theme matching the logo (near-black bg, orange/red neon accents), Lighthouse a11y ≥ 90.

## Architecture
- Routes: `/login`, `/recipes`, `/recipes/new`, `/recipes/[id]`, `/recipes/[id]/edit`.
- `features/recipes/`: `recipe-card.tsx`, `recipe-filter-bar.tsx`, `recipe-form/*`, `use-recipes-query.ts`.
- Design tokens in Tailwind config: rarity colors, neon glow utilities.

## Related Code Files
- Create: routes above, `src/features/recipes/**`, `src/components/ui/**`, `src/lib/api/**` (generated), `src/lib/auth-client.ts`
- Modify: `src/app/globals.css` (Tailwind v4 has no `tailwind.config.ts`; tokens live in `@theme`), `src/app/layout.tsx`, `next.config.ts` (API proxy)

## Implementation Steps
1. App shell: header with logo mark, nav (Recipes, Drop, Grocery, Timers), dark theme tokens.
2. Auth pages and session handling.
3. Recipe list with TanStack Query, URL-synced filters, infinite scroll.
4. Recipe detail page.
5. Recipe form: React Hook Form + Zod, ingredient autocomplete (debounced search), unit select, tag picker per dimension, steps editor with optional timer per step.
6. Tests: filter bar URL sync, form validation.

## Todo List
- [x] Shell + theme tokens
- [x] Auth pages
- [x] Recipe list + filters
- [x] Recipe detail
- [x] Create/edit form
- [x] Tests

## Success Criteria
- User can create a recipe, tag it, find it via filters and view it on desktop and phone width.

## Risk Assessment
- Form complexity: split form into sub-components (ingredients, steps, tags) under 200 lines each.

## Security Considerations
- Auth cookie httpOnly; no tokens in localStorage; sanitize any rendered user HTML (render steps as plain text).

## Implementation Notes
- **Auth transport:** the browser never calls the API origin directly. `next.config.ts` rewrites `/backend/*` to `API_INTERNAL_URL`, so the Better Auth session cookie is first-party and httpOnly with no CORS. Server Components call the API directly and forward the cookie (`src/lib/api/server-api-client.ts`). `src/middleware.ts` only checks the cookie exists; the backend still validates every request.
- **Routes:** `/` redirects to `/recipes`. Nav items Drop/Grocery/Timers are inert placeholders (hidden on phones) until Phases 06/07.
- **Deferred to Phase 06:** servings control and timer buttons on the detail page. Steps with `timerSeconds` show the duration as text only.
- **Ingredient picker** can add a missing ingredient to the shared catalog (`POST /ingredients`), since the seed catalog is limited.
- **Tests:** Vitest (filters + URL sync, filter bar, form schema/validation, login form, 401 sign-out) and Playwright `recipe-hub.spec.ts` (full flow against the real backend; skips itself when the backend is unreachable, so CI without a backend stays green).
- **Measured:** Lighthouse accessibility 100 (login), 96-100 (list, form, detail) on mobile emulation after fixing logo link name and heading order.

## Next Steps
Phase 06 (utilities on detail page), Phase 07 (gacha UI).
