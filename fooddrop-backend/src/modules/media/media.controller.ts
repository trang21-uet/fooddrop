import { Body, Controller, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiZodBody, ApiZodCreated } from '../../common/zod-dto.js';
import { CurrentUser, type CurrentUserData } from '../auth/current-user.decorator.js';
import { CreateUploadDto, UploadTargetDto } from './media.schemas.js';
import { ObjectStorageService } from './object-storage.service.js';

@ApiTags('media')
@ApiBearerAuth()
@Controller('media')
export class MediaController {
  constructor(private readonly storage: ObjectStorageService) {}

  /** Signed PUT for a cookbook photo; the client uploads straight to object storage. */
  @Post('uploads')
  @ApiZodBody(CreateUploadDto)
  @ApiZodCreated(UploadTargetDto)
  createUpload(@CurrentUser() user: CurrentUserData, @Body() body: CreateUploadDto) {
    return this.storage.createUploadTarget(user.id, body);
  }
}
