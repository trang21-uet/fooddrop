import { Inject, Injectable, Logger, OnApplicationShutdown, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Worker } from 'bullmq';
import { and, eq, inArray } from 'drizzle-orm';
import type { Env } from '../../config/env.schema.js';
import { DRIZZLE, type Database } from '../../database/database.module.js';
import { parseJobs } from '../../database/schema/index.js';
import { ParseJobError } from './parse-job-error.js';
import { PARSE_QUEUE_NAME, bullConnection, type ParseQueueJob } from './parse-queue.js';
import { RecipeParsePipeline } from './recipe-parse-pipeline.service.js';

@Injectable()
export class ParseJobWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger(ParseJobWorker.name);
  private worker: Worker<ParseQueueJob> | null = null;

  constructor(
    @Inject(DRIZZLE) private readonly db: Database,
    private readonly pipeline: RecipeParsePipeline,
    private readonly config: ConfigService<Env, true>,
  ) {}

  onModuleInit(): void {
    this.worker = new Worker<ParseQueueJob>(PARSE_QUEUE_NAME, (job) => this.process(job.data.jobId), {
      connection: bullConnection(this.config.get('REDIS_URL', { infer: true })),
      concurrency: 3,
    });
    this.worker.on('error', (error) => this.logger.warn(`Worker error: ${error.message}`));
  }

  async onApplicationShutdown(): Promise<void> {
    await this.worker?.close();
  }

  /** Never throws for a parse failure: the outcome belongs on the row, not in BullMQ's retry machinery. */
  async process(jobId: string): Promise<void> {
    // 'running' is accepted so a job BullMQ re-delivers after a worker crash is not stuck forever.
    const [job] = await this.db
      .update(parseJobs)
      .set({ status: 'running' })
      .where(and(eq(parseJobs.id, jobId), inArray(parseJobs.status, ['queued', 'running'])))
      .returning();
    if (!job) return;

    try {
      const draft = await this.pipeline.run({ userId: job.userId, sourceType: job.sourceType, source: job.source });
      await this.db.update(parseJobs).set({ status: 'succeeded', result: draft, error: null }).where(eq(parseJobs.id, jobId));
    } catch (error) {
      const code = error instanceof ParseJobError ? error.code : 'internal_error';
      if (error instanceof ParseJobError) this.logger.warn(`Job ${jobId} failed: ${error.message}`);
      else this.logger.error(`Job ${jobId} crashed`, error instanceof Error ? error.stack : String(error));
      await this.db.update(parseJobs).set({ status: 'failed', error: code, result: null }).where(eq(parseJobs.id, jobId));
    }
  }
}
