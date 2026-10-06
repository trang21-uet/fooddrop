import { ApiProperty } from '@nestjs/swagger';

export type DependencyStatus = 'up' | 'down';

export class HealthChecksDto {
  @ApiProperty({ enum: ['up', 'down'] })
  postgres: DependencyStatus;

  @ApiProperty({ enum: ['up', 'down'] })
  redis: DependencyStatus;
}

export class HealthResponseDto {
  @ApiProperty({ enum: ['ok', 'error'] })
  status: 'ok' | 'error';

  @ApiProperty({ type: HealthChecksDto })
  checks: HealthChecksDto;
}
