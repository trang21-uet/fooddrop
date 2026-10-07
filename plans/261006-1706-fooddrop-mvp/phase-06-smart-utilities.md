# Phase 06 — Smart Utilities (Portion Resizer, Grocery List, Multi-Timer)

## Context Links
- [plan.md](plan.md) · [system-architecture.md § Client state](../../docs/system-architecture.md) · web/mobile `CLAUDE.md`

## Overview
- **Priority:** P1
- **Status:** Implemented; on-device notification check pending (see Success Criteria)
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
- [x] Test vectors (`docs/fixtures/{portion-scaling,grocery-aggregation,timer-math}-cases.json`)
- [x] Pure functions TS + Dart (same vectors pass in both)
- [x] Resizer UI (web, mobile)
- [x] Grocery (web, mobile)
- [x] Timers (web, mobile)
- [x] Notifications (web: Notification API + synthesized chime + vibration; mobile: zoned local notification, exact-alarm fallback)
- [x] Timer dock UI (web: fixed dock; mobile: go_router `ShellRoute` dock)

## Success Criteria
- [x] Same test vectors pass in both languages.
- [ ] Mobile: start 3 timers, kill the app, notifications still fire at the right time; reopening shows correct remaining time. **Not verified on a device**: the Dart logic is unit-tested against a fake scheduler (restart restores timers from Drift and re-arms only the running ones) and the debug APK builds, but no emulator/phone run has confirmed the OS actually fires the notifications.

## Risk Assessment
- Android exact alarms restrictions: fall back to inexact with a warning if permission denied.
- Browser background throttling: document limitation; Notification still fires via worker check.

## Security Considerations
- No sensitive data; local storage only holds user's own recipe ids.

## Implementation Notes (deviations from the plan text)
- **Rounding:** g/ml round to 5 only from 5 upward; below 5 the step is 0.5 and a positive amount never becomes 0 (a halved 2 g pinch of salt stays 0.5 g, not 0). Pieces round to 0.5. A recipe shown at its own base servings is not rounded.
- **Aggregation:** sums unrounded scaled quantities per (ingredient, unit) and rounds only the total. Units are never converted client-side, so one ingredient in two units is two lines. Items sort by name then unit with plain code-unit comparison so TS and Dart agree.
- **Checked state** is keyed `ingredientId|unit` (not just ingredient id) for the same reason.
- **"Clear checked"** became two actions, because the aggregate is derived and a line cannot be deleted on its own: "Bỏ chọn hết" (untick all) and "Xóa danh sách" (remove every recipe, confirmed).
- **Web offline:** each grocery selection also keeps a snapshot of its recipe's ingredients in IndexedDB so the list renders without the network. There is no service worker, so the page shell itself still needs a connection to load.
- **Mobile exact alarms:** the app declares `SCHEDULE_EXACT_ALARM` and does not auto-open settings; if the OS denies it, notifications use inexact mode and the Timers screen shows a banner with an "allow" button.
- **Mobile share** uses `share_plus`; **web share** uses `navigator.share` with a clipboard fallback.
- **Mobile dock** lives in a `ShellRoute` around the signed-in screens and sits bottom-left so it clears the add-recipe button.
- Web signs out → wipes IndexedDB; mobile `AppDatabase.wipe()` already clears the new tables.

## Next Steps
Phase 07.
