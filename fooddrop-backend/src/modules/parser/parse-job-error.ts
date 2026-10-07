/** Stable codes stored in `parse_jobs.error`; clients map them to localized messages. */
export const PARSE_ERROR_CODES = [
  'url_blocked', // not http(s), non-standard port, or resolves to a private address
  'fetch_failed', // network error, timeout, non-2xx, oversized or non-HTML response
  'not_a_recipe',
  'image_unreadable', // missing/oversized upload or the model could not read it
  'parser_unavailable', // no API key or the model call failed
  'internal_error',
] as const;
export type ParseErrorCode = (typeof PARSE_ERROR_CODES)[number];

/** `detail` goes to logs only; it may contain upstream text we do not show users. */
export class ParseJobError extends Error {
  constructor(
    readonly code: ParseErrorCode,
    readonly detail?: string,
  ) {
    super(detail ? `${code}: ${detail}` : code);
    this.name = 'ParseJobError';
  }
}
