#!/usr/bin/env bash
# Regenerates the Dart (dio) API client from the backend OpenAPI contract.
# Needs Java 11+ on PATH (or JAVA_HOME) and Node for npx.
# Run from fooddrop-mobile/ after `pnpm openapi:generate` in fooddrop-backend/.
set -euo pipefail

cd "$(dirname "$0")/.."
OUT_DIR=packages/fooddrop_api
SPEC="$(mktemp -d)/openapi.json"

# Shapes dart-dio cannot generate valid code for, normalized before generation:
#  - `quantity` is number | string (anyOf of primitives). The app always sends the raw text
#    ("1 1/2") and the backend parses it, so narrow it to string.
#  - enum and array properties with a `default` emit non-compilable `const Enum._('x')` / `= []`.
#    The backend applies those defaults itself, so drop them from the spec the client is built from.
node -e '
const fs = require("fs");
const spec = JSON.parse(fs.readFileSync("../fooddrop-backend/openapi.json", "utf8"));
const schemas = spec.components.schemas;
schemas.RecipeInput.properties.ingredients.items.properties.quantity = { type: "string", minLength: 1, maxLength: 20 };
for (const schema of Object.values(schemas)) {
  for (const property of Object.values(schema.properties ?? {})) {
    if (property.enum || property.type === "array") delete property.default;
  }
}
fs.writeFileSync(process.argv[1], JSON.stringify(spec));
' "$SPEC"

rm -rf "$OUT_DIR"
npx --yes @openapitools/openapi-generator-cli generate \
  -i "$SPEC" \
  -g dart-dio \
  -o "$OUT_DIR" \
  --additional-properties=pubName=fooddrop_api,serializationLibrary=json_serializable

# Generated code uses null-aware elements (`?value`), which need language version 3.8+.
sed -i "s/sdk: '>=3.5.0 <4.0.0'/sdk: '>=3.8.0 <4.0.0'/" "$OUT_DIR/pubspec.yaml"

(cd "$OUT_DIR" && dart pub get && dart run build_runner build --delete-conflicting-outputs)
flutter pub get
