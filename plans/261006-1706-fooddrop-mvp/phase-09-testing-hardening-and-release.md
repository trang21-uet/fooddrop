# Phase 09 — Testing, hardening and release

## Context Links
- [plan.md](plan.md) · [code-standards.md § Testing](../../docs/code-standards.md) · [development-roadmap.md](../../docs/development-roadmap.md)

## Overview
- **Priority:** P0 for beta
- **Status:** Pending
- E2E coverage of critical flows, security pass, observability, deploy, store submission.

## Key Insights
- The highest-risk code is pure logic (units, weights, aggregation, timers) and already unit-tested; E2E should cover the user journeys that connect it.

## Requirements
- Functional: E2E for sign-in → create recipe → spin → add to grocery → start timer (web Playwright, mobile `integration_test`).
- Non-functional: error tracking, structured logs, uptime check, backups.

## Architecture
- Web on Vercel; backend Docker on Railway/Fly.io/Cloud Run; Neon/Supabase Postgres; Upstash Redis; R2 storage; Sentry for all three apps.

## Related Code Files
- Create: `fooddrop-backend/Dockerfile`, deploy workflows, `fooddrop-web/e2e/**`, `fooddrop-mobile/integration_test/**`, `docs/deployment.md`

## Implementation Steps
1. E2E suites for the main journey on web and mobile.
2. Security pass: auth on every route, ownership tests, rate limits, SSRF tests for parser, dependency audit, secret scan.
3. Sentry + structured logging (pino) + `/health` uptime check.
4. Backend Dockerfile, deploy pipeline, DB migrations on deploy, daily backups.
5. Web deploy to Vercel with env vars.
6. Mobile: release signing, store listing (Food Drop, icon from `assets/brand/`), privacy policy (location, camera usage text), TestFlight + Play internal testing.
7. Update docs: deployment guide, changelog, roadmap.

## Todo List
- [ ] E2E web
- [ ] E2E mobile
- [ ] Security pass
- [ ] Observability
- [ ] Backend deploy
- [ ] Web deploy
- [ ] Mobile beta builds
- [ ] Docs

## Success Criteria
- All CI checks green; beta builds installed by testers; no P0 bugs open.

## Risk Assessment
- App Store review of "gacha" wording: make clear no real money, no purchases, no loot-box monetization.

## Security Considerations
- Production secrets in platform secret stores; least-privilege DB user; HTTPS only; CORS limited to web origin.

## Next Steps
Post-MVP: meal planning calendar, shared household lists, public recipe pages, achievements/collection log for drops.
