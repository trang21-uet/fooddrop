import { Module } from '@nestjs/common';
import { MediaModule } from '../media/media.module.js';
import { GachaController } from './gacha.controller.js';
import { GachaService } from './gacha.service.js';
import { SpinRateLimit } from './spin-rate-limit.js';

@Module({
  imports: [MediaModule],
  controllers: [GachaController],
  providers: [GachaService, SpinRateLimit],
})
export class GachaModule {}
