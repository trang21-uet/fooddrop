import { Inject, Injectable, Logger } from '@nestjs/common';
import type { Pool } from 'pg';
import type { Redis } from 'ioredis';
import { PG_POOL } from '../../database/database.module.js';
import { REDIS_CLIENT } from '../../redis/redis.module.js';
import type { DependencyStatus, HealthResponseDto } from './health.schemas.js';

const CHECK_TIMEOUT_MS = 2000;

@Injectable()
export class HealthService {
  private readonly logger = new Logger(HealthService.name);

  constructor(
    @Inject(PG_POOL) private readonly pool: Pool,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  async check(): Promise<HealthResponseDto> {
    const [postgres, redis] = await Promise.all([
      this.probe('postgres', () => this.pool.query('SELECT 1')),
      // With lazyConnect, ioredis connects on the first command; no explicit connect() race.
      this.probe('redis', () => this.redis.ping()),
    ]);
    const status = postgres === 'up' && redis === 'up' ? 'ok' : 'error';
    return { status, checks: { postgres, redis } };
  }

  private async probe(name: string, fn: () => Promise<unknown>): Promise<DependencyStatus> {
    let timer: NodeJS.Timeout | undefined;
    const timeout = new Promise<never>((_, reject) => {
      timer = setTimeout(() => reject(new Error('timeout')), CHECK_TIMEOUT_MS);
    });
    try {
      await Promise.race([fn(), timeout]);
      return 'up';
    } catch (error) {
      this.logger.warn(`${name} health check failed: ${(error as Error).message}`);
      return 'down';
    } finally {
      clearTimeout(timer);
    }
  }
}
