import { validateEnv } from './env.schema.js';

const validEnv = {
  DATABASE_URL: 'postgres://fooddrop:pw@localhost:5432/fooddrop',
  REDIS_URL: 'redis://localhost:6379',
};

describe('validateEnv', () => {
  it('applies defaults for optional variables', () => {
    const env = validateEnv(validEnv);
    expect(env.PORT).toBe(4000);
    expect(env.NODE_ENV).toBe('development');
  });

  it('coerces PORT from string', () => {
    expect(validateEnv({ ...validEnv, PORT: '5000' }).PORT).toBe(5000);
  });

  it('throws when DATABASE_URL is missing', () => {
    expect(() => validateEnv({ REDIS_URL: validEnv.REDIS_URL })).toThrow(/DATABASE_URL/);
  });

  it('throws when REDIS_URL is missing', () => {
    expect(() => validateEnv({ DATABASE_URL: validEnv.DATABASE_URL })).toThrow(/REDIS_URL/);
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
