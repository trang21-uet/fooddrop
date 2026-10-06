import type { INestApplication } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule, type OpenAPIObject } from '@nestjs/swagger';
import { attachZodSchemas } from '../common/zod-dto.js';

/** Single source for the OpenAPI contract consumed by web and mobile clients. */
export function createOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('Food Drop API')
    .setVersion('0.1.0')
    .addBearerAuth()
    .build();
  return attachZodSchemas(SwaggerModule.createDocument(app, config));
}
