import type { components } from "@/lib/api/schema";

type Schemas = components["schemas"];

export type ParseJob = Schemas["ParseJob"];
export type ParsedRecipeDraft = NonNullable<ParseJob["result"]>;
export type ParseErrorCode = NonNullable<ParseJob["errorCode"]>;
