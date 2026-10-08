import { applyDecorators } from '@nestjs/common';
import { ApiBody, ApiCreatedResponse, ApiOkResponse, ApiQuery, ApiResponse } from '@nestjs/swagger';
import type { OpenAPIObject, SchemaObject } from '@nestjs/swagger';
import { z } from 'zod';

type JsonSchemaIo = 'input' | 'output';

export interface ZodDto<S extends z.ZodType = z.ZodType> {
  new (): z.output<S>;
  schema: S;
  schemaName: string;
}

const registry = new Map<string, { schema: z.ZodType; io: JsonSchemaIo }>();

/**
 * One Zod schema drives runtime validation, the TypeScript type and the OpenAPI component,
 * so the generated web/mobile clients never drift from what the server accepts.
 * Use `input` for request bodies/queries and `output` for responses (defaults become required).
 */
export function createZodDto<S extends z.ZodType>(
  name: string,
  schema: S,
  io: JsonSchemaIo = 'input',
): ZodDto<S> {
  registry.set(name, { schema, io });
  class Dto {
    static schema = schema;
    static schemaName = name;
  }
  return Dto as unknown as ZodDto<S>;
}

const ref = (dto: ZodDto) => ({ $ref: `#/components/schemas/${dto.schemaName}` });

export const ApiZodBody = (dto: ZodDto) => ApiBody({ schema: ref(dto) });

export const ApiZodOk = (dto: ZodDto, options: { isArray?: boolean } = {}) =>
  ApiOkResponse({ schema: options.isArray ? { type: 'array', items: ref(dto) } : ref(dto) });

export const ApiZodCreated = (dto: ZodDto) => ApiCreatedResponse({ schema: ref(dto) });

/** Documents an error status whose body has its own shape, so clients get a generated type for it too. */
export const ApiZodError = (status: number, dto: ZodDto, description: string, headers?: Record<string, { description: string; schema: SchemaObject }>) =>
  ApiResponse({ status, description, schema: ref(dto), headers });

/** Declares each field of an object-shaped query schema as an OpenAPI query parameter. */
export function ApiZodQuery(dto: { schema: z.ZodObject }) {
  const decorators = Object.entries(dto.schema.shape).map(([name, field]) => {
    const { description: _description, ...schema } = z.toJSONSchema(field, {
      target: 'openapi-3.0',
      io: 'input',
      unrepresentable: 'any',
    });
    return ApiQuery({ name, required: !field.isOptional(), schema: schema as SchemaObject });
  });
  return applyDecorators(...decorators);
}

/** Fills `components.schemas` from every registered Zod DTO; call after SwaggerModule.createDocument. */
export function attachZodSchemas(document: OpenAPIObject): OpenAPIObject {
  const schemas = (document.components ??= {}).schemas ?? (document.components.schemas = {});
  for (const [name, { schema, io }] of registry) {
    schemas[name] = z.toJSONSchema(schema, {
      target: 'openapi-3.0',
      io,
      unrepresentable: 'any',
    }) as (typeof schemas)[string];
  }
  return document;
}
