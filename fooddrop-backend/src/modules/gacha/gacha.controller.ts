import { Body, Controller, Get, Post, Query, UseFilters } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { RetryAfterFilter } from '../../common/retry-after.exception.js';
import { ApiZodBody, ApiZodCreated, ApiZodError, ApiZodOk, ApiZodQuery } from '../../common/zod-dto.js';
import { CurrentUser, type CurrentUserData } from '../auth/current-user.decorator.js';
import {
  CreateSpinDto,
  GachaCasesDto,
  GachaErrorDto,
  GachaSpinDto,
  ListSpinsQueryDto,
  SpinHistoryDto,
} from './gacha.schemas.js';
import { GachaService } from './gacha.service.js';

@ApiTags('gacha')
@ApiBearerAuth()
@Controller('gacha')
export class GachaController {
  constructor(private readonly gacha: GachaService) {}

  /** The cook cases with what each holds for the user, for the case picker. */
  @Get('cases')
  @ApiZodOk(GachaCasesDto)
  cases(@CurrentUser() user: CurrentUserData) {
    return this.gacha.cases(user.id);
  }

  /** Opens a case: the server draws the result and returns the reel for the client to animate. */
  @Post('spins')
  @UseFilters(RetryAfterFilter)
  @ApiZodBody(CreateSpinDto)
  @ApiZodCreated(GachaSpinDto)
  @ApiZodError(422, GachaErrorDto, 'The case holds no recipe (`gacha_empty_pool`)')
  @ApiZodError(429, GachaErrorDto, 'Too many spins this minute (`gacha_rate_limit`, with `retryAfterSeconds`)', {
    'Retry-After': { description: 'Seconds until spins are allowed again', schema: { type: 'integer' } },
  })
  spin(@CurrentUser() user: CurrentUserData, @Body() body: CreateSpinDto) {
    return this.gacha.spin(user.id, body);
  }

  @Get('spins')
  @ApiZodQuery(ListSpinsQueryDto)
  @ApiZodOk(SpinHistoryDto)
  history(@CurrentUser() user: CurrentUserData, @Query() query: ListSpinsQueryDto) {
    return this.gacha.history(user.id, query.limit);
  }
}
