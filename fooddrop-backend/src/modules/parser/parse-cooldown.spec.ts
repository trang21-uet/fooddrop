import { ServiceUnavailableException } from '@nestjs/common';
import type { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { Env } from '../../config/env.schema.js';
import { ParseCooldown, ParseCooldownException } from './parse-cooldown.js';

/** Just enough of ioredis for SET NX PX / PTTL / DEL, with a controllable clock. */
function fakeRedis(clock: { now: number }) {
  const expiresAt = new Map<string, number>();
  const live = (key: string) => (expiresAt.get(key) ?? 0) > clock.now;
  return {
    set: async (key: string, _value: string, _px: 'PX', ms: number, _nx: 'NX') => {
      if (live(key)) return null;
      expiresAt.set(key, clock.now + ms);
      return 'OK';
    },
    pttl: async (key: string) => (live(key) ? expiresAt.get(key)! - clock.now : -2),
    del: async (key: string) => void expiresAt.delete(key),
  } as unknown as Redis;
}

function setup(seconds = 60, redis?: Redis) {
  const clock = { now: 1_000_000 };
  const config = { get: () => seconds } as unknown as ConfigService<Env, true>;
  return { clock, cooldown: new ParseCooldown(redis ?? fakeRedis(clock), config) };
}

describe('ParseCooldown', () => {
  it('lets the first import through and blocks the next one with the time left', async () => {
    const { clock, cooldown } = setup();
    await cooldown.claim('alice');
    clock.now += 20_000;

    const error = await cooldown.claim('alice').catch((e: unknown) => e);
    expect(error).toBeInstanceOf(ParseCooldownException);
    expect(error).toMatchObject({ retryAfterSeconds: 40 });
    expect((error as ParseCooldownException).getStatus()).toBe(429);
    expect((error as ParseCooldownException).getResponse()).toMatchObject({ code: 'parse_cooldown', retryAfterSeconds: 40 });
  });

  it('allows another import once the minute is over', async () => {
    const { clock, cooldown } = setup();
    await cooldown.claim('alice');
    clock.now += 60_000;
    await expect(cooldown.claim('alice')).resolves.toBeUndefined();
  });

  it('tracks users separately', async () => {
    const { cooldown } = setup();
    await cooldown.claim('alice');
    await expect(cooldown.claim('bob')).resolves.toBeUndefined();
  });

  it('gives the minute back on release', async () => {
    const { cooldown } = setup();
    await cooldown.claim('alice');
    await cooldown.release('alice');
    await expect(cooldown.claim('alice')).resolves.toBeUndefined();
  });

  it('answers 503, not a raw 500, when Redis is unreachable', async () => {
    const down = { set: () => Promise.reject(new Error('ECONNREFUSED')) } as unknown as Redis;
    const { cooldown } = setup(60, down);
    await expect(cooldown.claim('alice')).rejects.toBeInstanceOf(ServiceUnavailableException);
  });

  it('is off when the cooldown is 0 seconds', async () => {
    const { cooldown } = setup(0);
    await cooldown.claim('alice');
    await expect(cooldown.claim('alice')).resolves.toBeUndefined();
  });
});
