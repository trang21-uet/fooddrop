import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiZodBody, ApiZodCreated, ApiZodOk, ApiZodQuery } from '../../common/zod-dto.js';
import { IngredientsService } from './ingredients.service.js';
import {
  CreateIngredientDto,
  IngredientDto,
  SearchIngredientsQueryDto,
} from './ingredients.schemas.js';

@ApiTags('ingredients')
@ApiBearerAuth()
@Controller('ingredients')
export class IngredientsController {
  constructor(private readonly ingredientsService: IngredientsService) {}

  @Get()
  @ApiZodQuery(SearchIngredientsQueryDto)
  @ApiZodOk(IngredientDto, { isArray: true })
  search(@Query() query: SearchIngredientsQueryDto) {
    return this.ingredientsService.search(query.q, query.limit);
  }

  /** Adds to the shared catalog; user-added entries default to the `other` aisle. */
  @Post()
  @ApiZodBody(CreateIngredientDto)
  @ApiZodCreated(IngredientDto)
  create(@Body() body: CreateIngredientDto) {
    return this.ingredientsService.create(body);
  }
}
