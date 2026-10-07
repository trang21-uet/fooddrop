import { htmlToLines, htmlToText } from './html-text.js';
import { isoDurationToMinutes } from './iso-duration.js';
import { parseIngredientLine } from './parse-ingredient-line.js';
import { rawRecipeSchema, type RawRecipe } from './parser.schemas.js';

type Json = Record<string, unknown>;

const SCRIPT_PATTERN = /<script\b[^>]*type\s*=\s*["']application\/ld\+json["'][^>]*>([\s\S]*?)<\/script>/gi;

const isObject = (value: unknown): value is Json => typeof value === 'object' && value !== null && !Array.isArray(value);
const asArray = (value: unknown): unknown[] => (Array.isArray(value) ? value : value === undefined ? [] : [value]);

function hasRecipeType(node: Json): boolean {
  return asArray(node['@type']).some((type) => typeof type === 'string' && /(^|\/)Recipe$/i.test(type));
}

/** Finds the first Recipe node in top-level objects, arrays, `@graph` and `mainEntity` wrappers. */
function findRecipeNode(value: unknown, depth = 0): Json | null {
  if (depth > 4) return null;
  if (Array.isArray(value)) {
    for (const item of value) {
      const found = findRecipeNode(item, depth + 1);
      if (found) return found;
    }
    return null;
  }
  if (!isObject(value)) return null;
  if (hasRecipeType(value)) return value;
  return findRecipeNode(value['@graph'], depth + 1) ?? findRecipeNode(value['mainEntity'], depth + 1);
}

/** Real-world markup is sloppy; truncating beats rejecting a whole recipe over one long field. */
const clip = (text: string, max: number): string => (text.length > max ? text.slice(0, max) : text);

function firstText(value: unknown): string | null {
  for (const item of asArray(value)) {
    if (typeof item === 'string' && item.trim()) return htmlToText(item);
    if (isObject(item) && typeof item['name'] === 'string') return htmlToText(item['name']);
  }
  return null;
}

function firstImageUrl(value: unknown): string | null {
  for (const item of asArray(value)) {
    if (typeof item === 'string' && item.trim()) return item.trim();
    if (isObject(item) && typeof item['url'] === 'string') return item['url'].trim();
  }
  return null;
}

/** "4 servings", "Makes 12", 6 or ["4", "4 servings"] -> first number found. */
function yieldToServings(value: unknown): number | null {
  for (const item of asArray(value)) {
    const match = /\d+/.exec(String(item));
    if (match) return Number(match[0]);
  }
  return null;
}

/** HowToStep, HowToSection (nested itemListElement), plain strings and HTML blobs all flatten to lines. */
function collectSteps(value: unknown): string[] {
  if (typeof value === 'string') return htmlToLines(value);
  if (Array.isArray(value)) return value.flatMap(collectSteps);
  if (!isObject(value)) return [];
  if (value['itemListElement'] !== undefined) return collectSteps(value['itemListElement']);
  const text = value['text'] ?? value['name'];
  return typeof text === 'string' ? htmlToLines(text) : [];
}

function collectTags(node: Json): string[] {
  const keywords = asArray(node['keywords']).flatMap((item) => (typeof item === 'string' ? item.split(',') : []));
  const labelled = [...asArray(node['recipeCuisine']), ...asArray(node['recipeCategory'])];
  return [...labelled, ...keywords]
    .filter((item): item is string => typeof item === 'string')
    .map((item) => item.trim())
    .filter(Boolean)
    .slice(0, 20);
}

function totalMinutes(node: Json): number | null {
  const total = isoDurationToMinutes(node['totalTime']);
  if (total) return total;
  const parts = [isoDurationToMinutes(node['prepTime']), isoDurationToMinutes(node['cookTime'])];
  const sum = parts.reduce<number>((acc, part) => acc + (part ?? 0), 0);
  return sum > 0 ? sum : null;
}

function toRawRecipe(node: Json): RawRecipe | null {
  const ingredients = asArray(node['recipeIngredient'] ?? node['ingredients'])
    .filter((line): line is string => typeof line === 'string')
    .map((line) => htmlToText(line))
    .filter(Boolean)
    .map(parseIngredientLine)
    .map((line) => ({ ...line, name: clip(line.name, 200), note: line.note && clip(line.note, 300) }));
  const steps = collectSteps(node['recipeInstructions']).map((text) => ({ text: clip(text, 4000) }));
  // Without ingredients and steps the markup is metadata only; let the LLM read the page instead.
  if (ingredients.length === 0 || steps.length === 0) return null;

  const parsed = rawRecipeSchema.safeParse({
    title: clip(firstText(node['name']) ?? '', 200),
    description: clip(firstText(node['description']) ?? '', 2000) || null,
    imageUrl: firstImageUrl(node['image']),
    servings: yieldToServings(node['recipeYield']),
    totalMinutes: totalMinutes(node),
    ingredients,
    steps,
    suggestedTags: collectTags(node),
  });
  return parsed.success ? parsed.data : null;
}

/** Free path: sites that publish schema.org/Recipe JSON-LD need no LLM call. Null when absent or unusable. */
export function extractJsonLdRecipe(html: string): RawRecipe | null {
  for (const match of html.matchAll(SCRIPT_PATTERN)) {
    let json: unknown;
    try {
      json = JSON.parse(match[1]!.trim());
    } catch {
      continue;
    }
    const node = findRecipeNode(json);
    const recipe = node ? toRawRecipe(node) : null;
    if (recipe) return recipe;
  }
  return null;
}
