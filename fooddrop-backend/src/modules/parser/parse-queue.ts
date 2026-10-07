import { Injectable, OnApplicationShutdown } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Queue, type ConnectionOptions } from 'bullmq';
import type { Env } from '../../config/env.schema.js';

export const PARSE_QUEUE_NAME = 'recipe-parse';

export interface ParseQueueJob {
  jobId: string;
}

/** BullMQ wants ioredis options (with unlimited retries for blocking workers), not a URL. */
export function bullConnection(redisUrl: string): ConnectionOptions {
  const url = new URL(redisUrl);
  return {
    host: url.hostname,
    port: Number(url.port || 6379),
    username: url.username ? decodeURIComponent(url.username) : undefined,
    password: url.password ? decodeURIComponent(url.password) : undefined,
    db: url.pathname.length > 1 ? Number(url.pathname.slice(1)) : undefined,
    tls: url.protocol === 'rediss:' ? {} : undefined,
    maxRetriesPerRequest: null,
  };
}

/** Producer side, used by the API. Jobs are not retried: failures here are deterministic, not transient. */
@Injectable()
export class ParseQueue implements OnApplicationShutdown {
  private readonly queue: Queue<ParseQueueJob>;

  constructor(config: ConfigService<Env, true>) {
    this.queue = new Queue(PARSE_QUEUE_NAME, {
      connection: bullConnection(config.get('REDIS_URL', { infer: true })),
      defaultJobOptions: { attempts: 1, removeOnComplete: { age: 3600 }, removeOnFail: { age: 24 * 3600 } },
    });
    // Without a listener a Redis outage becomes an unhandled 'error' event.
    this.queue.on('error', () => undefined);
  }

  async enqueue(jobId: string): Promise<void> {
    // jobId doubles as BullMQ's dedupe key, so a double submit cannot run a parse twice.
    await this.queue.add('parse', { jobId }, { jobId });
  }

  async onApplicationShutdown(): Promise<void> {
    await this.queue.close();
  }
}
