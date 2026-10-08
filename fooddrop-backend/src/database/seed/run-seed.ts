import { existsSync } from 'node:fs';
import { drizzle } from 'drizzle-orm/node-postgres';
import { sql } from 'drizzle-orm';
import { Pool } from 'pg';
import * as schema from '../schema/index.js';
import { SEED_FRESH_INGREDIENTS } from './seed-ingredients-fresh.js';
import { SEED_PANTRY_INGREDIENTS } from './seed-ingredients-pantry.js';
import { SEED_TAG_DIMENSIONS } from './seed-tags.js';
import { SEED_UNITS } from './seed-units.js';

// CI passes DATABASE_URL directly; locally it comes from .env.
if (existsSync('.env')) process.loadEnvFile();

// Idempotent: re-running updates catalog rows in place and never touches user data.
async function seed(): Promise<void> {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error('DATABASE_URL is required to seed');
  const pool = new Pool({ connectionString: url });
  const db = drizzle(pool, { schema });

  try {
    await db.transaction(async (tx) => {
      for (const dimension of SEED_TAG_DIMENSIONS) {
        const [row] = await tx
          .insert(schema.tagDimensions)
          .values({ slug: dimension.slug, label: dimension.label })
          .onConflictDoUpdate({
            target: schema.tagDimensions.slug,
            set: { label: dimension.label },
          })
          .returning({ id: schema.tagDimensions.id });
        if (!row) throw new Error(`Failed to upsert dimension ${dimension.slug}`);

        await tx
          .insert(schema.tags)
          .values(
            dimension.tags.map(([slug, label]) => ({ dimensionId: row.id, slug, label })),
          )
          .onConflictDoUpdate({
            target: [schema.tags.dimensionId, schema.tags.slug],
            set: { label: sql`excluded.label` },
          });
      }

      await tx
        .insert(schema.units)
        .values(
          SEED_UNITS.map(([code, nameVi, nameEn, kind, toBase], sortOrder) => ({
            code,
            nameVi,
            nameEn,
            kind,
            toBase,
            sortOrder,
          })),
        )
        .onConflictDoUpdate({
          target: schema.units.code,
          set: {
            nameVi: sql`excluded.name_vi`,
            nameEn: sql`excluded.name_en`,
            kind: sql`excluded.kind`,
            toBase: sql`excluded.to_base`,
            sortOrder: sql`excluded.sort_order`,
          },
        });

      const catalog = [...SEED_FRESH_INGREDIENTS, ...SEED_PANTRY_INGREDIENTS];
      for (let i = 0; i < catalog.length; i += 100) {
        await tx
          .insert(schema.ingredients)
          .values(
            catalog.slice(i, i + 100).map(
              ([name, aliases, aisle, defaultUnit, densityGPerMl, isFermented]) => ({
                name,
                aliases,
                aisle,
                defaultUnit,
                densityGPerMl: densityGPerMl ?? null,
                isFermented: isFermented ?? false,
              }),
            ),
          )
          .onConflictDoUpdate({
            target: schema.ingredients.name,
            set: {
              aliases: sql`excluded.aliases`,
              aisle: sql`excluded.aisle`,
              defaultUnit: sql`excluded.default_unit`,
              densityGPerMl: sql`excluded.density_g_per_ml`,
              isFermented: sql`excluded.is_fermented`,
            },
          });
      }
    });
    console.log(
      `Seeded ${SEED_UNITS.length} units, ${SEED_TAG_DIMENSIONS.length} tag dimensions and ${SEED_FRESH_INGREDIENTS.length + SEED_PANTRY_INGREDIENTS.length} ingredients`,
    );
  } finally {
    await pool.end();
  }
}

await seed();
