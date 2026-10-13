import { parseHTML } from 'linkedom';
import { htmlToLines, htmlToText } from './html-text.js';
import { splitAmount } from './parse-ingredient-line.js';
import type { RawRecipe } from './parser.schemas.js';

const HOST = /(^|\.)dienmayxanh\.com$/i;
const NOTE_LABEL = /^\s*(lưu ý|mẹo|chú ý)\s*:?\s*/iu;
const MAX_STEP_PHOTOS = 10;
// The site's "Độ khó" labels on the app's 1..5 scale ("Trung bình" is the middle, 3).
const DIFFICULTY: Record<string, number> = { 'rất dễ': 1, dễ: 2, 'trung bình': 3, khó: 4, 'rất khó': 5 };

type Scope = ReturnType<typeof parseHTML>['document'];
type Node = NonNullable<ReturnType<Scope['querySelector']>>;

/** Per-version sections of a "Vào bếp" page; title, times and tags still come from its JSON-LD. */
export type DienMayXanhSections = Pick<RawRecipe, 'ingredients' | 'steps'> & {
  servings: number | null;
  difficulty: number | null;
};

const textOf = (node: Node | null | undefined): string => htmlToText(node?.textContent ?? '');
const clip = (text: string, max: number): string => (text.length > max ? text.slice(0, max) : text);

/** `<span>Đùi gà <small>650 gr</small> <em>(khoảng 5 cái)</em></span>`: name, amount, note. */
function readIngredient(span: Node): RawRecipe['ingredients'][number] | null {
  const amount = textOf(span.querySelector('small'));
  const extra = textOf(span.querySelector('em')).replace(/^\((.*)\)$/, '$1');
  for (const child of span.querySelectorAll('small, em')) child.remove();
  const name = textOf(span);
  if (!name) return null;
  const { quantity, unit, note: wording } = splitAmount(amount);
  const note = [wording, extra].filter(Boolean).join('; ');
  return { name: clip(name, 200), quantity, unit: unit && clip(unit, 40), note: note ? clip(note, 300) : null };
}

function photoUrls(step: Node, pageUrl: string): string[] {
  const urls: string[] = [];
  for (const img of step.querySelectorAll('.box-gallery img')) {
    const src = img.getAttribute('data-src') || img.getAttribute('src');
    if (!src) continue;
    try {
      urls.push(new URL(src, pageUrl).toString());
    } catch {
      // A malformed src is not worth failing the import over.
    }
  }
  return [...new Set(urls)].slice(0, MAX_STEP_PHOTOS);
}

/** `.text-method`: `<h3>` heading, `<p>` lines (one step), `.tipsrecipe` "Lưu ý", `.box-gallery` photos. */
function readStep(step: Node, pageUrl: string): RawRecipe['steps'][number] | null {
  const name = textOf(step.querySelector('h3'));
  const note = [...step.querySelectorAll('.tipsrecipe')].map((tip) => textOf(tip).replace(NOTE_LABEL, '')).filter(Boolean).join('\n');
  const imageUrls = photoUrls(step, pageUrl);
  for (const child of step.querySelectorAll('h3, .tipsrecipe, .box-gallery')) child.remove();
  const text = htmlToLines(step.innerHTML).join('\n');
  if (!text) return null;
  return {
    ...(name ? { name: clip(name, 200) } : {}),
    text: clip(text, 4000),
    ...(note ? { note: clip(note, 1000) } : {}),
    ...(imageUrls.length > 0 ? { imageUrls } : {}),
  };
}

/**
 * Điện máy XANH merges every version of a dish into one JSON-LD Recipe and flattens each step's
 * heading, lines and "Lưu ý" into plain text. The HTML keeps them apart, so ingredients and steps
 * are read from the first version (`.box-recipe`, or the page itself when there is only one).
 */
export function extractDienMayXanhSections(html: string, pageUrl: string): DienMayXanhSections | null {
  try {
    if (!HOST.test(new URL(pageUrl).hostname)) return null;
  } catch {
    return null;
  }
  const { document } = parseHTML(html);
  const scope = document.querySelector('.box-recipe') ?? document;
  const staple = scope.querySelector('.staple');
  const method = scope.querySelector('.method');
  if (!staple || !method) return null;

  const ingredients = [...staple.querySelectorAll('span')]
    .filter((span) => span.parentElement === staple)
    .map(readIngredient)
    .filter((item) => item !== null)
    .slice(0, 100);
  const steps = [...method.querySelectorAll('.text-method')]
    .map((step) => readStep(step, pageUrl))
    .filter((step) => step !== null)
    .slice(0, 100);
  if (ingredients.length === 0 || steps.length === 0) return null;

  const servings = /\d+/.exec(textOf(staple.querySelector('h2 small')));
  const difficulty = DIFFICULTY[textOf(scope.querySelector('.difficultLevel')).toLowerCase()] ?? null;
  return { ingredients, steps, servings: servings ? Number(servings[0]) : null, difficulty };
}
