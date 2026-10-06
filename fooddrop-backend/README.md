# fooddrop-backend

REST API và background workers cho Food Drop.

**Stack:** NestJS · TypeScript · Drizzle ORM · PostgreSQL 17 · Redis 7 + BullMQ · Zod · Claude API

## Yêu cầu

- Node.js 22+, pnpm
- Docker (Postgres và Redis qua `docker-compose.yml` ở thư mục gốc)

## Chạy local

```bash
docker compose -f ../docker-compose.yml up -d
cp .env.example .env
pnpm install
pnpm db:migrate
pnpm db:seed
pnpm start:dev
```

- API: http://localhost:4000
- Swagger UI: http://localhost:4000/docs
- OpenAPI JSON: `openapi.json` (sinh bằng `pnpm openapi:generate`)

## Scripts (dự kiến sau Phase 01)

| Script | Mô tả |
|---|---|
| `pnpm start:dev` | Chạy API ở chế độ watch |
| `pnpm worker:dev` | Chạy BullMQ worker (parser) |
| `pnpm db:generate` | Sinh migration từ Drizzle schema |
| `pnpm db:migrate` | Chạy migration |
| `pnpm db:seed` | Seed tag, ingredient, weather boost |
| `pnpm openapi:generate` | Xuất `openapi.json` cho web/mobile |
| `pnpm lint` / `pnpm typecheck` / `pnpm test` | Kiểm tra chất lượng |

## Cấu trúc

```
src/
├── main.ts
├── app.module.ts
├── config/                 # Env validation (Zod)
├── database/               # Drizzle schema, migrations, seed
├── common/                 # Guards, filters, interceptors, pipes
└── modules/
    ├── auth/
    ├── recipes/
    ├── tags/
    ├── ingredients/
    ├── units/              # Quy đổi đơn vị deterministic
    ├── parser/             # JSON-LD + Claude, BullMQ worker
    ├── gacha/              # Weighted draw, reel builder
    ├── context/            # Open-Meteo, Google Places
    ├── grocery/
    └── media/              # Signed upload URL (S3/R2)
```

## Biến môi trường

Xem [.env.example](.env.example). Không commit file `.env`.
