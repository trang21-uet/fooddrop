import { writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module.js';
import { createOpenApiDocument } from './create-openapi-document.js';

// Preview mode builds the module graph without instantiating providers,
// so no Postgres/Redis connection is needed to emit the contract.
async function generate(): Promise<void> {
  const app = await NestFactory.create(AppModule, { preview: true, logger: false });
  const document = createOpenApiDocument(app);
  const outFile = resolve(process.cwd(), 'openapi.json');
  await writeFile(outFile, `${JSON.stringify(document, null, 2)}\n`);
  await app.close();
  console.log(`OpenAPI written to ${outFile}`);
}

await generate();
