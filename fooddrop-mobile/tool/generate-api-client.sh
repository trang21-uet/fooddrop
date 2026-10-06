#!/usr/bin/env bash
# Regenerates the Dart (dio) API client from the backend OpenAPI contract.
# Needs Java 11+ on PATH (or JAVA_HOME) and Node for npx.
# Run from fooddrop-mobile/ after `pnpm openapi:generate` in fooddrop-backend/.
set -euo pipefail

cd "$(dirname "$0")/.."
OUT_DIR=packages/fooddrop_api

rm -rf "$OUT_DIR"
npx --yes @openapitools/openapi-generator-cli generate \
  -i ../fooddrop-backend/openapi.json \
  -g dart-dio \
  -o "$OUT_DIR" \
  --additional-properties=pubName=fooddrop_api,serializationLibrary=json_serializable

(cd "$OUT_DIR" && dart pub get && dart run build_runner build --delete-conflicting-outputs)
flutter pub get
