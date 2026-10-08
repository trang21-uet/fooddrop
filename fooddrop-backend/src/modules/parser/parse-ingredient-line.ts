import { lookupUnitAlias } from '../units/unit-aliases.js';

export interface ParsedIngredientLine {
  name: string;
  /** Raw, as written ("1 1/2", "2-3"); converted later by the units module. */
  quantity: string | null;
  unit: string | null;
  note: string | null;
}

const UNICODE_FRACTIONS: Record<string, string> = {
  '½': '1/2', '⅓': '1/3', '⅔': '2/3', '¼': '1/4', '¾': '3/4', '⅛': '1/8',
};

const NUMBER = String.raw`(?:\d+\s+\d+\/\d+|\d+\/\d+|\d+(?:[.,]\d+)?|[.,]\d+)`;
const LEADING_QUANTITY = new RegExp(String.raw`^(${NUMBER}(?:\s*(?:-|–|—|to|đến)\s*${NUMBER})?)\s*`, 'iu');
// "Thịt bò 300g" / "Hành lá: 2 cây": Vietnamese recipes often put the amount after the name.
const TRAILING_AMOUNT = new RegExp(String.raw`^(.+?)\s*[:\-–]?\s+(${NUMBER})\s*(\p{L}+)?$`, 'u');
// Trailing wording that qualifies the amount, not the ingredient: "to taste", "to serve", "plus extra for frying".
const AMOUNT_QUALIFIER =
  /(?:\s*,\s*|\s+)(to taste|to serve|as needed|for serving|for frying|for dusting|for greasing|for brushing|for garnish(?:ing)?|plus .+|vừa đủ|tùy thích|tuỳ thích|tùy ý|tuỳ ý)\.?$/iu;

/** Longest unit first so "muỗng canh" wins over a stray "muỗng". Returns the remainder after the unit. */
function takeUnit(text: string): { unit: string; rest: string } | null {
  const words = text.split(/\s+/);
  for (const count of [2, 1]) {
    if (words.length < count) continue;
    const candidate = words.slice(0, count).join(' ').replace(/[.,]$/, '');
    if (lookupUnitAlias(candidate)) return { unit: candidate, rest: words.slice(count).join(' ') };
  }
  return null;
}

/**
 * Splits one free-text ingredient line ("2 cups all-purpose flour, sifted", "200g thịt bò") into
 * quantity, unit, name and note. Deterministic best effort for the JSON-LD path, where the
 * source gives a single string per ingredient; the user reviews the draft before saving.
 */
export function parseIngredientLine(line: string): ParsedIngredientLine {
  const notes: string[] = [];
  let text = line
    .replace(/[½⅓⅔¼¾⅛]/g, (ch) => ` ${UNICODE_FRACTIONS[ch]} `)
    .replace(/^[\s\-•*·]+/, '')
    .replace(/\(([^)]*)\)/g, (_match, inner: string) => {
      if (inner.trim()) notes.push(inner.trim());
      return ' ';
    })
    .replace(/\s+/g, ' ')
    .trim();

  const qualifier = AMOUNT_QUALIFIER.exec(text);
  if (qualifier) {
    notes.push(qualifier[1]!);
    text = text.slice(0, qualifier.index).trim();
  }
  // "1,5 kg" has a comma without a following space, so only ", word" starts a preparation note.
  const comma = /,\s+(?=\D)/.exec(text);
  if (comma) {
    notes.push(text.slice(comma.index + comma[0].length).trim());
    text = text.slice(0, comma.index).trim();
  }

  let quantity: string | null = null;
  let unit: string | null = null;
  let name = text;

  const leading = LEADING_QUANTITY.exec(text);
  if (leading) {
    quantity = leading[1]!.trim();
    let rest = text.slice(leading[0].length);
    const taken = takeUnit(rest);
    if (taken) {
      unit = taken.unit;
      rest = taken.rest;
    }
    name = rest.replace(/^(?:of|của)\s+/i, '');
  } else {
    const trailing = TRAILING_AMOUNT.exec(text);
    if (trailing && (!trailing[3] || lookupUnitAlias(trailing[3]))) {
      name = trailing[1]!.replace(/[:\-–]$/, '');
      quantity = trailing[2]!;
      unit = trailing[3] ?? null;
    }
  }

  return {
    name: name.trim() || line.trim(),
    quantity,
    unit,
    note: notes.length > 0 ? notes.join('; ') : null,
  };
}
