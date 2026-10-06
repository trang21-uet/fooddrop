# Phase 03 — Web Recipe Hub

## Context Links
- [plan.md](plan.md) · [fooddrop-web/CLAUDE.md](../../fooddrop-web/CLAUDE.md) · [phase-02](phase-02-database-and-core-recipe-api.md)

## Overview
- **Priority:** P0
- **Status:** Pending
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
- Modify: `tailwind.config.ts`, `src/app/layout.tsx`

## Implementation Steps
1. App shell: header with logo mark, nav (Recipes, Drop, Grocery, Timers), dark theme tokens.
2. Auth pages and session handling.
3. Recipe list with TanStack Query, URL-synced filters, infinite scroll.
4. Recipe detail page.
5. Recipe form: React Hook Form + Zod, ingredient autocomplete (debounced search), unit select, tag picker per dimension, steps editor with optional timer per step.
6. Tests: filter bar URL sync, form validation.

## Todo List
- [ ] Shell + theme tokens
- [ ] Auth pages
- [ ] Recipe list + filters
- [ ] Recipe detail
- [ ] Create/edit form
- [ ] Tests

## Success Criteria
- User can create a recipe, tag it, find it via filters and view it on desktop and phone width.

## Risk Assessment
- Form complexity: split form into sub-components (ingredients, steps, tags) under 200 lines each.

## Security Considerations
- Auth cookie httpOnly; no tokens in localStorage; sanitize any rendered user HTML (render steps as plain text).

## Next Steps
Phase 06 (utilities on detail page), Phase 07 (gacha UI).
