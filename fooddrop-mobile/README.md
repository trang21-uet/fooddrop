# fooddrop-mobile

App Android/iOS của Food Drop.

- **Package / Bundle ID:** `com.trangnx.fooddrop`
- **Stack:** Flutter 3.44 · Riverpod · Drift (SQLite) · Dio · flutter_soloud · flutter_local_notifications · Rive

## Yêu cầu

- Flutter 3.44+ (Dart 3.12+)
- Android Studio / Xcode
- `fooddrop-backend` đang chạy (Android emulator dùng `http://10.0.2.2:4000`)

## Chạy local

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000
```

## Lệnh thường dùng

| Lệnh | Mô tả |
|---|---|
| `flutter analyze` | Lint |
| `flutter test` | Unit/widget test |
| `dart run build_runner watch` | Sinh code Riverpod/Drift/API client |
| `bash tool/generate-api-client.sh` | Sinh lại API client từ `openapi.json` (cần JDK 11+) |
| `dart run flutter_launcher_icons` | Sinh icon từ `assets/icon/` |

## Cấu trúc

```
lib/
├── main.dart
├── app/                    # Router, theme, bootstrap
├── core/                   # API client sinh từ OpenAPI, DB Drift, utils
└── features/
    ├── recipes/
    ├── parser/
    ├── gacha/              # Reel, tick player, reveal
    ├── grocery/
    └── timers/
assets/
├── icon/app-icon.png               # 1024x1024, icon iOS/Android
├── icon/app-icon-foreground.png    # foreground cho Android adaptive icon
└── sounds/
```

## Logo

Icon nguồn nằm trong `assets/icon/`. Cấu hình `flutter_launcher_icons` được thêm ở Phase 01.
