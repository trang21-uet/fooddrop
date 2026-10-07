import { parseHTML } from 'linkedom';

const BLOCK_BREAKS = /<\/(?:li|p|div|h[1-6])>|<br\s*\/?>|\n+/i;

/** Plain text of an HTML fragment (JSON-LD fields often carry entities or stray tags). */
export function htmlToText(fragment: string): string {
  if (!/[<&]/.test(fragment)) return fragment.replace(/\s+/g, ' ').trim();
  const { document } = parseHTML(`<!doctype html><html><body>${fragment}</body></html>`);
  return (document.body?.textContent ?? '').replace(/\s+/g, ' ').trim();
}

/** Splits a multi-paragraph string (HTML or newline separated) into cleaned, non-empty lines. */
export function htmlToLines(fragment: string): string[] {
  return fragment
    .split(BLOCK_BREAKS)
    .map(htmlToText)
    .filter((line) => line.length > 0);
}
