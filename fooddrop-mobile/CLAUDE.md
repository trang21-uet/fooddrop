# CLAUDE.md — fooddrop-mobile

Read the root `../CLAUDE.md` and `../docs/code-standards.md` first.

## App identity

- Name: **Food Drop**
- Android `applicationId` / iOS bundle id: **com.trangnx.fooddrop**
- Icons generated from `assets/icon/` via `flutter_launcher_icons`.

## Stack

Flutter 3.44, Riverpod (with `riverpod_generator`), Drift, Dio + OpenAPI-generated Dart client, go_router, flutter_soloud, flutter_local_notifications, Rive.

## Commands

```bash
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000
bash tool/generate-api-client.sh   # after backend openapi.json changes (needs Java 11+, Node)
```

The API client is the generated path package `packages/fooddrop_api` (dart-dio); `lib/core/api/api_client_provider.dart` exposes it. Never edit the package by hand.

`flutter analyze` must be clean and `flutter test` must pass after every change.

## Structure rules

- Feature-first: `lib/features/<feature>/{data,domain,presentation}/`.
- Dart files are snake_case (language requirement); keep them under ~200 lines.
- Generated files (`*.g.dart`, `*.freezed.dart`, API client) are never edited by hand.
- Config via `--dart-define`; no secrets in the app bundle.

## State rules

- Server data: `AsyncNotifier` providers. Client logic: `Notifier` providers. Persistence: Drift.
- **Local-first** for recipes, grocery list and timers: write to Drift first, sync in background.
- **Timers:** store `endsAt`; one `Stream.periodic` ticker provider drives the UI; schedule a `flutter_local_notifications` zoned notification at `endsAt` because the OS suspends background isolates. Restore timers from Drift on launch.
- **Grocery list:** persist `{recipeId, servings}` and checked ingredient ids only; aggregated list is a derived provider.
- **Gacha:** provider holds `status` + spin response; reel position stays in the `AnimationController`.

## Gacha reel

- `AnimationController` (6–8s) + `CurvedAnimation(curve: Cubic(0.1, 0.7, 0.1, 1))` driving `Transform.translate` on a strip of ~70 cards inside a `ClipRect`.
- In the listener compute `(offset / cardWidth).floor()`; when it changes, play the tick via `flutter_soloud` (preloaded) and fire `HapticFeedback.selectionClick()`.
- Wrap the reel in a `RepaintBoundary`; avoid rebuilding cards per frame.
- Reveal effect by rarity with Rive/Lottie. Original or licensed sounds only; no Valve assets.
