# Phase 08 — Context boost and Lazy case

## Context Links
- [plan.md](plan.md) · [phase-07](phase-07-food-drop-gacha.md) · [database-schema.md](../../docs/database-schema.md)

## Overview
- **Priority:** P1
- **Status:** Pending
- Weather-aware drop rates and a "Hòm lười biếng" case that drops eat-out / delivery options.

## Key Insights
- Weather only changes weights, never filters, so every recipe can still drop.
- Delivery apps (GrabFood, ShopeeFood) have no public ordering API: use deep links / web search URLs.
- Cache external lookups by rounded coordinates (2 decimals ≈ 1km) to cut cost and avoid storing precise location.

## Requirements
- Functional:
  - Spin request accepts optional `lat/lon`; server maps Open-Meteo current weather to `rain | cold | hot | clear` and applies `weather_boosts`.
  - UI shows a "context" chip (e.g. "Trời mưa: lẩu/nướng ×1.5").
  - Lazy case: reel built from nearby restaurants (Google Places, open now, within ~2km) + user `lazy_options` + generic delivery options; result shows map link / deep link.
  - Manage custom lazy options (CRUD).
- Non-functional: weather cache 10 min, places cache 30 min.

## Architecture
- `context` module: `weather.service.ts` (Open-Meteo + Redis cache + condition mapping), `places.service.ts` (Places Nearby + cache).
- `gacha` module: `caseType: 'lazy'` branch uses `lazy-reel-builder.ts`; result in `result_lazy_payload`.
- Seed `weather_boosts`: rain/cold → hotpot, grill, soup, braise; hot → salad, cold noodles, chè.

## Related Code Files
- Backend: `src/modules/context/**`, `src/modules/gacha/lazy-reel-builder.ts`, lazy options controller
- Web/Mobile: case selector, context chip, lazy result card, location permission prompt

## Implementation Steps
1. Weather service + condition mapping (rain if precipitation > 0.2mm or WMO rain codes; cold < 20°C; hot > 32°C).
2. Apply boosts in weighted draw; include `appliedBoosts` in response and `gacha_spins.context`.
3. Places service, lazy reel builder (cards with photo, rating, distance).
4. Lazy options CRUD.
5. Clients: request location only when spinning (coarse permission on Android), case selector UI, context chip, lazy result actions (open maps, open delivery app/web).

## Todo List
- [ ] Weather service + tests
- [ ] Boosted weights + tests
- [ ] Places service
- [ ] Lazy reel builder + endpoint
- [ ] Lazy options CRUD
- [ ] Web UI
- [ ] Mobile UI

## Success Criteria
- With mocked "rain", boosted tags drop ~1.5× more often (distribution test).
- Lazy case works with location denied (falls back to custom + delivery options).

## Risk Assessment
- Places API cost: cache, cap results, per-user daily limit.
- Deep link formats change: keep links in config, fall back to web URLs.

## Security Considerations
- Round coordinates before caching/logging; never persist raw location. Places API key server-side only.

## Next Steps
Phase 09.
