const UNICODE_FRACTIONS: Record<string, string> = {
  '½': '1/2', '⅓': '1/3', '⅔': '2/3', '¼': '1/4', '¾': '3/4',
  '⅛': '1/8', '⅜': '3/8', '⅝': '5/8', '⅞': '7/8',
};

function parseSimple(text: string): number | null {
  const mixed = /^(\d+)\s+(\d+)\/(\d+)$/.exec(text);
  if (mixed) return divide(Number(mixed[1]) * Number(mixed[3]) + Number(mixed[2]), Number(mixed[3]));
  const fraction = /^(\d+)\/(\d+)$/.exec(text);
  if (fraction) return divide(Number(fraction[1]), Number(fraction[2]));
  // "1,000" / "12,500.5" are English thousands separators. A comma followed by exactly three digits
  // is treated that way; any other comma is a Vietnamese decimal ("1,5 kg", "0,25").
  if (/^\d{1,3}(,\d{3})+(\.\d+)?$/.test(text)) return Number(text.replaceAll(',', ''));
  // Vietnamese recipes write decimals with a comma ("1,5 kg").
  if (/^\d+([.,]\d+)?$/.test(text)) return Number(text.replace(',', '.'));
  if (/^[.,]\d+$/.test(text)) return Number(`0${text.replace(',', '.')}`);
  return null;
}

function divide(numerator: number, denominator: number): number | null {
  return denominator === 0 ? null : numerator / denominator;
}

/**
 * Parses a human-written quantity: "2", "1,5", "1/2", "1 1/2", "1½", "2-3", "2 to 3".
 * Ranges resolve to their midpoint. Returns null for anything unparseable.
 */
export function parseQuantity(input: string): number | null {
  const text = input
    .trim()
    .replace(/[½⅓⅔¼¾⅛⅜⅝⅞]/g, (ch) => ` ${UNICODE_FRACTIONS[ch]}`)
    .replace(/\s+/g, ' ')
    .trim();
  if (!text) return null;

  const range = /^(.+?)\s*(?:-|–|—|to|đến)\s*(.+)$/i.exec(text);
  if (range) {
    const low = parseSimple(range[1]!.trim());
    const high = parseSimple(range[2]!.trim());
    if (low === null || high === null || high < low) return null;
    return (low + high) / 2;
  }
  return parseSimple(text);
}
