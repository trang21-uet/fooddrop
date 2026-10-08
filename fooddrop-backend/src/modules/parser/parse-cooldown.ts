import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  Logger,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Response } from 'express';
import type { Redis } from 'ioredis';
import type { Env } from '../../config/env.schema.js';
import { REDIS_CLIENT } from '../../redis/redis.module.js';

/** Body of the 429 sent while a user is cooling down; clients use `retryAfterSeconds` for their countdown. */
export class ParseCooldownException extends HttpException {
  constructor(readonly retryAfterSeconds: number) {
    super(
      { statusCode: HttpStatus.TOO_MANY_REQUESTS, code: 'parse_cooldown', message: 'Please wait before importing another recipe', retryAfterSeconds },
      HttpStatus.TOO_MANY_REQUESTS,
    );
  }
}

/** Adds the standard `Retry-After` header to the cooldown 429, for HTTP clients that do not read the body. */
@Catch(ParseCooldownException)
export class ParseCooldownFilter implements ExceptionFilter<ParseCooldownException> {
  catch(exception: ParseCooldownException, host: ArgumentsHost): void {
    host
      .switchToHttp()
      .getResponse<Response>()
      .status(exception.getStatus())
      .setHeader('Retry-After', String(exception.retryAfterSeconds))
      .json(exception.getResponse());
  }
}

/**
 * One import per user per `PARSER_COOLDOWN_SECONDS`. A single Redis `SET NX PX` makes the check-and-claim atomic,
 * so concurrent requests (or several API instances) cannot both pass.
 */
@Injectable()
export class ParseCooldown {
  private readonly logger = new Logger(ParseCooldown.name);
  readonly seconds: number;

  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    config: ConfigService<Env, true>,
  ) {
    this.seconds = config.get('PARSER_COOLDOWN_SECONDS', { infer: true });
  }

  /** Starts the cooldown, or throws `ParseCooldownException` with the time left if one is running. */
  async claim(userId: string): Promise<void> {
    if (this.seconds === 0) return;
    const key = cooldownKey(userId);
    let remainingMs: number;
    try {
      if ((await this.redis.set(key, '1', 'PX', this.seconds * 1000, 'NX')) === 'OK') return;
      remainingMs = await this.redis.pttl(key);
    } catch (error) {
      // Same answer as a queue outage: the import cannot run right now.
      this.logger.error(`Could not check the import cooldown: ${String(error)}`);
      throw new ServiceUnavailableException('Recipe parsing is temporarily unavailable');
    }
    // -2 = the key expired between the two calls, -1 = no expiry (should not happen); fall back to the full window.
    throw new ParseCooldownException(remainingMs > 0 ? Math.ceil(remainingMs / 1000) : this.seconds);
  }

  /** Gives the minute back when no job was created (queue down, insert failed). */
  async release(userId: string): Promise<void> {
    if (this.seconds === 0) return;
    await this.redis.del(cooldownKey(userId)).catch(() => undefined);
  }
}

const cooldownKey = (userId: string) => `parser:cooldown:${userId}`;
