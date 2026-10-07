import { Body, Controller, Get, Param, ParseUUIDPipe, Post, UseGuards } from '@nestjs/common';
import { SkipThrottle, Throttle } from '@nestjs/throttler';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiZodBody, ApiZodCreated, ApiZodOk } from '../../common/zod-dto.js';
import { UserThrottlerGuard } from '../../common/user-throttler.guard.js';
import { CurrentUser, type CurrentUserData } from '../auth/current-user.decorator.js';
import { CreateParseJobDto, ParseJobDto } from './parser.schemas.js';
import { ParserService } from './parser.service.js';

@ApiTags('parser')
@ApiBearerAuth()
@UseGuards(UserThrottlerGuard)
@Controller('parser/jobs')
export class ParserController {
  constructor(private readonly parser: ParserService) {}

  /** Queues an import from a recipe URL or an uploaded photo; poll `GET /parser/jobs/:id` for the draft. */
  @Post()
  @Throttle({ default: { limit: 15, ttl: 60_000 } })
  @ApiZodBody(CreateParseJobDto)
  @ApiZodCreated(ParseJobDto)
  create(@CurrentUser() user: CurrentUserData, @Body() body: CreateParseJobDto) {
    return this.parser.createJob(user.id, body);
  }

  // Clients poll this every second or two; the cap on creating jobs is what bounds cost.
  @Get(':id')
  @SkipThrottle()
  @ApiZodOk(ParseJobDto)
  get(@CurrentUser() user: CurrentUserData, @Param('id', ParseUUIDPipe) id: string) {
    return this.parser.getJob(user.id, id);
  }
}
