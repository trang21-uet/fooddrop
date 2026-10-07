---
title: Food Drop MVP
created: 2026-10-06
status: in-progress
---

# Food Drop MVP — Implementation Plan

Goal: ship a web + mobile MVP with Recipe Hub, AI Parser, Smart Utilities and the Food Drop gacha (cook + lazy cases, weather boost).

Architecture: [docs/system-architecture.md](../../docs/system-architecture.md) · Schema: [docs/database-schema.md](../../docs/database-schema.md) · Standards: [docs/code-standards.md](../../docs/code-standards.md)

## Phases

| # | Phase | Depends on | Status |
|---|---|---|---|
| 01 | [Setup monorepo and scaffold apps](phase-01-setup-monorepo-and-scaffold.md) | — | Complete |
| 02 | [Database and core recipe API](phase-02-database-and-core-recipe-api.md) | 01 | Complete |
| 03 | [Web Recipe Hub](phase-03-web-recipe-hub.md) | 02 | Complete |
| 04 | [Mobile Recipe Hub](phase-04-mobile-recipe-hub.md) | 02 | Complete |
| 05 | [AI Recipe Parser](phase-05-ai-recipe-parser.md) | 02 (UI: 03, 04) | Pending |
| 06 | [Smart Utilities](phase-06-smart-utilities.md) | 03, 04 | Pending |
| 07 | [Food Drop gacha](phase-07-food-drop-gacha.md) | 02 (UI: 03, 04) | Pending |
| 08 | [Context boost and Lazy case](phase-08-context-boost-and-lazy-case.md) | 07 | Pending |
| 09 | [Testing, hardening and release](phase-09-testing-hardening-and-release.md) | all | Pending |

Phases 03 and 04 can run in parallel. Phase 05 backend and Phase 07 backend can also run in parallel with 03/04.

## Key decisions

- Two UI codebases (Next.js, Flutter) sharing one OpenAPI contract from NestJS.
- Server-authoritative gacha; clients only animate.
- Deterministic unit conversion in code; LLM only extracts.
- Absolute `endsAt` timers; derived grocery list; local-first on mobile.

## Open questions

1. ~~Auth provider~~ — Better Auth (self-hosted, bearer plugin for mobile) adopted in Phase 02.
2. Recipes private-only for MVP, or public sharing pages (affects SSR/SEO scope in Phase 03)? Default: private + optional public share link.
3. Tick/reveal sound source: commission, record, or licensed pack.
4. Hosting budget for backend (Railway vs Fly.io vs Cloud Run).
