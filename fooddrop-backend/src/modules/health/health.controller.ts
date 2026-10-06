import { Controller, Get, ServiceUnavailableException } from '@nestjs/common';
import { AllowAnonymous } from '@thallesp/nestjs-better-auth';
import { ApiOkResponse, ApiServiceUnavailableResponse, ApiTags } from '@nestjs/swagger';
import { HealthService } from './health.service.js';
import { HealthResponseDto } from './health.schemas.js';

@ApiTags('health')
@AllowAnonymous()
@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  @ApiOkResponse({ type: HealthResponseDto })
  @ApiServiceUnavailableResponse({ type: HealthResponseDto })
  async getHealth(): Promise<HealthResponseDto> {
    const result = await this.healthService.check();
    if (result.status !== 'ok') throw new ServiceUnavailableException(result);
    return result;
  }
}
