import { type ArgumentsHost, Catch, type ExceptionFilter, HttpException, HttpStatus } from '@nestjs/common';
import type { Response } from 'express';

/** A 429 whose body carries `retryAfterSeconds`; clients take their countdown from it, never from a constant. */
export class RetryAfterException extends HttpException {
  constructor(
    readonly retryAfterSeconds: number,
    body: { code: string; message: string },
  ) {
    super({ statusCode: HttpStatus.TOO_MANY_REQUESTS, ...body, retryAfterSeconds }, HttpStatus.TOO_MANY_REQUESTS);
  }
}

/** Adds the standard `Retry-After` header to a `RetryAfterException`, for HTTP clients that do not read the body. */
@Catch(RetryAfterException)
export class RetryAfterFilter implements ExceptionFilter<RetryAfterException> {
  catch(exception: RetryAfterException, host: ArgumentsHost): void {
    host
      .switchToHttp()
      .getResponse<Response>()
      .status(exception.getStatus())
      .setHeader('Retry-After', String(exception.retryAfterSeconds))
      .json(exception.getResponse());
  }
}
