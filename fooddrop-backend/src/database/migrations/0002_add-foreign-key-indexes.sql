CREATE INDEX "accounts_user_idx" ON "accounts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "sessions_user_idx" ON "sessions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "recipe_ingredients_ingredient_idx" ON "recipe_ingredients" USING btree ("ingredient_id");--> statement-breakpoint
CREATE INDEX "gacha_spins_user_created_idx" ON "gacha_spins" USING btree ("user_id","created_at" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "lazy_options_user_idx" ON "lazy_options" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "parse_jobs_user_created_idx" ON "parse_jobs" USING btree ("user_id","created_at" DESC NULLS LAST);