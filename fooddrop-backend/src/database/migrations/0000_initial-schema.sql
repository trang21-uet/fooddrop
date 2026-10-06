CREATE TABLE "accounts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"account_id" text NOT NULL,
	"provider_id" text NOT NULL,
	"access_token" text,
	"refresh_token" text,
	"id_token" text,
	"access_token_expires_at" timestamp with time zone,
	"refresh_token_expires_at" timestamp with time zone,
	"scope" text,
	"password" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sessions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"token" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"ip_address" text,
	"user_agent" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "sessions_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"email" text NOT NULL,
	"email_verified" boolean DEFAULT false NOT NULL,
	"display_name" text DEFAULT '' NOT NULL,
	"image" text,
	"locale" text DEFAULT 'vi' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "verifications" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"identifier" text NOT NULL,
	"value" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ingredients" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"aliases" text[] DEFAULT '{}'::text[] NOT NULL,
	"aisle" text NOT NULL,
	"default_unit" text DEFAULT 'g' NOT NULL,
	"density_g_per_ml" numeric,
	"is_fermented" boolean DEFAULT false NOT NULL,
	CONSTRAINT "ingredients_name_unique" UNIQUE("name"),
	CONSTRAINT "ingredients_aisle_check" CHECK ("ingredients"."aisle" IN ('produce','meat','seafood','dairy','pantry','spices','frozen','other')),
	CONSTRAINT "ingredients_default_unit_check" CHECK ("ingredients"."default_unit" IN ('g','ml','piece'))
);
--> statement-breakpoint
CREATE TABLE "recipe_ingredients" (
	"recipe_id" uuid NOT NULL,
	"ingredient_id" uuid NOT NULL,
	"quantity" numeric NOT NULL,
	"unit" text NOT NULL,
	"note" text,
	"sort_order" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "recipe_ingredients_recipe_id_ingredient_id_pk" PRIMARY KEY("recipe_id","ingredient_id"),
	CONSTRAINT "recipe_ingredients_quantity_check" CHECK ("recipe_ingredients"."quantity" >= 0),
	CONSTRAINT "recipe_ingredients_unit_check" CHECK ("recipe_ingredients"."unit" IN ('g','ml','piece'))
);
--> statement-breakpoint
CREATE TABLE "recipes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"owner_id" uuid NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"image_url" text,
	"base_servings" integer DEFAULT 2 NOT NULL,
	"total_minutes" integer NOT NULL,
	"difficulty" smallint NOT NULL,
	"rarity" text GENERATED ALWAYS AS (CASE WHEN total_minutes <= 20 AND difficulty <= 1 THEN 'white'
  WHEN total_minutes <= 45 AND difficulty <= 2 THEN 'blue'
  WHEN total_minutes <= 90 AND difficulty <= 3 THEN 'purple'
  WHEN total_minutes <= 180 THEN 'pink'
  ELSE 'red' END) STORED NOT NULL,
	"steps" jsonb NOT NULL,
	"source_url" text,
	"raw_extract" jsonb,
	"created_at" timestamp (3) with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp (3) with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "recipes_base_servings_check" CHECK ("recipes"."base_servings" > 0),
	CONSTRAINT "recipes_total_minutes_check" CHECK ("recipes"."total_minutes" > 0),
	CONSTRAINT "recipes_difficulty_check" CHECK ("recipes"."difficulty" BETWEEN 1 AND 5)
);
--> statement-breakpoint
CREATE TABLE "recipe_tags" (
	"recipe_id" uuid NOT NULL,
	"tag_id" integer NOT NULL,
	CONSTRAINT "recipe_tags_recipe_id_tag_id_pk" PRIMARY KEY("recipe_id","tag_id")
);
--> statement-breakpoint
CREATE TABLE "tag_dimensions" (
	"id" serial PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"label" text NOT NULL,
	CONSTRAINT "tag_dimensions_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "tags" (
	"id" serial PRIMARY KEY NOT NULL,
	"dimension_id" integer NOT NULL,
	"slug" text NOT NULL,
	"label" text NOT NULL,
	CONSTRAINT "tags_dimension_slug_unique" UNIQUE("dimension_id","slug")
);
--> statement-breakpoint
CREATE TABLE "weather_boosts" (
	"tag_id" integer NOT NULL,
	"condition" text NOT NULL,
	"weight_multiplier" numeric DEFAULT 1.5 NOT NULL,
	CONSTRAINT "weather_boosts_tag_id_condition_pk" PRIMARY KEY("tag_id","condition"),
	CONSTRAINT "weather_boosts_condition_check" CHECK ("weather_boosts"."condition" IN ('rain','cold','hot','clear'))
);
--> statement-breakpoint
CREATE TABLE "gacha_spins" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"case_type" text NOT NULL,
	"result_recipe_id" uuid,
	"result_lazy_payload" jsonb,
	"context" jsonb,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "gacha_spins_case_type_check" CHECK ("gacha_spins"."case_type" IN ('cook','lazy'))
);
--> statement-breakpoint
CREATE TABLE "lazy_options" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"name" text NOT NULL,
	"deep_link" text,
	"place_id" text,
	CONSTRAINT "lazy_options_kind_check" CHECK ("lazy_options"."kind" IN ('delivery','restaurant','custom'))
);
--> statement-breakpoint
CREATE TABLE "parse_jobs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"source_type" text NOT NULL,
	"source" text NOT NULL,
	"status" text DEFAULT 'queued' NOT NULL,
	"result" jsonb,
	"error" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "parse_jobs_source_type_check" CHECK ("parse_jobs"."source_type" IN ('url','image')),
	CONSTRAINT "parse_jobs_status_check" CHECK ("parse_jobs"."status" IN ('queued','running','succeeded','failed'))
);
--> statement-breakpoint
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ADD CONSTRAINT "recipe_ingredients_recipe_id_recipes_id_fk" FOREIGN KEY ("recipe_id") REFERENCES "public"."recipes"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recipe_ingredients" ADD CONSTRAINT "recipe_ingredients_ingredient_id_ingredients_id_fk" FOREIGN KEY ("ingredient_id") REFERENCES "public"."ingredients"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recipes" ADD CONSTRAINT "recipes_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recipe_tags" ADD CONSTRAINT "recipe_tags_recipe_id_recipes_id_fk" FOREIGN KEY ("recipe_id") REFERENCES "public"."recipes"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "recipe_tags" ADD CONSTRAINT "recipe_tags_tag_id_tags_id_fk" FOREIGN KEY ("tag_id") REFERENCES "public"."tags"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tags" ADD CONSTRAINT "tags_dimension_id_tag_dimensions_id_fk" FOREIGN KEY ("dimension_id") REFERENCES "public"."tag_dimensions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "weather_boosts" ADD CONSTRAINT "weather_boosts_tag_id_tags_id_fk" FOREIGN KEY ("tag_id") REFERENCES "public"."tags"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "gacha_spins" ADD CONSTRAINT "gacha_spins_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "gacha_spins" ADD CONSTRAINT "gacha_spins_result_recipe_id_recipes_id_fk" FOREIGN KEY ("result_recipe_id") REFERENCES "public"."recipes"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "lazy_options" ADD CONSTRAINT "lazy_options_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "parse_jobs" ADD CONSTRAINT "parse_jobs_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "recipes_owner_rarity_idx" ON "recipes" USING btree ("owner_id","rarity");--> statement-breakpoint
CREATE INDEX "recipes_owner_created_idx" ON "recipes" USING btree ("owner_id","created_at" DESC NULLS LAST,"id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "recipe_tags_tag_idx" ON "recipe_tags" USING btree ("tag_id","recipe_id");