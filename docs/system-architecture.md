# System Architecture

## Overview

```
┌──────────────────┐   ┌──────────────────┐
│  fooddrop-web    │   │ fooddrop-mobile  │
│  Next.js 15      │   │ Flutter          │
│  TanStack Query  │   │ Riverpod + Drift │
│  Zustand         │   │ (local-first)    │
└────────┬─────────┘   └────────┬─────────┘
         │  REST/JSON (OpenAPI-generated clients)
         └───────────┬──────────┘
                     ▼
        ┌──────────────────────────┐
        │   fooddrop-backend       │
        │   NestJS                 │
        │  ┌────────┐ ┌──────────┐ │      ┌───────────────┐
        │  │ API    │ │ Workers  │─┼─────▶│ Claude API    │
        │  │modules │ │ (BullMQ) │ │      └───────────────┘
        │  └───┬────┘ └────┬─────┘ │      ┌───────────────┐
        │      │           │       ├─────▶│ Open-Meteo    │
        └──────┼───────────┼───────┘      │ Google Places │
               ▼           ▼              └───────────────┘
        ┌───────────┐ ┌─────────┐ ┌──────────────┐
        │PostgreSQL │ │ Redis   │ │ S3 / R2      │
        │ 17        │ │ queue + │ │ images       │
        │           │ │ cache   │ │              │
        └───────────┘ └─────────┘ └──────────────┘
```

## Tech decisions

| Area | Choice | Why |
|---|---|---|
| Web | Next.js 15 App Router | SSR/ISR for shareable, SEO-friendly recipe pages. Team already fluent. |
| Mobile | Flutter | Stable 60/120fps custom animation for the gacha reel. Team already fluent. |
| Backend | NestJS (TypeScript) | Same language as web, modular structure, first-class OpenAPI generation. Lighter than Spring Boot for this scope. |
| ORM | Drizzle | SQL-first, supports generated columns and JSONB well, typed queries without heavy runtime. |
| DB | PostgreSQL 17 | Relational data (tags, ingredients) plus JSONB (steps, raw AI output) in one engine. |
| Queue/cache | Redis + BullMQ | AI parsing is slow and must be async; weather/places responses are cached. |
| AI | Claude API | Vision for cookbook photos, tool-use structured output for strict JSON. Haiku for text/URL, Sonnet for images. |
| Contract | OpenAPI → generated TS + Dart clients | Two UI codebases need one source of truth for types. |

**Trade-off accepted:** two UI codebases (Next.js and Flutter). Flutter Web is heavy and weak at SEO; React Native would force a new stack. The OpenAPI contract keeps them aligned.

## Backend modules

| Module | Responsibility |
|---|---|
| `auth` | Sessions/JWT, Google sign-in, bearer tokens for mobile |
| `recipes` | CRUD, ingredients, steps, search and tag filters |
| `tags` | Tag dimensions and tags, recipe tagging |
| `ingredients` | Canonical ingredient catalog, aisle, density |
| `units` | Deterministic unit conversion (cup/oz/tbsp → g/ml) |
| `parser` | URL/image ingest, JSON-LD extraction, LLM fallback, BullMQ worker |
| `gacha` | Weighted draw, rarity, case types (cook / lazy), spin history |
| `context` | Weather lookup (Open-Meteo) + boost rules, Places lookup |
| `grocery` | Server-side aggregation endpoint (clients may also compute locally) |
| `media` | Signed upload URLs for S3/R2 |

## Key flows

### Gacha spin
1. Client `POST /gacha/spins { caseType, filters, lat?, lon? }`.
2. Server loads candidate recipes, computes `weight = rarityWeight × Π weatherBoost(tag)`, draws one with a CSPRNG.
3. Server returns `{ spinId, result, reel: RecipeCard[] (≈70 items), winningIndex, offsetJitter }`.
4. Client animates the reel to `winningIndex` (6–8s, `cubic-bezier(0.1, 0.7, 0.1, 1)`), plays a tick each time the center marker crosses an item boundary, then reveals.

Server picks the result first so it cannot be manipulated client-side and spins are auditable.

### Recipe parse
1. Client `POST /parser/jobs { url | imageKey }` → `{ jobId }`.
2. Worker: if URL, fetch HTML and try `schema.org/Recipe` JSON-LD first; otherwise clean with Readability and call Claude. If image, call Claude vision.
3. LLM returns raw ingredients via a strict tool schema; `units` module normalizes; result validated with Zod.
4. Client polls `GET /parser/jobs/:id` (or SSE) and shows an editable draft before saving.

Implementation notes: the API process only validates, applies the per-user quota and enqueues; a separate worker process (`src/worker.ts`) runs the pipeline and writes the result (or a stable error code) onto `parse_jobs`. Photos are uploaded directly to object storage with a presigned PUT from `POST /media/uploads`, then referenced by key. Unmatched ingredients come back with `ingredientId = null`; clients add them to the shared catalog (user-added, aisle `other`) before saving the recipe.

### Lazy case
Uses Google Places nearby search (cached per ~1km grid cell) plus user-defined `lazy_options`. Delivery apps (GrabFood, ShopeeFood) are opened via deep links; no partner API integration.

## Web to API transport

The browser calls the API through a same-origin rewrite (`/backend/*` → `API_INTERNAL_URL`, see `fooddrop-web/next.config.ts`), so the Better Auth session cookie is httpOnly and first-party; no CORS or cross-site cookie settings are needed on web. Server Components call the API directly and forward the visitor's cookie. Mobile uses bearer tokens instead.

## Client state

| Concern | Web | Mobile |
|---|---|---|
| Server data | TanStack Query | Riverpod `AsyncNotifier` |
| Client logic (timers, gacha, cart) | Zustand | Riverpod `Notifier` |
| Persistence | IndexedDB (Dexie) | Drift (SQLite) |

- **Mobile recipe sync:** all reads come from Drift. Writes go to Drift and an `outbox` first; a sync pushes the outbox in order, then pulls tags, the recipe list and any missing details. Recipes with queued edits are never overwritten by a pull (last write to reach the server wins). Details of already-synced recipes are refreshed when opened. Sign-out wipes the database.
- **Multi-Timer:** store `{id, label, endsAt, pausedRemainingMs?, alertedAt?}`; one shared ticker (Web Worker on web, `Stream.periodic` on mobile); mobile schedules `flutter_local_notifications` at `endsAt` and re-arms running timers on launch.
- **Grocery list:** store only selected `{recipeId, servings}` + checked `ingredientId|unit` keys; the list is a derived selector grouped by aisle. Web also keeps a snapshot of each selected recipe's ingredients in IndexedDB so the list works offline; mobile reads recipes from Drift.
- **Shared logic:** scaling, rounding, aggregation and timer math are implemented twice (TS and Dart) and verified against the same JSON vectors in `docs/fixtures/`. Change a rule by changing the vectors first.
- **Gacha:** state machine `idle → spinning → revealing → done`; reel offset stays in the animation controller.

## Gacha animation implementation

| | Web | Mobile |
|---|---|---|
| Tween | GSAP (`onUpdate`) or Motion | `AnimationController` + `CurvedAnimation(Cubic(0.1, 0.7, 0.1, 1))` |
| Render | `transform: translateX` + `will-change` | `Transform.translate` inside a clipped `Stack` |
| Tick | Web Audio API `AudioBufferSourceNode` | `flutter_soloud` |
| Reveal FX | CSS/Canvas glow by rarity | Rive or Lottie |

## Deployment (target)

- Web: Vercel.
- Backend: Docker image on Railway / Fly.io / Cloud Run; managed Postgres (Neon/Supabase) and Redis (Upstash).
- Mobile: Play Store / App Store, package `com.trangnx.fooddrop`.
