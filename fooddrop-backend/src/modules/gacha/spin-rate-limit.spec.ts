import type { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { Env } from '../../config/env.schema.js';
import { SpinRateLimit, SpinRateLimitException } from './spin-rate-limit.js';

/** A MULTI whose EXEC answers `[SET, INCR, PTTL]` replies; the counting itself is covered by the e2e spec. */
const redisReplying = (exec: () => Promise<unknown>) => ({ multi: () => {
  const chain = { set: () => chain, incr: () => chain, pttl: () => chain, exec };
  return chain;
} }) as unknown as Redis;

const limiter = (redis: Redis, limit = 30) =>
  new SpinRateLimit(redis, { get: () => limit } as unknown as ConfigService<Env, true>);

describe('SpinRateLimit', () => {
  it('allows spins up to the limit and blocks the next with the seconds left in the window', async () => {
    await expect(limiter(redisReplying(async () => [[null, null], [null, 30], [null, 42_000]])).consume('alice')).resolves.toBeUndefined();

    const error = await limiter(redisReplying(async () => [[null, null], [null, 31], [null, 41_200]]))
      .consume('alice')
      .catch((e: unknown) => e);
    expect(error).toBeInstanceOf(SpinRateLimitException);
    expect((error as SpinRateLimitException).getStatus()).toBe(429);
    expect((error as SpinRateLimitException).getResponse()).toMatchObject({ code: 'gacha_rate_limit', retryAfterSeconds: 42 });
  });

  it('lets the spin through when Redis is down', async () => {
    await expect(limiter(redisReplying(() => Promise.reject(new Error('ECONNREFUSED')))).consume('alice')).resolves.toBeUndefined();
    await expect(limiter(redisReplying(async () => [[new Error('READONLY'), null]])).consume('alice')).resolves.toBeUndefined();
  });

  it('is off when the limit is 0', async () => {
    const untouched = { multi: () => { throw new Error('should not be called'); } } as unknown as Redis;
    await expect(limiter(untouched, 0).consume('alice')).resolves.toBeUndefined();
  });
});
