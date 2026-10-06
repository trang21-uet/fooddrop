# Code Standards

## General

- YAGNI, KISS, DRY. Build what the current phase needs.
- Keep code files under ~200 lines; split by responsibility.
- File names describe purpose: `gacha-weighted-draw.service.ts`, `reel_tick_sound_player.dart`.
- Handle errors explicitly; never swallow exceptions silently.
- No secrets in code or git. Config comes from env vars validated at startup.
- Comments explain *why*, not *what*.

## Naming

| | TypeScript (web, backend) | Dart (mobile) |
|---|---|---|
| Files | kebab-case | snake_case (Dart requirement) |
| Types/classes | PascalCase | PascalCase |
| Variables/functions | camelCase | camelCase |
| Constants | UPPER_SNAKE_CASE for env/config | lowerCamelCase (Dart style) |
| DB tables/columns | snake_case | — |
| JSON over API | camelCase | camelCase |

## TypeScript

- `strict: true`. No `any`; use `unknown` and narrow.
- Validate all external input (HTTP bodies, LLM output, third-party APIs) with Zod.
- Prefer pure functions for domain logic (unit conversion, weighting, aggregation) so they are trivially unit-testable.

## Backend (NestJS)

- One feature per module folder: `src/modules/<feature>/` with `*.controller.ts`, `*.service.ts`, `*.schema.ts` (Zod/DTO), `*.spec.ts`.
- Controllers stay thin; logic lives in services or pure helpers.
- All DB access through Drizzle; raw SQL only in migrations or justified queries.
- Long-running work (AI parsing) goes through BullMQ, never inside the request.
- Rate-limit AI and gacha endpoints per user.

## Web (Next.js)

- Server Components by default; add `'use client'` only where interaction/animation is needed.
- Server data via TanStack Query; client-only state via Zustand slices (`use-timer-store.ts`, `use-grocery-store.ts`).
- Animate only `transform` and `opacity`.
- Feature folders under `src/features/<feature>/`; shared UI under `src/components/ui/`.

## Mobile (Flutter)

- Feature-first: `lib/features/<feature>/{data,domain,presentation}/`.
- Riverpod (code generation) for all state; no `setState` beyond local widget animation.
- Drift for local persistence; repositories hide local vs remote.
- `flutter analyze` must pass with zero warnings.

## Testing

| App | Unit | Integration/E2E |
|---|---|---|
| Backend | Vitest for services and pure helpers; oxlint for linting | Supertest against a test Postgres |
| Web | Vitest + Testing Library; ESLint for linting | Playwright for critical flows |
| Mobile | `flutter test`; `flutter analyze` for linting | `integration_test` for gacha + timer |

Required unit coverage: unit conversion, gacha weighting, grocery aggregation, portion scaling, timer remaining-time math.

## Git

- Conventional commits with scope: `feat(backend): add weighted gacha draw`.
- One logical change per commit. No AI references in commit messages.
- Lint + typecheck before commit; tests before push.
