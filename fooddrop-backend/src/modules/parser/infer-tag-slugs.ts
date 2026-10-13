// Phrase -> catalog tag slug. Matched on the dish's name, category and keywords, never on step text:
// a "Luộc thịt" step does not make roast pork a boiled dish. Diacritics matter ("kho" ≠ "khô").
const RULES: Array<[slug: string, phrases: string[]]> = [
  // Equipment first: its phrases are removed before techniques, so "nồi chiên không dầu" is not "chiên".
  ['air-fryer', ['nồi chiên không dầu', 'lò chiên không dầu', 'air fryer', 'air-fryer']],
  ['pressure-cooker', ['nồi áp suất', 'pressure cooker', 'instant pot']],
  ['rice-cooker', ['nồi cơm điện', 'rice cooker']],
  ['slow-cooker', ['nồi nấu chậm', 'slow cooker', 'crock pot']],
  ['microwave', ['lò vi sóng', 'microwave']],
  ['oven', ['lò nướng', 'oven']],
  ['steamer', ['nồi hấp', 'xửng hấp']],
  ['blender', ['máy xay', 'blender']],
  ['grill', ['vỉ nướng']],

  ['deep-fry', ['chiên ngập dầu', 'chiên xù', 'deep fried', 'deep-fried', 'deep fry']],
  ['pan-fry', ['chiên', 'rán', 'áp chảo', 'pan fried', 'pan-fried', 'pan fry']],
  ['stir-fry', ['xào', 'stir fry', 'stir-fry', 'stir fried']],
  ['braise', ['kho', 'rim', 'braised']],
  ['steam', ['hấp', 'steamed']],
  ['roast-bake', ['nướng lò', 'đút lò', 'bỏ lò', 'baked', 'roasted']],
  ['grill-technique', ['nướng than', 'grilled', 'bbq', 'barbecue']],
  ['boil', ['luộc', 'boiled']],
  ['simmer', ['hầm', 'ninh', 'stew', 'stewed']],
  ['pickle', ['muối chua', 'ngâm chua', 'dưa muối', 'pickled']],
  ['fermented', ['lên men', 'fermented']],

  ['soup', ['canh', 'súp', 'soup']],
  ['salad', ['gỏi', 'nộm', 'salad']],
  ['dessert', ['chè', 'tráng miệng', 'bánh flan', 'dessert']],
  ['drink', ['đồ uống', 'thức uống', 'nước ép', 'sinh tố', 'trà sữa', 'smoothie', 'juice']],
  ['breakfast', ['bữa sáng', 'ăn sáng', 'breakfast']],
  ['snack', ['ăn vặt', 'snack']],
  ['appetizer', ['khai vị', 'appetizer']],

  ['vegan', ['thuần chay', 'vegan']],
  ['vegetarian', ['món chay', 'ăn chay', 'chay', 'vegetarian']],
  ['gluten-free', ['không gluten', 'gluten free', 'gluten-free']],
  ['low-carb', ['low carb', 'low-carb', 'keto']],
  ['kid-friendly', ['cho bé', 'ăn dặm']],

  ['vietnamese', ['món việt', 'vietnamese']],
  ['japanese', ['nhật bản', 'kiểu nhật', 'món nhật', 'japanese', 'sushi', 'ramen']],
  ['korean', ['hàn quốc', 'kiểu hàn', 'món hàn', 'korean', 'kimchi']],
  ['chinese', ['trung hoa', 'trung quốc', 'món hoa', 'chinese']],
  ['thai', ['thái lan', 'kiểu thái', 'món thái', 'thai']],
  ['indian', ['ấn độ', 'indian']],
  ['italian', ['mì ý', 'kiểu ý', 'món ý', 'italian', 'pasta', 'pizza', 'spaghetti']],
  ['french', ['kiểu pháp', 'món pháp', 'french']],
  ['mexican', ['mexico', 'mexican', 'taco']],
];

const escape = (text: string): string => text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
// Whole words only, so "kho" does not fire on "khoai" nor "rim" on "trim".
const COMPILED = RULES.map(
  ([slug, phrases]) => [slug, new RegExp(`(?<![\\p{L}\\p{N}])(?:${phrases.map(escape).join('|')})(?![\\p{L}\\p{N}])`, 'giu')] as const,
);

/** Catalog tag slugs implied by a recipe's name, category and keywords. Deterministic and free, unlike the LLM. */
export function inferTagSlugs(texts: ReadonlyArray<string | null | undefined>): string[] {
  let text = texts.filter(Boolean).join(' | ').normalize('NFC').toLowerCase();
  const slugs: string[] = [];
  for (const [slug, pattern] of COMPILED) {
    if (!pattern.test(text)) continue;
    slugs.push(slug);
    text = text.replace(pattern, ' ');
    pattern.lastIndex = 0;
  }
  return slugs;
}
