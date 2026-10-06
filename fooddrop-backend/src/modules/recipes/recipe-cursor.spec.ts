import { decodeCursor, encodeCursor } from './recipe-cursor.js';

describe('recipe cursor', () => {
  const cursor = { createdAt: new Date('2026-10-06T10:15:30.123Z'), id: '3f1e8a52-6d0b-4c8e-9a41-2b7f0c1d5e9a' };

  it('round-trips with millisecond precision', () => {
    expect(decodeCursor(encodeCursor(cursor))).toEqual(cursor);
  });

  it('is url-safe', () => {
    expect(encodeCursor(cursor)).toMatch(/^[A-Za-z0-9_-]+$/);
  });

  it.each(['', 'not-a-cursor', Buffer.from('2026-13-45|bad').toString('base64url'), Buffer.from('nope|3f1e8a52-6d0b-4c8e-9a41-2b7f0c1d5e9a').toString('base64url'), Buffer.from(`2026-10-06T10:00:00.000Z|${'-'.repeat(36)}`).toString('base64url'), Buffer.from('2026-10-06|3f1e8a52-6d0b-4c8e-9a41-2b7f0c1d5e9a').toString('base64url')])(
    'rejects malformed cursor %j',
    (value) => {
      expect(decodeCursor(value)).toBeNull();
    },
  );
});
