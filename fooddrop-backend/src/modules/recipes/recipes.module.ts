import { Module } from '@nestjs/common';
import { MediaModule } from '../media/media.module.js';
import { UnitsModule } from '../units/units.module.js';
import { RecipesController } from './recipes.controller.js';
import { RecipesReaderService } from './recipes-reader.service.js';
import { RecipesService } from './recipes.service.js';

@Module({
  imports: [UnitsModule, MediaModule],
  controllers: [RecipesController],
  providers: [RecipesService, RecipesReaderService],
})
export class RecipesModule {}
