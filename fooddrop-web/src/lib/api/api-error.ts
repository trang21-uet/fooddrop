export class ApiError extends Error {
  constructor(
    readonly status: number,
    message: string,
    /** Set on 429s from the import cooldown (see `start-import.ts`): how long until the next attempt is allowed. */
    readonly retryAfterSeconds?: number,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

type ApiResult<T> = { data?: T; error?: unknown; response: Response };

/** Narrows an openapi-fetch result to its data, throwing ApiError (with the server's message) otherwise. */
export function unwrap<T>({ data, error, response }: ApiResult<T>): T {
  if (data !== undefined && response.ok) return data;
  throw new ApiError(response.status, extractMessage(error) ?? response.statusText ?? "Yêu cầu thất bại");
}

function extractMessage(error: unknown): string | undefined {
  if (typeof error !== "object" || error === null || !("message" in error)) return undefined;
  const { message } = error as { message: unknown };
  if (typeof message === "string") return message;
  if (Array.isArray(message)) return message.filter((m) => typeof m === "string").join(", ");
  return undefined;
}
