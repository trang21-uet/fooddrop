# fooddrop-web

Web client của Food Drop.

**Stack:** Next.js 15 (App Router) · React 19 · TypeScript · Tailwind CSS · TanStack Query · Zustand · GSAP/Motion · Web Audio API · Dexie

## Yêu cầu

- Node.js 22+, pnpm
- `fooddrop-backend` đang chạy ở http://localhost:4000

## Chạy local

```bash
cp .env.example .env.local   # API_INTERNAL_URL (default http://localhost:4000)
pnpm install
pnpm api:generate   # sinh client từ ../fooddrop-backend/openapi.json
pnpm dev
```

Mở http://localhost:3000.

## Scripts

| Script | Mô tả |
|---|---|
| `pnpm dev` | Dev server |
| `pnpm build` / `pnpm start` | Build và chạy production |
| `pnpm api:generate` | Sinh API client TS từ OpenAPI |
| `pnpm lint` / `pnpm typecheck` / `pnpm test` | Kiểm tra chất lượng |
| `pnpm test:e2e` | Playwright (spec `recipe-hub` cần backend + DB đã seed, tự skip nếu không có) |

## Cấu trúc

```
src/
├── app/                    # Routes (App Router)
├── features/
│   ├── recipes/
│   ├── parser/
│   ├── gacha/              # Reel, tick sound, reveal
│   ├── grocery/
│   └── timers/
├── components/ui/          # Thành phần dùng chung
├── lib/api/                # Client sinh từ OpenAPI
└── stores/                 # Zustand stores
public/
├── favicon.ico
├── apple-touch-icon.png
├── icon-192.png
├── icon-512.png
└── sounds/                 # Tick, reveal (âm thanh tự làm/có license)
```

## Logo

Favicon và icon PWA đã được xuất sẵn vào `public/` từ `../assets/brand/`.
