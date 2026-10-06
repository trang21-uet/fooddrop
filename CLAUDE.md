# CLAUDE.md — Food Drop (monorepo root)

Guidance for Claude Code when working anywhere in this repository. Each app folder has its own `CLAUDE.md` with app-specific rules; read it before editing files there.

## Project

Food Drop is a cross-platform (web + mobile) app for choosing meals and cooking: a recipe hub with multi-dimension tags, a CS:GO-style "case opening" gacha for picking dishes, an AI recipe parser, and cooking utilities (grocery list, portion resizer, multi-timer).

- App name: **Food Drop**
- Bundle / package id: **com.trangnx.fooddrop**
- Repo and folder prefix: **fooddrop**

## Layout

| Path | What | Stack |
|---|---|---|
| `fooddrop-web/` | Web client | Next.js 15 App Router, TS, Tailwind, TanStack Query, Zustand |
| `fooddrop-mobile/` | Android/iOS client | Flutter, Riverpod, Drift |
| `fooddrop-backend/` | REST API + workers | NestJS, Drizzle, Postgres, Redis/BullMQ |
| `docs/` | Architecture, schema, standards, roadmap, changelog | — |
| `plans/` | Implementation plans (phase files) | — |
| `assets/brand/` | Logo sources. Do not edit originals; export new sizes instead | — |

## Core architecture rules

1. **Backend owns business logic.** Gacha RNG, weighting, rarity, unit normalization and grocery aggregation rules live in `fooddrop-backend`. Clients render; they do not decide spin results.
2. **One API contract.** NestJS generates OpenAPI (`fooddrop-backend/openapi.json`). Web (TS) and mobile (Dart) clients are generated from it. Never hand-write DTO types in clients.
3. **Units are normalized in code, not by the LLM.** The parser extracts raw `{qty, unit, name}`; a deterministic converter maps to `g | ml | piece`.
4. **Timers store absolute `endsAt` timestamps**, never "seconds remaining".
5. **Grocery list is derived state** from selected `{recipeId, servings}`; never persist the aggregated list.
6. **Animation state stays out of global stores.** Stores hold `idle → spinning → revealing → done` + `resultId`; reel position lives in the animation controller.

## Conventions

- Follow `docs/code-standards.md`. Files are kebab-case (Dart: snake_case, per Dart rules) and stay under ~200 lines.
- YAGNI, KISS, DRY. No speculative abstractions.
- Conventional commits (`feat(web): ...`, `fix(backend): ...`, `chore(mobile): ...`). No AI references in messages.
- Never commit `.env` files or API keys. Use `.env.example`.
- After changing code, run that app's lint/typecheck/test commands (see its `CLAUDE.md`).
- Update `docs/project-changelog.md` and `docs/development-roadmap.md` when a phase or feature completes.

## Local infrastructure

```bash
docker compose up -d   # Postgres :5432, Redis :6379
```

## Current plan

Active plan: `plans/261006-1706-fooddrop-mvp/plan.md`. Work phase by phase and tick the todo list in each phase file.

## Legal note

The gacha imitates the *mechanics* of CS:GO case opening (sliding reel, deceleration, tick sound). Do not use Valve assets (sounds, fonts, icons, item art). All sounds must be original or properly licensed.
