import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_PIPE } from '@nestjs/core';
import { AuthModule } from '@thallesp/nestjs-better-auth';
import { ZodValidationPipe } from './common/zod-validation.pipe.js';
import { validateEnv, type Env } from './config/env.schema.js';
import { DRIZZLE, DatabaseModule, type Database } from './database/database.module.js';
import { RedisModule } from './redis/redis.module.js';
import { createAuth } from './modules/auth/create-auth.js';
import { HealthModule } from './modules/health/health.module.js';
import { MediaModule } from './modules/media/media.module.js';
import { ParserModule } from './modules/parser/parser.module.js';
import { IngredientsModule } from './modules/ingredients/ingredients.module.js';
import { RecipesModule } from './modules/recipes/recipes.module.js';
import { TagsModule } from './modules/tags/tags.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, validate: validateEnv }),
    DatabaseModule,
    RedisModule,
    AuthModule.forRootAsync({
      inject: [ConfigService, DRIZZLE],
      useFactory: (config: ConfigService<Env, true>, db: Database) => {
        const clientId = config.get('GOOGLE_CLIENT_ID', { infer: true });
        const clientSecret = config.get('GOOGLE_CLIENT_SECRET', { infer: true });
        return {
          auth: createAuth(db, {
            secret: config.get('AUTH_SECRET', { infer: true }),
            baseURL: config.get('BETTER_AUTH_URL', { infer: true }),
            trustedOrigins: config
              .get('CORS_ORIGINS', { infer: true })
              .split(',')
              .map((origin) => origin.trim())
              .filter(Boolean),
            google: clientId && clientSecret ? { clientId, clientSecret } : undefined,
          }),
        };
      },
    }),
    HealthModule,
    IngredientsModule,
    TagsModule,
    RecipesModule,
    MediaModule,
    ParserModule,
  ],
  providers: [{ provide: APP_PIPE, useClass: ZodValidationPipe }],
})
export class AppModule {}
