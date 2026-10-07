import { createIngredientMatcher, foldIngredientName, matchTagIds, nameVariants, type CatalogIngredient } from './ingredient-matcher.js';

const ingredient = (id: string, name: string, aliases: string[] = []): CatalogIngredient => ({
  id, name, aliases, defaultUnit: 'g', densityGPerMl: null,
});

const catalog = [
  ingredient('onion', 'Hành lá', ['scallion', 'green onion']),
  ingredient('chicken', 'Ức gà', ['chicken breast']),
  ingredient('pork', 'Thịt ba chỉ', ['pork belly']),
  ingredient('fish', 'Nước mắm', ['fish sauce']),
  ingredient('stock', 'Nước dùng gà', ['chicken stock']),
];

describe('foldIngredientName', () => {
  it('drops diacritics, case, punctuation and parentheticals', () => {
    expect(foldIngredientName('Hành lá (xắt nhỏ)')).toBe('hanh la');
    expect(foldIngredientName('  ĐƯỜNG,  cát ')).toBe('duong cat');
  });
});

describe('createIngredientMatcher', () => {
  const match = createIngredientMatcher(catalog);

  it('matches names and aliases exactly, ignoring accents and case', () => {
    expect(match('hanh la')?.id).toBe('onion');
    expect(match('Scallion')?.id).toBe('onion');
    expect(match('Chicken Breast')?.id).toBe('chicken');
  });

  it('tolerates small spelling variants via trigram similarity', () => {
    expect(match('thịt ba chỉ heo')?.id).toBe('pork');
    expect(match('chicken breasts')?.id).toBe('chicken');
  });

  it('ignores size and cut words and plural forms', () => {
    const eggs = createIngredientMatcher([ingredient('egg', 'Trứng gà', ['egg']), ingredient('lemon', 'Chanh vàng', ['lemon'])]);
    expect(eggs('large eggs')?.id).toBe('egg');
    expect(eggs('Fresh Egg')?.id).toBe('egg');
    expect(eggs('lemon wedges')?.id).toBe('lemon');
    expect(nameVariants('large eggs')).toEqual(['large eggs', 'eggs', 'large egg', 'egg']);
    expect(nameVariants('tomatoes')).toContain('tomato');
    expect(nameVariants('berries')).toContain('berry');
    expect(nameVariants('')).toEqual([]);
  });

  it('does not conflate different ingredients that share a word', () => {
    expect(match('chicken')).toBeNull();
    expect(match('gà')).toBeNull();
  });

  it('returns null for unknown or empty names', () => {
    expect(match('dragon fruit')).toBeNull();
    expect(match('   ')).toBeNull();
  });

  it('lets the first catalog entry keep a contested term', () => {
    const contested = createIngredientMatcher([ingredient('a', 'Đường', ['sugar']), ingredient('b', 'Đường phèn', ['sugar'])]);
    expect(contested('sugar')?.id).toBe('a');
  });
});

describe('matchTagIds', () => {
  const tags = [
    { id: 1, slug: 'vietnamese', label: 'Món Việt' },
    { id: 2, slug: 'air-fryer', label: 'Nồi chiên không dầu' },
    { id: 3, slug: 'breakfast', label: 'Bữa sáng' },
  ];

  it('maps slugs, labels and keywords to ids without duplicates', () => {
    expect(matchTagIds(['vietnamese', 'Air Fryer', 'bữa sáng', 'Món Việt', 'unknown'], tags)).toEqual([1, 2, 3]);
  });
});
