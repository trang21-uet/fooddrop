import {
  BadRequestException,
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  Logger,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { and, eq, gt, sql } from 'drizzle-orm';
import type { z } from 'zod';
import type { Env } from '../../config/env.schema.js';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { parseJobs } from '../../database/schema/index.js';
import { userUploadPrefix } from '../media/object-storage.service.js';
import { ParseCooldown } from './parse-cooldown.js';
import type { ParseErrorCode } from './parse-job-error.js';
import { ParseQueue } from './parse-queue.js';
import type { ParsedRecipeDraft, ParseJobView, createParseJobSchema } from './parser.schemas.js';

type CreateParseJob = z.output<typeof createParseJobSchema>;
type ParseJobRow = typeof parseJobs.$inferSelect;

export const toParseJobView = (row: ParseJobRow, cooldownSeconds: number): ParseJobView => ({
  id: row.id,
  status: row.status,
  sourceType: row.sourceType,
  errorCode: (row.error as ParseErrorCode | null) ?? null,
  result: (row.result as ParsedRecipeDraft | null) ?? null,
  createdAt: row.createdAt.toISOString(),
  cooldownSeconds,
});

@Injectable()
export class ParserService {
  private readonly logger = new Logger(ParserService.name);
  private readonly dailyQuota: number;

  constructor(
    @Inject(DRIZZLE) private readonly db: Database,
    private readonly queue: ParseQueue,
    private readonly cooldown: ParseCooldown,
    config: ConfigService<Env, true>,
  ) {
    this.dailyQuota = config.get('PARSER_DAILY_QUOTA', { infer: true });
  }

  async createJob(userId: string, input: CreateParseJob): Promise<ParseJobView> {
    const [sourceType, source] = input.url ? (['url', input.url] as const) : (['image', input.imageKey!] as const);
    // The key is only a pointer into shared storage, so it must live under the caller's own prefix.
    if (sourceType === 'image' && (!source.startsWith(userUploadPrefix(userId)) || source.includes('..'))) {
      throw new BadRequestException('imageKey does not belong to this user');
    }
    await this.assertWithinQuota(userId);
    // Claimed only after validation, so a rejected request does not cost the user their minute.
    await this.cooldown.claim(userId);

    let row: ParseJobRow | undefined;
    try {
      [row] = await this.db.insert(parseJobs).values({ userId, sourceType, source }).returning();
      await this.queue.enqueue(row!.id);
    } catch (error) {
      // No job is running, so the user keeps their minute.
      await this.cooldown.release(userId);
      this.logger.error(`Could not create or enqueue parse job${row ? ` ${row.id}` : ''}: ${String(error)}`);
      if (row) await this.db.update(parseJobs).set({ status: 'failed', error: 'internal_error' }).where(eq(parseJobs.id, row.id));
      throw new ServiceUnavailableException('Recipe parsing is temporarily unavailable');
    }
    // Outside the try: once the job is queued, nothing here may mark it failed or give the minute back.
    return toParseJobView(row!, this.cooldown.seconds);
  }

  async getJob(userId: string, id: string): Promise<ParseJobView> {
    const [row] = await this.db
      .select()
      .from(parseJobs)
      .where(and(eq(parseJobs.id, id), eq(parseJobs.userId, userId)))
      .limit(1);
    if (!row) throw new NotFoundException('Parse job not found');
    return toParseJobView(row, this.cooldown.seconds);
  }

  private async assertWithinQuota(userId: string): Promise<void> {
    const [{ used } = { used: 0 }] = await this.db
      .select({ used: sql<number>`count(*)::int` })
      .from(parseJobs)
      .where(and(eq(parseJobs.userId, userId), gt(parseJobs.createdAt, sql`now() - interval '24 hours'`)));
    if (used >= this.dailyQuota) {
      throw new HttpException(
        { statusCode: HttpStatus.TOO_MANY_REQUESTS, code: 'parse_daily_quota', message: 'Daily recipe import limit reached' },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }
  }
}
