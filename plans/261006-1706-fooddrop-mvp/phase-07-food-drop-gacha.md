# Phase 07 — Food Drop gacha (cook case)

## Context Links
- [plan.md](plan.md) · [system-architecture.md § Gacha](../../docs/system-architecture.md) · web/mobile/backend `CLAUDE.md`

## Overview
- **Priority:** P0 (signature feature)
- **Status:** Pending
- Server-authoritative weighted draw + CS:GO-style reel animation with tick sound on web and mobile.

## Key Insights
- The feel comes from three things: long deceleration curve, a tick exactly on each item boundary, and a landing offset that looks like a near-miss.
- Ticks must be driven by position, not time.
- Reel position must never pass through React/Riverpod state (would re-render per frame).

## Requirements
- Functional: choose case (cook), optional filters (tags, max minutes); spin; reveal with rarity glow; actions "Cook this" (open recipe), "Add to grocery", "Spin again"; spin history.
- Rarity weights (config): white 50, blue 25, purple 15, pink 7, red 3 (normalized over available recipes).
- Non-functional: 60fps on mid-range Android and a 2019 laptop; reduced-motion fallback.

## Architecture
- Backend `gacha` module: `weighted-draw.ts` (pure, injectable RNG), `reel-builder.ts` (≈70 cards, winner at index 60, filler sampled with the same weights so rarities look realistic), `POST /gacha/spins`, `GET /gacha/spins`.
- Response: `{spinId, caseType, result, reel[], winningIndex, offsetJitter (−0.4..0.4 of card width)}`.
- Web: `features/gacha/{case-reel.tsx, use-reel-animation.ts, tick-sound-player.ts, reveal-overlay.tsx, use-gacha-store.ts}`.
- Mobile: `features/gacha/presentation/{case_reel.dart, reel_controller.dart, reveal_overlay.dart}`, `data/tick_sound_player.dart`.

## Related Code Files
- Backend: `src/modules/gacha/**`
- Web: `src/features/gacha/**`, `src/app/drop/page.tsx`, `public/sounds/{tick,reveal-*.ogg}`
- Mobile: `lib/features/gacha/**`, `assets/sounds/**`

## Implementation Steps
1. Backend weighted draw with `crypto.randomInt`; unit tests with seeded RNG verifying distribution within ±2% over 100k draws.
2. Reel builder + endpoint + persistence in `gacha_spins`; empty-pool error when no recipes match filters.
3. Source sounds: short tick (~20ms, original), reveal stingers per rarity.
4. Web reel: GSAP tween 7s, ease `cubic-bezier(0.1,0.7,0.1,1)`; `onUpdate` boundary detection → `AudioBufferSourceNode`; unlock `AudioContext` on spin click; center marker matching the logo's orange arrows.
5. Mobile reel: `AnimationController` + `Cubic(0.1,0.7,0.1,1)`; boundary detection in listener → `flutter_soloud` + `HapticFeedback.selectionClick()`; `RepaintBoundary`.
6. Reveal overlay: rarity glow (white/blue/purple/pink/red), particles; Rive on mobile.
7. Reduced motion: 1s fade to result.
8. Perf check: Chrome performance panel and Flutter DevTools (no jank frames during spin).

## Todo List
- [ ] Weighted draw + distribution tests
- [ ] Reel builder + endpoint
- [ ] Sounds
- [ ] Web reel + tick
- [ ] Mobile reel + tick + haptics
- [ ] Reveal overlay
- [ ] Reduced-motion
- [ ] Perf verification

## Success Criteria
- Tick count equals number of boundaries crossed; spin lands exactly on the server's result every time; 60fps measured.

## Risk Assessment
- Audio latency on Android: preload with `flutter_soloud`; fall back to haptic-only if audio init fails.
- Too few recipes for a varied reel: allow repeats in filler, show hint to add more recipes.

## Security Considerations
- Client cannot choose result; rate-limit spins (e.g. 30/min).

## Next Steps
Phase 08 adds weather boost and Lazy case on top of the same reel.
