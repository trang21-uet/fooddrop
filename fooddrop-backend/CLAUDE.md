# CLAUDE.md — fooddrop-backend

Read the root `../CLAUDE.md` and `../docs/code-standards.md` first.

## Stack

NestJS, TypeScript (strict), Drizzle ORM, PostgreSQL 17, Redis + BullMQ, Zod, `@anthropic-ai/sdk`.

## Commands

```bash
pnpm start:dev        # API (watch)
pnpm worker:dev       # BullMQ worker
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
- **Parser:** try JSON-LD `schema.org/Recipe` first, then Readability + Claude. Claude returns raw `{qty, unit, name}` via a tool schema; the `units` module converts to `g | ml | piece`. Validate with Zod before saving. Never let the LLM do arithmetic.
- **Parser fetches are SSRF-sensitive:** allow only http/https, block private/loopback IP ranges, cap size and timeout.
- **External APIs** (Open-Meteo, Places) are cached in Redis by rounded lat/lon grid cell.

## Security

- Every recipe/spin/job query is scoped by `owner_id`/`user_id` from the auth context.
- Rate-limit `/parser/*` and `/gacha/*` per user (`@nestjs/throttler`).
- Secrets only from env (`src/config/env.schema.ts`); fail fast on missing vars.
