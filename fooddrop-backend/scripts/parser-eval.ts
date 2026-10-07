// Live evaluation of the recipe parser against a curated source list. NOT part of CI: it hits real
// sites and, for pages without JSON-LD and for photos, the paid Claude API.
//
//   pnpm parser:eval -- --token <bearer> [--api http://localhost:4000] [--sources eval/sources.json]
//
// Needs the API and the worker running. Get a bearer token by signing in through
// POST /api/auth/sign-in/email and reading the `set-auth-token` response header.
import { readFile } from 'node:fs/promises';
import { parseArgs } from 'node:util';

interface Source {
  type: 'url' | 'image';
  /** URL, or a local image path for `image`. */
  source: string;
  label?: string;
}

interface Job {
  id: string;
  status: 'queued' | 'running' | 'succeeded' | 'failed';
  errorCode: string | null;
  result: null | {
    source: string;
    ingredients: Array<{ quantity: number; isNew: boolean; note: string | null }>;
    steps: unknown[];
  };
}

const { values } = parseArgs({
  options: {
    token: { type: 'string' },
    api: { type: 'string', default: 'http://localhost:4000' },
    sources: { type: 'string', default: 'eval/sources.json' },
  },
});
if (!values.token) throw new Error('--token is required');
const headers = { authorization: `Bearer ${values.token}`, 'content-type': 'application/json' };

async function call<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${values.api}${path}`, { ...init, headers: { ...headers, ...init?.headers } });
  if (!response.ok) throw new Error(`${init?.method ?? 'GET'} ${path} -> ${response.status}`);
  return (await response.json()) as T;
}

async function startJob(item: Source): Promise<string> {
  if (item.type === 'url') return (await call<Job>('/parser/jobs', { method: 'POST', body: JSON.stringify({ url: item.source }) })).id;
  const bytes = await readFile(item.source);
  const contentType = item.source.endsWith('.png') ? 'image/png' : item.source.endsWith('.webp') ? 'image/webp' : 'image/jpeg';
  const target = await call<{ key: string; uploadUrl: string; headers: Record<string, string> }>('/media/uploads', {
    method: 'POST',
    body: JSON.stringify({ contentType, sizeBytes: bytes.length }),
  });
  const put = await fetch(target.uploadUrl, { method: 'PUT', headers: target.headers, body: new Uint8Array(bytes) });
  if (!put.ok) throw new Error(`upload failed: ${put.status}`);
  return (await call<Job>('/parser/jobs', { method: 'POST', body: JSON.stringify({ imageKey: target.key }) })).id;
}

async function finish(id: string): Promise<{ job: Job; ms: number }> {
  const started = Date.now();
  for (;;) {
    const job = await call<Job>(`/parser/jobs/${id}`);
    if (job.status === 'succeeded' || job.status === 'failed') return { job, ms: Date.now() - started };
    if (Date.now() - started > 120_000) throw new Error('timeout');
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }
}

const sources = JSON.parse(await readFile(values.sources!, 'utf8')) as Source[];
let savable = 0;
for (const item of sources) {
  const label = item.label ?? item.source;
  try {
    const { job, ms } = await finish(await startJob(item));
    const draft = job.result;
    // "Savable with no manual unit fixes": something to cook, and no ingredient whose unit was unknown (quantity 0 + note).
    const ok =
      job.status === 'succeeded' &&
      !!draft &&
      draft.ingredients.length > 0 &&
      draft.steps.length > 0 &&
      draft.ingredients.every((i) => i.quantity > 0 || !i.note);
    if (ok) savable++;
    const unmatched = draft?.ingredients.filter((i) => i.isNew).length ?? 0;
    console.log(
      `${ok ? 'OK  ' : 'FAIL'} ${String(ms).padStart(6)}ms  ${draft?.source ?? job.errorCode ?? job.status}  ` +
        `ing=${draft?.ingredients.length ?? 0} (new ${unmatched}) steps=${draft?.steps.length ?? 0}  ${label}`,
    );
  } catch (error) {
    console.log(`ERR  ${label}: ${error instanceof Error ? error.message : String(error)}`);
  }
}
const rate = sources.length ? Math.round((savable / sources.length) * 100) : 0;
console.log(`\nSavable drafts: ${savable}/${sources.length} (${rate}%) — target >= 85%`);
