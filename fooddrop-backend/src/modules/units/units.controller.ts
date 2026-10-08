import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ApiZodOk } from '../../common/zod-dto.js';
import { UnitDto } from './units.schemas.js';
import { UnitsService } from './units.service.js';

@ApiTags('units')
@ApiBearerAuth()
@Controller('units')
export class UnitsController {
  constructor(private readonly unitsService: UnitsService) {}

  /** Every unit a recipe ingredient can use, in picker order. */
  @Get()
  @ApiZodOk(UnitDto, { isArray: true })
  list() {
    return this.unitsService.list();
  }
}
