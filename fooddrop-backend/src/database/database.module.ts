import { Global, Inject, Injectable, Logger, Module, OnApplicationShutdown } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import type { Env } from '../config/env.schema.js';
import * as schema from './schema/index.js';

export const PG_POOL = Symbol('PG_POOL');
export const DRIZZLE = Symbol('DRIZZLE');

export type Database = NodePgDatabase<typeof schema>;
export type Transaction = Parameters<Parameters<Database['transaction']>[0]>[0];

const logger = new Logger('Postgres');

@Injectable()
class PgPoolShutdown implements OnApplicationShutdown {
  constructor(@Inject(PG_POOL) private readonly pool: Pool) {}

  async onApplicationShutdown(): Promise<void> {
    await this.pool.end();
  }
}

@Global()
@Module({
  providers: [
    {
      provide: PG_POOL,
      inject: [ConfigService],
      // Pool connects lazily on first query, so startup does not block on Postgres.
      useFactory: (config: ConfigService<Env, true>) => {
        const pool = new Pool({
          connectionString: config.get('DATABASE_URL', { infer: true }),
          max: 10,
          // Without a timeout, waiters pile up forever while Postgres is unreachable.
          connectionTimeoutMillis: 2000,
          idleTimeoutMillis: 30000,
        });
        // Idle clients emit 'error' when Postgres restarts; unhandled, it crashes the process.
        pool.on('error', (error: Error) => logger.warn(`Postgres idle client error: ${error.message}`));
        return pool;
      },
    },
    {
      provide: DRIZZLE,
      inject: [PG_POOL],
      useFactory: (pool: Pool): Database => drizzle(pool, { schema }),
    },
    PgPoolShutdown,
  ],
  exports: [PG_POOL, DRIZZLE],
})
export class DatabaseModule {}
