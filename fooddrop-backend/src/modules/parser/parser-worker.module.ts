import { Module } from '@nestjs/common';
import { MediaModule } from '../media/media.module.js';
import { ClaudeRecipeExtractor } from './claude-recipe-extractor.js';
import { ParseJobWorker } from './parse-job.worker.js';
import { RecipeParsePipeline } from './recipe-parse-pipeline.service.js';

@Module({
  imports: [MediaModule],
  providers: [ClaudeRecipeExtractor, RecipeParsePipeline, ParseJobWorker],
})
export class ParserWorkerModule {}
