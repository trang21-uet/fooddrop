import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiZodOk } from '../../common/zod-dto.js';
import { TagsService } from './tags.service.js';
import { TagDimensionDto } from './tags.schemas.js';

@ApiTags('tags')
@ApiBearerAuth()
@Controller('tags')
export class TagsController {
  constructor(private readonly tagsService: TagsService) {}

  @Get()
  @ApiZodOk(TagDimensionDto, { isArray: true })
  list() {
    return this.tagsService.listDimensions();
  }
}
