import { Injectable } from '@nestjs/common';
import { ThrottlerGuard } from '@nestjs/throttler';

/** Counts requests per signed-in user (falling back to IP), not per IP, so shared networks are not penalized. */
@Injectable()
export class UserThrottlerGuard extends ThrottlerGuard {
  protected override getTracker(req: Record<string, unknown>): Promise<string> {
    const user = req['user'] as { id?: string } | undefined;
    return Promise.resolve(user?.id ?? String(req['ip']));
  }
}
