import { BadRequestException, Injectable, type ArgumentMetadata, type PipeTransform } from '@nestjs/common';
import { z } from 'zod';
import type { ZodDto } from './zod-dto.js';

/** Global pipe: validates any @Body()/@Query() typed with a `createZodDto` class. */
@Injectable()
export class ZodValidationPipe implements PipeTransform {
  transform(value: unknown, metadata: ArgumentMetadata): unknown {
    const schema = (metadata.metatype as Partial<ZodDto> | undefined)?.schema;
    if (!schema || metadata.type === 'custom') return value;

    const result = schema.safeParse(value);
    if (!result.success) {
      throw new BadRequestException({
        statusCode: 400,
        error: 'Bad Request',
        message: z.prettifyError(result.error),
        issues: result.error.issues.map((issue) => ({
          path: issue.path.join('.'),
          message: issue.message,
        })),
      });
    }
    return result.data;
  }
}
