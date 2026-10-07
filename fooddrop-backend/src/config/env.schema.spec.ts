import { validateEnv } from './env.schema.js';

const validEnv = {
  DATABASE_URL: 'postgres://fooddrop:pw@localhost:5432/fooddrop',
  REDIS_URL: 'redis://localhost:6379',
  AUTH_SECRET: 'test-secret-of-sufficient-length',
};

describe('validateEnv', () => {
  it('applies defaults for optional variables', () => {
    const env = validateEnv(validEnv);
    expect(env.PORT).toBe(4000);
    expect(env.NODE_ENV).toBe('development');
    expect(env.BETTER_AUTH_URL).toBe('http://localhost:4000');
  });

  it('treats blank Google credentials as unset', () => {
    const env = validateEnv({ ...validEnv, GOOGLE_CLIENT_ID: '', GOOGLE_CLIENT_SECRET: '' });
    expect(env.GOOGLE_CLIENT_ID).toBeUndefined();
    expect(env.GOOGLE_CLIENT_SECRET).toBeUndefined();
  });

  it('treats blank parser and storage credentials as unset and defaults models', () => {
    const env = validateEnv({ ...validEnv, ANTHROPIC_API_KEY: '', S3_ACCESS_KEY_ID: '', S3_ENDPOINT: '' });
    expect(env.ANTHROPIC_API_KEY).toBeUndefined();
    expect(env.S3_ACCESS_KEY_ID).toBeUndefined();
    expect(env.S3_ENDPOINT).toBeUndefined();
    expect(env.PARSER_MODEL_TEXT).toBe('claude-haiku-4-5-20251001');
    expect(env.PARSER_DAILY_QUOTA).toBe(30);
  });

  it('rejects a short AUTH_SECRET', () => {
    expect(() => validateEnv({ ...validEnv, AUTH_SECRET: 'short' })).toThrow(/AUTH_SECRET/);
  });

  it('coerces PORT from string', () => {
    expect(validateEnv({ ...validEnv, PORT: '5000' }).PORT).toBe(5000);
  });

  it('throws when DATABASE_URL is missing', () => {
    expect(() => validateEnv({ ...validEnv, DATABASE_URL: undefined })).toThrow(/DATABASE_URL/);
  });

  it('throws when REDIS_URL is missing', () => {
    expect(() => validateEnv({ ...validEnv, REDIS_URL: undefined })).toThrow(/REDIS_URL/);
  });

  it('accepts the postgresql:// scheme', () => {
    const url = 'postgresql://fooddrop:pw@localhost:5432/fooddrop';
    expect(validateEnv({ ...validEnv, DATABASE_URL: url }).DATABASE_URL).toBe(url);
  });

  it('rejects a non-numeric PORT', () => {
    expect(() => validateEnv({ ...validEnv, PORT: 'abc' })).toThrow(/PORT/);
  });

  it('rejects a non-redis REDIS_URL', () => {
    expect(() => validateEnv({ ...validEnv, REDIS_URL: 'http://localhost:6379' })).toThrow(
      /REDIS_URL/,
    );
  });
});
