import type { Pool } from 'pg';
import type { Redis } from 'ioredis';
import { HealthService } from './health.service.js';

function makeService(opts: { pgFails?: boolean; pgHangs?: boolean; redisFails?: boolean }) {
  const pool = {
    query: async () => {
      if (opts.pgHangs) return new Promise(() => undefined);
      if (opts.pgFails) throw new Error('connection refused');
      return { rows: [{ '?column?': 1 }] };
    },
  } as unknown as Pool;
  const redis = {
    ping: async () => {
      if (opts.redisFails) throw new Error('connection refused');
      return 'PONG';
    },
  } as unknown as Redis;
  return new HealthService(pool, redis);
}

describe('HealthService', () => {
  it('returns ok when both dependencies respond', async () => {
    await expect(makeService({}).check()).resolves.toEqual({
      status: 'ok',
      checks: { postgres: 'up', redis: 'up' },
    });
  });

  it('marks postgres down and status error when the query fails', async () => {
    const result = await makeService({ pgFails: true }).check();
    expect(result).toEqual({ status: 'error', checks: { postgres: 'down', redis: 'up' } });
  });

  it('marks postgres down when the query hangs past the probe timeout', async () => {
    vi.useFakeTimers();
    try {
      const pending = makeService({ pgHangs: true }).check();
      await vi.advanceTimersByTimeAsync(2000);
      await expect(pending).resolves.toEqual({
        status: 'error',
        checks: { postgres: 'down', redis: 'up' },
      });
    } finally {
      vi.useRealTimers();
    }
  });

  it('marks redis down when ping fails', async () => {
    const result = await makeService({ redisFails: true }).check();
    expect(result.checks.redis).toBe('down');
    expect(result.status).toBe('error');
  });
});
