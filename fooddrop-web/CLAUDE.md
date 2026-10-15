# CLAUDE.md — fooddrop-web

Read the root `../CLAUDE.md` and `../docs/code-standards.md` first.

## Stack

Next.js 15 App Router, React 19, TypeScript (strict), Tailwind CSS, TanStack Query, Zustand, Web Audio API, Dexie (IndexedDB).

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
- `/drop` is the case picker (`case-select-view.tsx`, data from `GET /gacha/cases`, tabs per `group` in `CASE_TABS`, copy/colours via `caseStyle()` in `gacha-case-styles.ts`: featured cases fixed, tag cases from `label` + palette hash shared with mobile); `/drop/[caseId]` the reel (`drop-view.tsx`). The store keeps the spin's `caseId` so another case's page never shows it.
- `features/gacha/`: `use-reel-animation.ts` runs `requestAnimationFrame` for 7 s with `reelEase` (`cubic-bezier.ts`, no GSAP) and writes `transform` on the strip; card width and gap are measured from the DOM. Geometry is pure in `reel-geometry.ts` (`targetOffset`, `slotUnderMarker`), same math as mobile.
- Tick: when `slotUnderMarker` changes, `playTick()` (`tick-sound-player.ts`) starts a pre-decoded `AudioBuffer`. `prepareReelSounds()` builds the AudioContext when the drop page mounts (its constructor can block for seconds on a bad audio device); `unlockReelSounds()` only resumes it inside the spin click. History is invalidated only after landing so it never spoils the result.
- Respect `prefers-reduced-motion`: shorten to a quick fade reveal.
- Use only original or licensed sounds in `public/sounds/`; no Valve assets.

## Utilities (resizer, grocery, timers)

- Pure logic with shared vectors in `../docs/fixtures/` (the mobile app runs the same files): `features/recipes/portion-scaling.ts`, `features/grocery/aggregate-grocery.ts`, `features/timers/timer-math.ts`. Change a rule in the fixture JSON first, then both languages.
- Persistence is Dexie (`src/lib/local-db.ts`, opened lazily so SSR never touches IndexedDB). Stores (`use-grocery-store.ts`, `use-timer-store.ts`) write through to it and log, not throw, when storage is blocked. `LocalStateBoot` (in the `(app)` layout) hydrates them, rings finished timers and renders the dock. Sign-out calls `wipeLocalData()`.
- Start timers only through `startTimer()` (`features/timers/start-timer.ts`): it needs a click to unlock audio and ask for notification permission. The chime is synthesized; do not add sound assets without a license.
- Tests that touch the stores import `fake-indexeddb/auto`.
