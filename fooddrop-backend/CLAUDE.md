# CLAUDE.md — fooddrop-backend

Read the root `../CLAUDE.md` and `../docs/code-standards.md` first.

## Stack

NestJS, TypeScript (strict), Drizzle ORM, PostgreSQL 17, Redis + BullMQ, Zod, `@anthropic-ai/sdk`.

## Commands

```bash
pnpm start:dev        # API (watch)
pnpm worker:dev       # BullMQ worker (recipe parsing); run beside `start:dev`
pnpm parser:eval -- --token <bearer>   # live parser eval from eval/sources.json (not CI)
pnpm lint
pnpm typecheck
pnpm test             # unit
pnpm test:e2e         # needs docker compose up
pnpm db:generate && pnpm db:migrate
pnpm openapi:generate # run after any controller/DTO change
```

Run `lint`, `typecheck` and `test` after every change.

## Structure rules

- Feature modules in `src/modules/<feature>/`: `<feature>.module.ts`, `<feature>.controller.ts`, `<feature>.service.ts`, `<feature>.schemas.ts`, `*.spec.ts`.
- Drizzle schema files live in `src/database/schema/`, one file per aggregate (`recipes.schema.ts`, `tags.schema.ts`, ...). Design reference: `../docs/database-schema.md`.
- Pure domain logic (unit conversion, weighted draw, grocery aggregation, rarity weights) goes in plain functions with no Nest/DB imports, so they are unit-tested directly.

## Domain rules

- **Gacha:** server decides the result using `crypto.randomInt`-based weighted draw. Response includes the full reel and `winningIndex`; clients only animate. Persist every spin in `gacha_spins`.
- **Weight formula:** `rarityWeight × Π weatherBoost` for tags matching the current weather condition. Rarity weights live in one config constant.
- **Parser:** try JSON-LD `schema.org/Recipe` first, then Readability + Claude. Claude returns raw `{qty, unit, name}` via a tool schema; `units/unit-aliases.ts` maps the raw unit to a catalog unit code (keeping spoons as written, converting only units the catalog lacks). Validate with Zod before saving. Never let the LLM do arithmetic.
- **Recipe lines:** `quantity` and `unit` (a `units.code`) are optional and stored as written; `base` (g | ml | piece, for the grocery list) is derived on read by `toBaseQuantity`, never stored. A unit needs a quantity. The unit catalog lives in `database/seed/seed-units.ts` (Vietnamese + English names); add units there and run `pnpm db:seed`.
- **Parser fetches are SSRF-sensitive:** allow only http/https, block private/loopback IP ranges, cap size and timeout. All outbound parser fetches go through `fetchPublicPage` (`modules/parser/url-fetcher.ts`); never call `fetch`/`http` on a user-supplied URL elsewhere.
- **Parser cache:** extractor output is cached in Redis under a versioned key (`URL_CACHE_VERSION`); bump it whenever JSON-LD parsing or the extraction prompt changes.
- **Uploads:** image keys are `parser/{userId}/…` (parser) or `recipes/{userId}/…` (step photos, `purpose: "recipe-step"`); a job or recipe may only reference keys under its owner's prefix. Upload cap is 5 MB (Claude's image limit). Step photo URLs come from `ObjectStorageService.viewUrl` (`S3_PUBLIC_URL` or a signed GET); when a step stops using a photo, or its recipe is deleted, `RecipesService` deletes the object (best effort, skipped for keys another recipe of the owner still uses). Photos uploaded but never saved in a recipe (abandoned form) are not swept; S3 only needs the bucket and keys in `.env` — set `S3_PUBLIC_URL` to serve through a public domain/CDN, otherwise signed URLs are used.
- **External APIs** (Open-Meteo, Places) are cached in Redis by rounded lat/lon grid cell.

## Security

- Every recipe/spin/job query is scoped by `owner_id`/`user_id` from the auth context.
- Rate-limit `/parser/*` and `/gacha/*` per user (`@nestjs/throttler`).
- Secrets only from env (`src/config/env.schema.ts`); fail fast on missing vars.
