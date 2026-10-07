import { Module } from '@nestjs/common';
import { MediaController } from './media.controller.js';
import { ObjectStorageService } from './object-storage.service.js';

@Module({
  controllers: [MediaController],
  providers: [ObjectStorageService],
  exports: [ObjectStorageService],
})
export class MediaModule {}
