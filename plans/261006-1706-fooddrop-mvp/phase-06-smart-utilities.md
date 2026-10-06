# Phase 06 — Smart Utilities (Portion Resizer, Grocery List, Multi-Timer)

## Context Links
- [plan.md](plan.md) · [system-architecture.md § Client state](../../docs/system-architecture.md) · web/mobile `CLAUDE.md`

## Overview
- **Priority:** P1
- **Status:** Pending
- Client-heavy features; backend only supplies normalized data.

## Key Insights
- **Resizer:** pure function `scale(qty, servings, baseServings)` + unit-aware rounding.
- **Grocery:** persist only `{recipeId, servings}[]` + checked ingredient ids; aggregated list is derived.
- **Timers:** persist absolute `endsAt`; one ticker; OS notifications on mobile because background code is suspended.

## Requirements
- Functional:
  - Servings stepper on recipe detail scales all ingredients live.
  - "Add to grocery" from recipe detail; grocery screen groups by aisle, sums same ingredient+unit, checkboxes, clear checked, share as text.
  - Start timer from a step (prefilled) or ad hoc; run many in parallel; pause/resume/add 1 min/cancel; alert with sound + vibration/notification when done; survive app restart / tab reload.
- Non-functional: grocery and timers work offline.

## Architecture
- Shared logic (implemented in both TS and Dart, same test vectors in `docs/` fixture JSON):
  - `scaleQuantity`, `roundForUnit` (g/ml → 5, piece → 0.5)
  - `aggregateGrocery(selections, recipesById)` → `Map<aisle, Item[]>`
  - `timerRemainingMs(timer, now)`
- Web: `use-grocery-store.ts`, `use-timer-store.ts` (Zustand + Dexie persist), ticker in Web Worker, Notification API.
- Mobile: `grocery_selection_notifier.dart`, `timers_notifier.dart` (Drift persist), `ticker_provider.dart` (`Stream.periodic`), `flutter_local_notifications` zoned schedule.

## Related Code Files
- Web: `src/features/{grocery,timers}/**`, `src/features/recipes/servings-stepper.tsx`
- Mobile: `lib/features/{grocery,timers}/**`
- Shared test vectors: `docs/fixtures/grocery-aggregation-cases.json`

## Implementation Steps
1. Write shared test vectors (scaling, rounding, aggregation incl. mixed units of same ingredient).
2. Implement and test pure functions in TS and Dart against the vectors.
3. Portion resizer UI on both clients.
4. Grocery store/provider + screen grouped by aisle, share as text.
5. Timer store/provider, ticker, persistence and restore.
6. Notifications: web permission prompt on first timer; mobile exact-alarm permission handling (Android 14+).
7. Timer UI: floating timer dock visible across screens.

## Todo List
- [ ] Test vectors
- [ ] Pure functions TS + Dart
- [ ] Resizer UI (web, mobile)
- [ ] Grocery (web, mobile)
- [ ] Timers (web, mobile)
- [ ] Notifications
- [ ] Timer dock UI

## Success Criteria
- Same test vectors pass in both languages.
- Mobile: start 3 timers, kill the app, notifications still fire at the right time; reopening shows correct remaining time.

## Risk Assessment
- Android exact alarms restrictions: fall back to inexact with a warning if permission denied.
- Browser background throttling: document limitation; Notification still fires via worker check.

## Security Considerations
- No sensitive data; local storage only holds user's own recipe ids.

## Next Steps
Phase 07.
