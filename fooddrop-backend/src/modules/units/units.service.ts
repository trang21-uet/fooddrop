import { Inject, Injectable } from '@nestjs/common';
import { asc, inArray } from 'drizzle-orm';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { units } from '../../database/schema/index.js';

@Injectable()
export class UnitsService {
  constructor(@Inject(DRIZZLE) private readonly db: Database) {}

  list() {
    return this.db
      .select({ code: units.code, nameVi: units.nameVi, nameEn: units.nameEn, kind: units.kind })
      .from(units)
      .orderBy(asc(units.sortOrder), asc(units.code));
  }

  /** Conversion data for the given codes, keyed by code; unknown codes are simply absent. */
  async findByCodes(codes: string[]) {
    if (codes.length === 0) return new Map<string, typeof units.$inferSelect>();
    const rows = await this.db.select().from(units).where(inArray(units.code, codes));
    return new Map(rows.map((row) => [row.code, row]));
  }
}
