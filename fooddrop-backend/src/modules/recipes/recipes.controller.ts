import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiNoContentResponse, ApiTags } from '@nestjs/swagger';
import { ApiZodBody, ApiZodCreated, ApiZodOk, ApiZodQuery } from '../../common/zod-dto.js';
import { CurrentUser, type CurrentUserData } from '../auth/current-user.decorator.js';
import { RecipesReaderService } from './recipes-reader.service.js';
import { RecipesService } from './recipes.service.js';
import {
  ListRecipesQueryDto,
  RecipeDetailDto,
  RecipeInputDto,
  RecipeListDto,
} from './recipes.schemas.js';

@ApiTags('recipes')
@ApiBearerAuth()
@Controller('recipes')
export class RecipesController {
  constructor(
    private readonly recipes: RecipesService,
    private readonly reader: RecipesReaderService,
  ) {}

  @Get()
  @ApiZodQuery(ListRecipesQueryDto)
  @ApiZodOk(RecipeListDto)
  list(@CurrentUser() user: CurrentUserData, @Query() query: ListRecipesQueryDto) {
    return this.reader.list(user.id, query);
  }

  @Get(':id')
  @ApiZodOk(RecipeDetailDto)
  get(@CurrentUser() user: CurrentUserData, @Param('id', ParseUUIDPipe) id: string) {
    return this.reader.getDetail(user.id, id);
  }

  @Post()
  @ApiZodBody(RecipeInputDto)
  @ApiZodCreated(RecipeDetailDto)
  create(@CurrentUser() user: CurrentUserData, @Body() body: RecipeInputDto) {
    return this.recipes.create(user.id, body);
  }

  @Put(':id')
  @ApiZodBody(RecipeInputDto)
  @ApiZodOk(RecipeDetailDto)
  update(
    @CurrentUser() user: CurrentUserData,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() body: RecipeInputDto,
  ) {
    return this.recipes.update(user.id, id, body);
  }

  @Delete(':id')
  @HttpCode(204)
  @ApiNoContentResponse()
  remove(@CurrentUser() user: CurrentUserData, @Param('id', ParseUUIDPipe) id: string) {
    return this.recipes.remove(user.id, id);
  }
}
