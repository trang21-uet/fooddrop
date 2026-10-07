import type { QuantityUnit } from '../../database/schema/ingredients.schema.js';
import { foldUnitText } from '../units/unit-table.js';

export interface CatalogIngredient {
  id: string;
  name: string;
  aliases: string[];
  defaultUnit: QuantityUnit;
  densityGPerMl: number | null;
}

// Below this Dice score a "match" is more likely a different ingredient than a spelling variant.
const FUZZY_THRESHOLD = 0.7;
// Dice rewards shared prefixes, so "chicken" would match "chicken stock"; similar lengths rule that out.
const MIN_LENGTH_RATIO = 0.6;

/** Lowercase, no diacritics, no parentheticals or punctuation: "Hành lá (xắt nhỏ)" -> "hanh la". */
export function foldIngredientName(name: string): string {
  return foldUnitText(name.replace(/\([^)]*\)/g, ' '))
    .replace(/[^a-z0-9 ]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

const LEADING_DESCRIPTORS = new Set(['large', 'small', 'medium', 'big', 'fresh', 'ripe', 'organic', 'raw']);
const TRAILING_DESCRIPTORS = new Set(['wedge', 'wedges', 'slice', 'slices', 'chunk', 'chunks', 'cube', 'cubes']);

function singular(word: string): string {
  if (word.length > 4 && word.endsWith('ies')) return `${word.slice(0, -3)}y`;
  if (word.length > 4 && word.endsWith('oes')) return word.slice(0, -2);
  return word.length > 3 && word.endsWith('s') && !word.endsWith('ss') ? word.slice(0, -1) : word;
}

/** Names to try, most literal first: as written, without size/cut words ("large eggs"), and singularized. */
export function nameVariants(folded: string): string[] {
  if (!folded) return [];
  const words = folded.split(' ');
  while (words.length > 1 && LEADING_DESCRIPTORS.has(words[0]!)) words.shift();
  while (words.length > 1 && TRAILING_DESCRIPTORS.has(words[words.length - 1]!)) words.pop();
  const asWritten = [folded, words.join(' ')];
  const singularized = asWritten.map((variant) => {
    const parts = variant.split(' ');
    parts[parts.length - 1] = singular(parts[parts.length - 1]!);
    return parts.join(' ');
  });
  return [...new Set([...asWritten, ...singularized])];
}

function trigrams(text: string): Set<string> {
  const padded = `  ${text} `;
  const grams = new Set<string>();
  for (let i = 0; i + 3 <= padded.length; i++) grams.add(padded.slice(i, i + 3));
  return grams;
}

/** Sørensen–Dice over trigrams: 1 for identical strings, ~0 for unrelated ones. */
export function trigramSimilarity(a: Set<string>, b: Set<string>): number {
  if (a.size === 0 || b.size === 0) return 0;
  let shared = 0;
  for (const gram of a) if (b.has(gram)) shared++;
  return (2 * shared) / (a.size + b.size);
}

interface Candidate {
  length: number;
  ingredient: CatalogIngredient;
  grams: Set<string>;
}

/**
 * Builds a matcher once per job (the catalog is a few hundred rows). Order: exact name/alias, then
 * best trigram similarity. Null means "not in the catalog", so the client offers to create it.
 */
export function createIngredientMatcher(catalog: CatalogIngredient[]): (name: string) => CatalogIngredient | null {
  const exact = new Map<string, CatalogIngredient>();
  const candidates = new Map<string, Candidate>();
  for (const ingredient of catalog) {
    for (const term of [ingredient.name, ...ingredient.aliases]) {
      const folded = foldIngredientName(term);
      if (!folded) continue;
      // The first catalog entry to claim a term keeps it, so aliases cannot steal another name.
      if (!exact.has(folded)) exact.set(folded, ingredient);
      if (!candidates.has(folded)) candidates.set(folded, { ingredient, length: folded.length, grams: trigrams(folded) });
    }
  }

  return (name) => {
    const variants = nameVariants(foldIngredientName(name));
    for (const variant of variants) {
      const hit = exact.get(variant);
      if (hit) return hit;
    }

    let best: { score: number; ingredient: CatalogIngredient } | null = null;
    for (const variant of variants) {
      const grams = trigrams(variant);
      for (const candidate of candidates.values()) {
        if (Math.min(variant.length, candidate.length) / Math.max(variant.length, candidate.length) < MIN_LENGTH_RATIO) continue;
        const score = trigramSimilarity(grams, candidate.grams);
        if (score >= FUZZY_THRESHOLD && (!best || score > best.score)) best = { score, ingredient: candidate.ingredient };
      }
    }
    return best?.ingredient ?? null;
  };
}

export interface CatalogTag {
  id: number;
  slug: string;
  label: string;
}

/** Maps LLM tag slugs or free-form JSON-LD keywords onto catalog tags by slug or label. */
export function matchTagIds(suggestions: string[], tags: CatalogTag[]): number[] {
  const byTerm = new Map<string, number>();
  for (const tag of tags) {
    byTerm.set(foldIngredientName(tag.slug), tag.id);
    byTerm.set(foldIngredientName(tag.label), tag.id);
  }
  const ids = new Set<number>();
  for (const suggestion of suggestions) {
    const id = byTerm.get(foldIngredientName(suggestion));
    if (id !== undefined) ids.add(id);
  }
  return [...ids];
}
