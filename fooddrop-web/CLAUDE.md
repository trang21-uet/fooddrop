# CLAUDE.md — fooddrop-web

Read the root `../CLAUDE.md` and `../docs/code-standards.md` first.

## Stack

Next.js 15 App Router, React 19, TypeScript (strict), Tailwind CSS, TanStack Query, Zustand, GSAP (or Motion), Web Audio API, Dexie (IndexedDB).

## Commands

```bash
pnpm dev
pnpm lint
pnpm typecheck
pnpm test          # Vitest
pnpm test:e2e      # Playwright
pnpm api:generate  # after backend OpenAPI changes
```

Run `lint`, `typecheck` and `test` after every change.

## Structure rules

- Routes in `src/app/`; feature code in `src/features/<feature>/` (components, hooks, store slice, helpers).
- API types/clients are generated into `src/lib/api/`. Do not edit generated files and do not hand-write DTO types.
- The browser calls the API via the `/backend` proxy (`next.config.ts`), never the API origin directly; Server Components use `getServerApiClient()` so the session cookie is forwarded.
- UI copy is Vietnamese (`<html lang="vi">`), written inline in components; there is no i18n layer. Geist loads the `latin-ext` subset for Vietnamese diacritics. Server messages (better-auth, API) are English: map them to Vietnamese or fall back to a generic line (see `features/auth/auth-error-message.ts`).
- Server Components by default. `'use client'` only for interactive pieces (gacha reel, timers, grocery checkboxes).

## State rules

- Server data → TanStack Query. Client logic → Zustand. Persisted client state → Dexie.
- Timers: store `endsAt` (epoch ms); compute remaining at render from one shared ticker. Run the ticker in a Web Worker so background tabs throttle less; use the Notification API when a timer ends.
- Grocery list: store `{recipeId, servings}[]` + checked ingredient ids; derive the aggregated, aisle-grouped list with a memoized selector.
- Gacha store holds only `status` (`idle | spinning | revealing | done`) and the spin response. Never put reel offset in a store.

## Gacha reel

- Render ~70 cards in a horizontal strip; animate a single wrapper with `transform: translateX` and `will-change: transform`.
- Duration 6–8s, ease `cubic-bezier(0.1, 0.7, 0.1, 1)`; target = `winningIndex × cardWidth − centerOffset + offsetJitter`.
- Tick: in `onUpdate`, compute `Math.floor(offset / cardWidth)`; when it changes, play a pre-decoded `AudioBuffer` via a new `AudioBufferSourceNode`. Unlock the `AudioContext` on the user's click.
- Respect `prefers-reduced-motion`: shorten to a quick fade reveal.
- Use only original or licensed sounds in `public/sounds/`; no Valve assets.
