import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import { RetryAfterException } from '../../common/retry-after.exception.js';
import type { Env } from '../../config/env.schema.js';
import { REDIS_CLIENT } from '../../redis/redis.module.js';

const WINDOW_SECONDS = 60;

export class SpinRateLimitException extends RetryAfterException {
  constructor(retryAfterSeconds: number) {
    super(retryAfterSeconds, { code: 'gacha_rate_limit', message: 'Too many spins, slow down a little' });
  }
}

/**
 * At most `GACHA_SPINS_PER_MINUTE` spins per user in a fixed one-minute window. One MULTI starts the
 * window (SET NX EX) and counts the spin (INCR), so concurrent requests cannot both slip past the limit.
 */
@Injectable()
export class SpinRateLimit {
  private readonly logger = new Logger(SpinRateLimit.name);
  private readonly limit: number;

  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    config: ConfigService<Env, true>,
  ) {
    this.limit = config.get('GACHA_SPINS_PER_MINUTE', { infer: true });
  }

  /** Counts one spin, or throws `SpinRateLimitException` with the seconds until the window resets. */
  async consume(userId: string): Promise<void> {
    if (this.limit === 0) return;
    const key = `gacha:spins:${userId}`;
    let count: number;
    let ttlMs: number;
    try {
      const replies = await this.redis.multi().set(key, '0', 'EX', WINDOW_SECONDS, 'NX').incr(key).pttl(key).exec();
      const error = replies?.find(([replyError]) => replyError)?.[0];
      if (!replies || error) throw error ?? new Error('MULTI was aborted');
      count = Number(replies[1]![1]);
      ttlMs = Number(replies[2]![1]);
    } catch (error) {
      // A spin is a cheap DB read, unlike a parse; an outage of the limiter should not take the feature down.
      this.logger.warn(`Could not check the spin rate limit: ${String(error)}`);
      return;
    }
    if (count > this.limit) throw new SpinRateLimitException(ttlMs > 0 ? Math.ceil(ttlMs / 1000) : WINDOW_SECONDS);
  }
}
