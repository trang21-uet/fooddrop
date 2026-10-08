-- The old normalizer stored an unconvertible unit ("1 handful") as quantity 0 in the ingredient's
-- default unit with the original wording in the note. Lines may now simply have no amount, so show
-- those as the note alone instead of "0 g".
UPDATE "recipe_ingredients" SET "quantity" = NULL, "unit" = NULL WHERE "quantity" = 0 AND "note" IS NOT NULL;
