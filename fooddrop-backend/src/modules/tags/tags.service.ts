import { Inject, Injectable } from '@nestjs/common';
import { asc, eq } from 'drizzle-orm';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { tagDimensions, tags } from '../../database/schema/index.js';
import type { z } from 'zod';
import type { tagDimensionSchema } from './tags.schemas.js';

@Injectable()
export class TagsService {
  constructor(@Inject(DRIZZLE) private readonly db: Database) {}

  /** The catalog is global and small (5 dimensions, <100 tags), so one join, grouped in memory. */
  async listDimensions(): Promise<z.output<typeof tagDimensionSchema>[]> {
    const rows = await this.db
      .select({
        dimensionId: tagDimensions.id,
        dimensionSlug: tagDimensions.slug,
        dimensionLabel: tagDimensions.label,
        tagId: tags.id,
        tagSlug: tags.slug,
        tagLabel: tags.label,
      })
      .from(tagDimensions)
      .leftJoin(tags, eq(tags.dimensionId, tagDimensions.id))
      .orderBy(asc(tagDimensions.id), asc(tags.id));

    const grouped = new Map<number, z.output<typeof tagDimensionSchema>>();
    for (const row of rows) {
      let dimension = grouped.get(row.dimensionId);
      if (!dimension) {
        dimension = { id: row.dimensionId, slug: row.dimensionSlug, label: row.dimensionLabel, tags: [] };
        grouped.set(row.dimensionId, dimension);
      }
      if (row.tagId !== null) {
        dimension.tags.push({ id: row.tagId, slug: row.tagSlug!, label: row.tagLabel! });
      }
    }
    return [...grouped.values()];
  }
}
