import { createParamDecorator, UnauthorizedException, type ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';

export interface CurrentUserData {
  id: string;
  email: string;
}

/**
 * Authenticated user for the request. The global Better Auth guard has already rejected
 * anonymous calls, so a missing user here means the route was marked public by mistake.
 */
export const CurrentUser = createParamDecorator((_data: unknown, context: ExecutionContext): CurrentUserData => {
  const user = context.switchToHttp().getRequest<Request & { user?: CurrentUserData }>().user;
  if (!user) throw new UnauthorizedException();
  return { id: user.id, email: user.email };
});
