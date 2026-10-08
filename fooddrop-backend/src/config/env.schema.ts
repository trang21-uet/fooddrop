import { z } from 'zod';

// Only variables needed by the current phases are required; later phases
// tighten this schema when they start using a variable.
const emptyToUndefined = z
  .string()
  .optional()
  .transform((value) => value || undefined);

export const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(4000),
  DATABASE_URL: z.url({ protocol: /^postgres(ql)?$/ }),
  REDIS_URL: z.url({ protocol: /^rediss?$/ }),
  CORS_ORIGINS: z.string().default('http://localhost:3000'),
  AUTH_SECRET: z.string().min(16, 'must be at least 16 characters'),
  // Public URL of this API; Better Auth uses it for cookies and OAuth callbacks.
  BETTER_AUTH_URL: z.url().default('http://localhost:4000'),
  // Blank in .env.example means "Google sign-in disabled".
  GOOGLE_CLIENT_ID: emptyToUndefined,
  GOOGLE_CLIENT_SECRET: emptyToUndefined,
  // AI recipe parser. Without a key the JSON-LD path still works; the LLM fallback reports "unavailable".
  ANTHROPIC_API_KEY: emptyToUndefined,
  PARSER_MODEL_TEXT: z.string().default('claude-haiku-4-5-20251001'),
  PARSER_MODEL_VISION: z.string().default('claude-sonnet-5-5'),
  PARSER_DAILY_QUOTA: z.coerce.number().int().positive().default(30),
  // Minimum gap between two imports by the same user; 0 disables it (e2e tests).
  PARSER_COOLDOWN_SECONDS: z.coerce.number().int().min(0).default(60),
  // S3-compatible storage (R2, MinIO) for cookbook photos. Blank credentials disable uploads.
  S3_ENDPOINT: emptyToUndefined,
  S3_REGION: z.string().default('auto'),
  S3_BUCKET: z.string().default('fooddrop-media'),
  S3_ACCESS_KEY_ID: emptyToUndefined,
  S3_SECRET_ACCESS_KEY: emptyToUndefined,
  // Public base URL of the bucket (R2 custom domain, CDN). Blank = recipe photos are served via signed GET URLs.
  S3_PUBLIC_URL: emptyToUndefined,
});

export type Env = z.infer<typeof envSchema>;

/** Used by ConfigModule; throws on startup so a bad env fails fast. */
export function validateEnv(config: Record<string, unknown>): Env {
  const result = envSchema.safeParse(config);
  if (!result.success) {
    throw new Error(`Invalid environment variables:\n${z.prettifyError(result.error)}`);
  }
  return result.data;
}
