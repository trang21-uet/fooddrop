import { NestFactory } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module.js';
import type { Env } from './config/env.schema.js';
import { createOpenApiDocument } from './openapi/create-openapi-document.js';

async function bootstrap(): Promise<void> {
  // Better Auth reads the raw request body, so Nest's parser is off; AuthModule re-adds it for other routes.
  const app = await NestFactory.create(AppModule, { bodyParser: false });
  const config = app.get<ConfigService<Env, true>>(ConfigService);

  const corsOrigins = config
    .get('CORS_ORIGINS', { infer: true })
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
  // credentials: cookie sessions on web; set-auth-token: bearer token that browser clients read at sign-in.
  app.enableCors({ origin: corsOrigins, credentials: true, exposedHeaders: ['set-auth-token'] });
  app.enableShutdownHooks();
  if (config.get('NODE_ENV', { infer: true }) !== 'production') {
    SwaggerModule.setup('docs', app, createOpenApiDocument(app));
  }

  await app.listen(config.get('PORT', { infer: true }));
}
await bootstrap();
