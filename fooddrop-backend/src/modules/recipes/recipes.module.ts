import { Module } from '@nestjs/common';
import { RecipesController } from './recipes.controller.js';
import { RecipesReaderService } from './recipes-reader.service.js';
import { RecipesService } from './recipes.service.js';

@Module({
  controllers: [RecipesController],
  providers: [RecipesService, RecipesReaderService],
})
export class RecipesModule {}
