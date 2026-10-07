# Database Schema

PostgreSQL 17, managed with Drizzle migrations in `fooddrop-backend/src/database/`. This file is the design reference; the Drizzle schema is the source of truth once implemented.

## Entity overview

```
users ─┬─< recipes ─┬─< recipe_ingredients >── ingredients
       │            ├─< recipe_tags >── tags >── tag_dimensions
       │            └─< gacha_spins
       ├─< lazy_options
       └─< parse_jobs
tags ─< weather_boosts
```

## Tables

```sql
-- Owned by Better Auth (name -> display_name). sessions, accounts and verifications
-- follow Better Auth's model with uuid ids; see src/database/schema/users.schema.ts.
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  email_verified boolean NOT NULL DEFAULT false,
  display_name text NOT NULL DEFAULT '',
  image text,
  locale text NOT NULL DEFAULT 'vi',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Canonical ingredients: drives grocery aggregation and ingredient tags
CREATE TABLE ingredients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  aliases text[] NOT NULL DEFAULT '{}',   -- "hành lá", "scallion", "green onion"
  aisle text NOT NULL,                     -- produce | meat | seafood | dairy | pantry | spices | frozen | other
  default_unit text NOT NULL DEFAULT 'g',  -- g | ml | piece; unit used when summing across recipes
  density_g_per_ml numeric,                -- for ml <-> g conversion
  is_fermented boolean NOT NULL DEFAULT false
);

CREATE TABLE recipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES users ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  image_url text,
  base_servings int NOT NULL DEFAULT 2 CHECK (base_servings > 0),
  total_minutes int NOT NULL CHECK (total_minutes > 0),
  difficulty smallint NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
  rarity text GENERATED ALWAYS AS (
    CASE WHEN total_minutes <= 20  AND difficulty <= 1 THEN 'white'
         WHEN total_minutes <= 45  AND difficulty <= 2 THEN 'blue'
         WHEN total_minutes <= 90  AND difficulty <= 3 THEN 'purple'
         WHEN total_minutes <= 180 THEN 'pink'
         ELSE 'red' END) STORED,
  steps jsonb NOT NULL,                    -- [{order, text, timerSeconds?, timerLabel?}]
  source_url text,
  raw_extract jsonb,                       -- original parser output for debugging / re-parse
  created_at timestamptz(3) NOT NULL DEFAULT now(),   -- ms precision: keyset cursors round-trip through JS Dates
  updated_at timestamptz(3) NOT NULL DEFAULT now()
);
CREATE INDEX recipes_owner_rarity_idx ON recipes (owner_id, rarity);
CREATE INDEX recipes_owner_created_idx ON recipes (owner_id, created_at DESC, id DESC);

CREATE TABLE recipe_ingredients (
  recipe_id uuid NOT NULL REFERENCES recipes ON DELETE CASCADE,
  ingredient_id uuid NOT NULL REFERENCES ingredients,
  quantity numeric NOT NULL CHECK (quantity >= 0),
  unit text NOT NULL CHECK (unit IN ('g','ml','piece')),
  note text,                               -- "thái nhỏ", "tùy chọn"
  sort_order int NOT NULL DEFAULT 0,
  PRIMARY KEY (recipe_id, ingredient_id)
);

-- Multi-dimension tagging
CREATE TABLE tag_dimensions (
  id serial PRIMARY KEY,
  slug text UNIQUE NOT NULL,               -- cuisine | equipment | meal_type | technique | diet
  label text NOT NULL
);
CREATE TABLE tags (
  id serial PRIMARY KEY,
  dimension_id int NOT NULL REFERENCES tag_dimensions,
  slug text NOT NULL,
  label text NOT NULL,
  UNIQUE (dimension_id, slug)
);
CREATE TABLE recipe_tags (
  recipe_id uuid NOT NULL REFERENCES recipes ON DELETE CASCADE,
  tag_id int NOT NULL REFERENCES tags,
  PRIMARY KEY (recipe_id, tag_id)
);
CREATE INDEX recipe_tags_tag_idx ON recipe_tags (tag_id, recipe_id);

-- Context boosts for the gacha
CREATE TABLE weather_boosts (
  tag_id int NOT NULL REFERENCES tags,
  condition text NOT NULL CHECK (condition IN ('rain','cold','hot','clear')),
  weight_multiplier numeric NOT NULL DEFAULT 1.5,
  PRIMARY KEY (tag_id, condition)
);

-- Lazy case options (user-defined; Places results are not persisted)
CREATE TABLE lazy_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users ON DELETE CASCADE,
  kind text NOT NULL CHECK (kind IN ('delivery','restaurant','custom')),
  name text NOT NULL,
  deep_link text,
  place_id text
);

CREATE TABLE gacha_spins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users ON DELETE CASCADE,
  case_type text NOT NULL CHECK (case_type IN ('cook','lazy')),
  result_recipe_id uuid REFERENCES recipes ON DELETE SET NULL,
  result_lazy_payload jsonb,
  context jsonb,                           -- {weather, appliedBoosts}
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE parse_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users ON DELETE CASCADE,
  source_type text NOT NULL CHECK (source_type IN ('url','image')),
  source text NOT NULL,                    -- URL or storage key
  status text NOT NULL DEFAULT 'queued' CHECK (status IN ('queued','running','succeeded','failed')),
  result jsonb,
  error text,
  created_at timestamptz NOT NULL DEFAULT now()
);
```

## Design notes

- **Tag dimensions** let the UI filter by group (`equipment = air-fryer AND cuisine = japanese`) while staying more flexible than folders.
- **Ingredients are relational; steps are JSONB.** Ingredients must be joined and summed for the grocery list. Steps are always read as a whole and carry optional timers for Multi-Timer.
- **Rarity is a generated column**, so thresholds change in one place. Move it to app code if it ever needs per-user tuning.
- **Gacha weight:** `rarityWeight(rarity) × Π weather_boosts.weight_multiplier` for matching tags; draw server-side.
- **Portion scaling** is `quantity × servings / base_servings`, computed client-side; round g/ml to 5 (to 0.5 below 5, never to 0), pieces to 0.5. Vectors: `docs/fixtures/portion-scaling-cases.json`.
- **Normalization:** the units module maps raw `{qty, unit}` to g/ml/piece and, using `density_g_per_ml` and `default_unit`, converts mass↔volume so one ingredient sums in one unit. Unknown units become `piece` with the original wording in `note`.
- **Quantity parsing:** a comma followed by exactly three digits is a thousands separator ("1,000" = 1000); any other comma is a decimal ("1,5" = 1.5). A bare "oz" means fluid ounces for ingredients whose default unit is ml. An unknown unit stores quantity 0 in the ingredient's default unit with the original wording in `note`, so it never inflates aggregated totals.
- **Indexes:** every `user_id` / `ingredient_id` foreign key that is queried or cascaded has an index (migration `0002_add-foreign-key-indexes`).
- **Search:** diacritic-insensitive matching uses the `unaccent` extension (migration `0001_enable-unaccent`).
- **Ingredients are a shared catalog:** user-added entries (`POST /ingredients`) are visible to everyone; there is no owner column.
- **Seed data:** tag dimensions, common tags (Vietnamese, Japanese, Korean; air fryer, pressure cooker, oven; breakfast/lunch/dinner; fermented), ~200 common ingredients with aisle and density.
