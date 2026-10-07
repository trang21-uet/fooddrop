import { Module } from '@nestjs/common';
import { ThrottlerModule } from '@nestjs/throttler';
import { UserThrottlerGuard } from '../../common/user-throttler.guard.js';
import { ParseQueue } from './parse-queue.js';
import { ParserController } from './parser.controller.js';
import { ParserService } from './parser.service.js';

/** API side only: validates, enqueues and serves job state. The BullMQ worker lives in ParserWorkerModule. */
@Module({
  imports: [ThrottlerModule.forRoot([{ ttl: 60_000, limit: 15 }])],
  controllers: [ParserController],
  providers: [ParserService, ParseQueue, UserThrottlerGuard],
})
export class ParserModule {}
