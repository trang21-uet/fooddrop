CREATE TABLE "units" (
	"code" text PRIMARY KEY NOT NULL,
	"name_vi" text NOT NULL,
	"name_en" text NOT NULL,
	"kind" text NOT NULL,
	"to_base" numeric,
	"sort_order" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "units_kind_check" CHECK ("units"."kind" IN ('mass','volume','count','other')),
	CONSTRAINT "units_to_base_check" CHECK ("units"."to_base" IS NULL OR "units"."to_base" > 0)
);
--> statement-breakpoint
-- Existing lines point at g / ml. `db:seed` upserts the full catalog; these two rows only have to exist for the foreign key.
INSERT INTO "units" ("code", "name_vi", "name_en", "kind", "to_base", "sort_order") VALUES
	('g', 'g', 'g', 'mass', 1, 0),
	('ml', 'ml', 'ml', 'volume', 1, 3)
ON CONFLICT ("code") DO NOTHING;--> statement-breakpoint
ALTER TABLE "recipe_ingredients" DROP CONSTRAINT "recipe_ingredients_unit_check";--> statement-breakpoint
ALTER TABLE "recipe_ingredients" DROP CONSTRAINT "recipe_ingredients_quantity_check";--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ALTER COLUMN "quantity" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ALTER COLUMN "unit" DROP NOT NULL;--> statement-breakpoint
-- A bare count used to be stored as 'piece'; it is now a quantity without a unit and shows as "2".
UPDATE "recipe_ingredients" SET "unit" = NULL WHERE "unit" = 'piece';--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ADD CONSTRAINT "recipe_ingredients_unit_units_code_fk" FOREIGN KEY ("unit") REFERENCES "public"."units"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "recipe_ingredients_unit_idx" ON "recipe_ingredients" USING btree ("unit");--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ADD CONSTRAINT "recipe_ingredients_unit_needs_quantity_check" CHECK ("recipe_ingredients"."unit" IS NULL OR "recipe_ingredients"."quantity" IS NOT NULL);--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ADD CONSTRAINT "recipe_ingredients_quantity_check" CHECK ("recipe_ingredients"."quantity" IS NULL OR "recipe_ingredients"."quantity" >= 0);