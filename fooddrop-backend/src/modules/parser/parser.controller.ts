import { Body, Controller, Get, Param, ParseUUIDPipe, Post, UseFilters } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiZodBody, ApiZodCreated, ApiZodError, ApiZodOk } from '../../common/zod-dto.js';
import { CurrentUser, type CurrentUserData } from '../auth/current-user.decorator.js';
import { ParseCooldownFilter } from './parse-cooldown.js';
import { CreateParseJobDto, ParseJobDto, ParseRateLimitErrorDto } from './parser.schemas.js';
import { ParserService } from './parser.service.js';

@ApiTags('parser')
@ApiBearerAuth()
@Controller('parser/jobs')
export class ParserController {
  constructor(private readonly parser: ParserService) {}

  /**
   * Queues an import from a recipe URL or an uploaded photo; poll `GET /parser/jobs/:id` for the draft.
   * Answers 429 when the user imported less than `cooldownSeconds` ago (body has `retryAfterSeconds`) or hit the daily quota.
   */
  @Post()
  @UseFilters(ParseCooldownFilter)
  @ApiZodBody(CreateParseJobDto)
  @ApiZodCreated(ParseJobDto)
  @ApiZodError(429, ParseRateLimitErrorDto, 'Import cooldown (`parse_cooldown`, with `retryAfterSeconds`) or daily quota (`parse_daily_quota`)', {
    'Retry-After': { description: 'Seconds until the cooldown ends (cooldown only)', schema: { type: 'integer' } },
  })
  create(@CurrentUser() user: CurrentUserData, @Body() body: CreateParseJobDto) {
    return this.parser.createJob(user.id, body);
  }

  // Clients poll this every second or two; the cooldown and quota on creating jobs are what bound cost.
  @Get(':id')
  @ApiZodOk(ParseJobDto)
  get(@CurrentUser() user: CurrentUserData, @Param('id', ParseUUIDPipe) id: string) {
    return this.parser.getJob(user.id, id);
  }
}
