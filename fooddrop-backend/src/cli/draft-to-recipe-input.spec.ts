import type { ParsedRecipeDraft } from '../modules/parser/parser.schemas.js';
import { draftToRecipeInput, type DraftIngredient } from './draft-to-recipe-input.js';
import { findIngredientByName, ingredientDefaultUnit } from './ingredient-lookup.js';

const SALT = '11111111-1111-4111-8111-111111111111';
const PORK = '22222222-2222-4222-8222-222222222222';

const line = (overrides: Partial<DraftIngredient>): DraftIngredient => ({
  name: 'Muối',
  quantity: null,
  unit: null,
  note: null,
  matchedName: null,
  ingredientId: null,
  isNew: true,
  ...overrides,
});

const draft: ParsedRecipeDraft = {
  source: 'json-ld',
  title: 'Heo quay',
  description: null,
  imageUrl: 'not a url',
  sourceUrl: 'https://www.dienmayxanh.com/vao-bep/cach-lam-heo-quay-00061',
  baseServings: 4,
  totalMinutes: null,
  difficulty: 3,
  ingredients: [
    line({ name: 'Thịt ba chỉ', quantity: 500, unit: 'g', ingredientId: PORK, isNew: false }),
    line({ name: 'Thịt ba rọi', quantity: 250, unit: 'g', ingredientId: PORK, isNew: false }),
    line({ name: 'Muối hột', quantity: null, unit: 'g', note: 'tùy khẩu vị' }),
  ],
  steps: [{ name: '', text: 'x'.repeat(2500), note: 'Lưu ý', images: [{ key: 'recipes/u1/a.jpg', url: null }] }],
  suggestedTagIds: [3, 3],
};

describe('draftToRecipeInput', () => {
  it('resolves new ingredients, merges repeats and fits the input limits', async () => {
    const resolve = vi.fn(() => Promise.resolve(SALT));
    const input = await draftToRecipeInput(draft, resolve);

    expect(resolve).toHaveBeenCalledOnce();
    expect(input).toMatchObject({ title: 'Heo quay', totalMinutes: 30, baseServings: 4, tagIds: [3], imageUrl: undefined });
    expect(input.ingredients).toEqual([
      { ingredientId: PORK, quantity: 750, unit: 'g', note: undefined },
      // A unit without an amount is dropped, since a unit needs a quantity.
      { ingredientId: SALT, quantity: undefined, unit: undefined, note: 'tùy khẩu vị' },
    ]);
    expect(input.steps[0]).toMatchObject({ text: 'x'.repeat(2000), note: 'Lưu ý', images: ['recipes/u1/a.jpg'] });
    expect(input.steps[0]?.name).toBeUndefined();
  });

  it('rejects a draft without steps', async () => {
    await expect(draftToRecipeInput({ ...draft, steps: [] }, () => Promise.resolve(SALT))).rejects.toThrow();
  });
});

describe('ingredient lookup', () => {
  it('finds the existing row by folded name or alias', () => {
    const rows = [
      { id: 'a', name: 'Hành tây', aliases: [] },
      { id: 'b', name: 'Hành lá', aliases: ['hành hoa'] },
    ];
    expect(findIngredientByName(rows, 'HANH LA').id).toBe('b');
    expect(findIngredientByName(rows, 'Hành hoa').id).toBe('b');
    expect(findIngredientByName(rows, 'Đường').id).toBe('a');
  });

  it('picks the grocery base unit from the line unit kind', () => {
    const kinds = new Map([['kg', 'mass'], ['tbsp', 'volume'], ['fruit', 'count'], ['pinch', 'other']]);
    expect(ingredientDefaultUnit({ quantity: 1, unit: 'kg' }, kinds)).toBe('g');
    expect(ingredientDefaultUnit({ quantity: 2, unit: 'tbsp' }, kinds)).toBe('ml');
    expect(ingredientDefaultUnit({ quantity: 3, unit: 'fruit' }, kinds)).toBe('piece');
    expect(ingredientDefaultUnit({ quantity: 2, unit: null }, kinds)).toBe('piece');
    expect(ingredientDefaultUnit({ quantity: 1, unit: 'pinch' }, kinds)).toBe('g');
    expect(ingredientDefaultUnit({ quantity: null, unit: null }, kinds)).toBe('g');
  });
});
