# Phase 05 — AI Recipe Parser

## Context Links
- [plan.md](plan.md) · [system-architecture.md § Recipe parse](../../docs/system-architecture.md) · [fooddrop-backend/CLAUDE.md](../../fooddrop-backend/CLAUDE.md)

## Overview
- **Priority:** P1
- **Status:** Pending
- Paste a URL or upload a cookbook photo → editable recipe draft with normalized units.

## Key Insights
- Many food blogs already embed `schema.org/Recipe` JSON-LD: parse it first (free, fast, accurate). LLM is the fallback.
- LLM extracts; code converts. Arithmetic by the LLM is unreliable.
- Use Claude tool use with a strict input schema to force structured output; validate again with Zod.

## Requirements
- Functional: `POST /parser/jobs` (url or uploaded image key), `GET /parser/jobs/:id`; result = `{title, totalMinutes, servings, difficultyGuess, ingredients[{name, qty, unit, note}], steps[{text, timerSeconds?}], suggestedTags[]}`; ingredients matched to catalog or flagged as new.
- Non-functional: URL p50 < 10s, image p50 < 20s; ≥85% success on a 30-source test set (vi + en blogs, photos).

## Architecture
`parser` module: controller enqueues → BullMQ `recipe-parse` worker → `url-fetcher` (SSRF-safe) → `json-ld-recipe-extractor` → else `readability-cleaner` + `claude-recipe-extractor` → `units.normalize` → `ingredient-matcher` → save `parse_jobs.result`.

## Related Code Files
- Create: `src/modules/parser/{parser.controller,parser.service,parse-job.worker,url-fetcher,json-ld-recipe-extractor,readability-cleaner,claude-recipe-extractor,ingredient-matcher}.ts`, `src/modules/media/**`
- Web: `src/features/parser/**`; Mobile: `lib/features/parser/**`

## Implementation Steps
1. Media module: signed PUT URL for image uploads (S3/R2), max 10MB, image MIME only.
2. SSRF-safe fetcher: http/https only, DNS resolve and block private ranges, 5MB cap, 10s timeout.
3. JSON-LD extractor (handle `@graph`, arrays, ISO-8601 durations).
4. Claude extractor: `PARSER_MODEL_TEXT` for HTML text, `PARSER_MODEL_VISION` for images; tool `save_recipe` with JSON schema; system prompt: ignore stories/ads, keep original units, Vietnamese or English.
5. Normalize via `units`, match ingredients (exact/alias/trigram), compute draft.
6. Client UI: input (URL or photo/camera), progress state, editable draft prefilled into the recipe form, save.
7. Test set: 30 fixtures stored as HTML/images; snapshot tests for JSON-LD path; live eval script for LLM path (not in CI).

## Todo List
- [ ] Media upload
- [ ] SSRF-safe fetcher
- [ ] JSON-LD extractor + tests
- [ ] Claude extractor + Zod validation
- [ ] Normalization + matching
- [ ] Web UI
- [ ] Mobile UI (incl. camera)
- [ ] Eval on 30 sources

## Success Criteria
- ≥85% of test sources produce a savable draft with no manual unit fixes.

## Risk Assessment
- Sites block scrapers: show clear error and offer "paste text" fallback.
- LLM cost: cache by URL hash; per-user daily quota.

## Security Considerations
- SSRF protection; prompt-injection in page text cannot trigger actions (LLM has only the one extraction tool); API key server-side only.

## Next Steps
Feeds Phase 06 (grocery needs normalized ingredients).
