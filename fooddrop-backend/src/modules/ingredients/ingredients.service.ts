import { ConflictException, Inject, Injectable } from '@nestjs/common';
import { sql } from 'drizzle-orm';
import type { z } from 'zod';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { ingredients } from '../../database/schema/index.js';
import type { createIngredientSchema, ingredientSchema } from './ingredients.schemas.js';

type IngredientView = z.output<typeof ingredientSchema>;

const escapeLike = (text: string): string => text.replace(/[\\%_]/g, '\\$&');

// Diacritic- and case-insensitive match ("hanh la" finds "Hành lá"); relies on the unaccent extension.
const foldedMatch = (column: ReturnType<typeof sql>, pattern: string) =>
  sql`unaccent(${column}) ILIKE unaccent(${pattern})`;

@Injectable()
export class IngredientsService {
  constructor(@Inject(DRIZZLE) private readonly db: Database) {}

  async search(query: string | undefined, limit: number): Promise<IngredientView[]> {
    const term = query?.trim();
    if (!term) {
      return this.db.select().from(ingredients).orderBy(ingredients.name).limit(limit);
    }
    const contains = `%${escapeLike(term)}%`;
    const prefix = `${escapeLike(term)}%`;
    const aliasText = sql`array_to_string(${ingredients.aliases}, ' ')`;
    return this.db
      .select()
      .from(ingredients)
      .where(sql`(${foldedMatch(sql`${ingredients.name}`, contains)} OR ${foldedMatch(aliasText, contains)})`)
      // Prefix hits on the name rank first so "hanh" lists "Hành lá" before "Rau hành".
      .orderBy(sql`${foldedMatch(sql`${ingredients.name}`, prefix)} DESC`, ingredients.name)
      .limit(limit);
  }

  async create(input: z.output<typeof createIngredientSchema>): Promise<IngredientView> {
    const existing = await this.db
      .select({ id: ingredients.id })
      .from(ingredients)
      .where(
        sql`lower(unaccent(${ingredients.name})) = lower(unaccent(${input.name}))
          OR EXISTS (SELECT 1 FROM unnest(${ingredients.aliases}) AS alias
                     WHERE lower(unaccent(alias)) = lower(unaccent(${input.name})))`,
      )
      .limit(1);
    if (existing.length > 0) throw new ConflictException(`Ingredient "${input.name}" already exists`);

    try {
      const [created] = await this.db.insert(ingredients).values(input).returning();
      return created!;
    } catch (error) {
      // Two concurrent requests can both pass the check above; the unique index decides.
      if ((error as { code?: string }).code === '23505') {
        throw new ConflictException(`Ingredient "${input.name}" already exists`);
      }
      throw error;
    }
  }
}
