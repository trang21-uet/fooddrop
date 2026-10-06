export interface RecipeCursor {
  createdAt: Date;
  id: string;
}

// Strict shapes: whatever passes here is interpolated into `::timestamptz` / `::uuid` casts.
const CURSOR_PATTERN =
  /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)\|([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$/i;

/** Opaque keyset cursor: clients pass it back verbatim and never parse it. */
export function encodeCursor(cursor: RecipeCursor): string {
  return Buffer.from(`${cursor.createdAt.toISOString()}|${cursor.id}`).toString('base64url');
}

/** Returns null for anything that is not a cursor this module produced. */
export function decodeCursor(value: string): RecipeCursor | null {
  const match = CURSOR_PATTERN.exec(Buffer.from(value, 'base64url').toString('utf8'));
  if (!match) return null;
  const createdAt = new Date(match[1]!);
  if (Number.isNaN(createdAt.getTime())) return null;
  return { createdAt, id: match[2]! };
}
