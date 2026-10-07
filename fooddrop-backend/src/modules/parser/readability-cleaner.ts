import { Readability } from '@mozilla/readability';
import { parseHTML } from 'linkedom';

// Keeps LLM cost bounded; recipe content sits near the top of the article body.
const MAX_TEXT_CHARS = 30_000;

/** Strips navigation, ads and scripts, leaving the article text the LLM should read. */
export function cleanHtmlToText(html: string): string {
  const { document } = parseHTML(html);
  for (const node of document.querySelectorAll('script, style, noscript, template, iframe, svg')) node.remove();

  let text = '';
  try {
    // Readability is tuned for articles; recipe pages usually qualify.
    const article = new Readability(document as unknown as Document, { charThreshold: 200 }).parse();
    text = article?.textContent ?? '';
  } catch {
    // Malformed DOMs make Readability throw; the body text below is a fine fallback.
  }
  if (text.trim().length < 200) text = document.body?.textContent ?? text;

  return text
    .replace(/[ \t ]+/g, ' ')
    .replace(/\s*\n\s*/g, '\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim()
    .slice(0, MAX_TEXT_CHARS);
}
