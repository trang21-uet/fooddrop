// Recipe sites title pages for search ("Cách làm canh chua cá ngừ thơm ngon không tanh, chuẩn vị miền Trung tại nhà");
// the hub, the reel and the grocery list want the dish ("Canh chua cá ngừ"). Deterministic, no LLM.

// "Cách làm", "2 cách nấu", "Hướng dẫn cách nấu", "Bí quyết làm", "Tự làm", optionally followed by "món".
const HOW_TO_PREFIX =
  /^(?:\d+\s+)?(?:(?:hướng dẫn|bí quyết|mách bạn|công thức)\s+)?(?:\d+\s+)?(?:cách\s+|tự\s+)?(?:làm|nấu|chế biến|sơ chế|ướp|pha|ngâm|muối|nuôi|đổ|gói|cuốn|trộn|xào|kho|chiên|nướng|hấp|luộc)\s+(?:món\s+)?/iu;

// Where the selling begins: punctuation, or a word or phrase that only praises the dish or the method.
const CLAUSE_BREAK = /\s*(?:[,:!?(|–]|\s-\s)/u;
const FILLERS = [
  'thơm ngon', 'thơm lừng', 'thơm béo', 'thơm nức', 'thơm mềm', 'ngon', 'chuẩn vị', 'cực', 'siêu', 'đơn giản',
  'tại nhà', 'ngay tại', 'hấp dẫn', 'đậm đà', 'dễ làm', 'dễ thực hiện', 'không bị', 'không tanh', 'hot trend',
  'bổ dưỡng', 'thanh mát', 'béo ngậy', 'béo bùi', 'giòn rụm', 'giòn tan', 'giòn thơm', 'mềm mịn', 'mềm mọng',
  'mềm xốp', 'bông xốp', 'nở xốp', 'dẻo ngon', 'dẻo mềm', 'dẻo thơm', 'dai ngon', 'dai giòn', 'dai mướt',
  'lạ miệng', 'đưa cơm', 'cho cả', 'cho bữa', 'cho ngày', 'giải nhiệt', 'đãi', 'như nhà hàng', 'đón tết',
  'nhanh chóng', 'tiện lợi', 'độc lạ', 'bằng', 'ngay lần', 'trắng mịn', 'ngọt thịt', 'ngọt lành', 'mát lạnh',
  'uống là', 'ăn là', 'đại bổ', 'thơm nồng', 'giòn ngon', 'sánh mịn', 'vàng giòn', 'mềm ngon', 'với nồi', 'trong nồi',
];
const FILLER_AT = new RegExp(`\\s(?:${FILLERS.join('|')})(?=\\s|$)`, 'giu');

const lower = (text: string): string => text.normalize('NFC').toLocaleLowerCase('vi');
const wordCount = (text: string): number => text.split(/\s+/).filter(Boolean).length;
const capitalize = (text: string): string => text.charAt(0).toLocaleUpperCase('vi') + text.slice(1);

/**
 * The dish name inside a how-to title. Prefers the longest source keyword (2+ words) that starts the title
 * once the "Cách làm" prefix is gone, since sites tag pages with the dish name; otherwise cuts at the first
 * comma or praise word. Titles without a how-to prefix only lose a trailing clause after punctuation.
 */
export function shortenRecipeTitle(title: string, keywords: readonly string[] = []): string {
  const original = title.trim().replace(/\s+/g, ' ');
  const rest = original.replace(HOW_TO_PREFIX, '');
  const hasPrefix = rest !== original;

  const head = lower(rest);
  const keyword = keywords
    .map((item) => lower(item.trim()))
    .filter((item) => wordCount(item) >= 2 && head.startsWith(item) && /^(?:\s|$|[,:!?(])/u.test(head.slice(item.length)))
    .sort((a, b) => b.length - a.length)[0];

  let dish = keyword && hasPrefix ? rest.slice(0, keyword.length) : (rest.split(CLAUSE_BREAK)[0] ?? rest);
  if (hasPrefix && !keyword) {
    // Keep at least two words, so "Bánh ngon" style names are not reduced to "Bánh".
    const cut = [...dish.matchAll(FILLER_AT)].find((match) => wordCount(dish.slice(0, match.index)) >= 2);
    if (cut) dish = dish.slice(0, cut.index);
  }
  dish = dish.trim();
  return dish ? capitalize(dish) : original;
}
