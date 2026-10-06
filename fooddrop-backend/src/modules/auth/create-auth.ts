import { betterAuth } from 'better-auth';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';
import { bearer } from 'better-auth/plugins';
import type { Database } from '../../database/database.module.js';
import { accounts, sessions, users, verifications } from '../../database/schema/index.js';

export interface AuthOptions {
  secret: string;
  baseURL: string;
  trustedOrigins: string[];
  google?: { clientId: string; clientSecret: string };
}

/**
 * Better Auth instance: email+password and optional Google for web (cookie session), plus the
 * bearer plugin so mobile can send `Authorization: Bearer <session token>`.
 */
export function createAuth(db: Database, options: AuthOptions) {
  return betterAuth({
    secret: options.secret,
    baseURL: options.baseURL,
    trustedOrigins: options.trustedOrigins,
    database: drizzleAdapter(db, {
      provider: 'pg',
      schema: { user: users, session: sessions, account: accounts, verification: verifications },
    }),
    // Table ids are uuid columns (see users.schema.ts), so let the DB-compatible generator run.
    advanced: { database: { generateId: 'uuid' } },
    user: {
      fields: { name: 'displayName' },
      additionalFields: {
        locale: { type: 'string', required: false, defaultValue: 'vi' },
      },
    },
    emailAndPassword: { enabled: true },
    socialProviders: options.google
      ? { google: { clientId: options.google.clientId, clientSecret: options.google.clientSecret } }
      : {},
    plugins: [bearer()],
  });
}

export type Auth = ReturnType<typeof createAuth>;
