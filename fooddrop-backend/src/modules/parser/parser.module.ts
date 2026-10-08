import { Module } from '@nestjs/common';
import { ParseCooldown } from './parse-cooldown.js';
import { ParseQueue } from './parse-queue.js';
import { ParserController } from './parser.controller.js';
import { ParserService } from './parser.service.js';

/** API side only: validates, enqueues and serves job state. The BullMQ worker lives in ParserWorkerModule. */
@Module({
  controllers: [ParserController],
  providers: [ParserService, ParseQueue, ParseCooldown],
})
export class ParserModule {}
