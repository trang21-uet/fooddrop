import { buildDraft, guessDifficulty, type DraftContext } from './draft-builder.js';
import type { RawRecipe } from './parser.schemas.js';

const context: DraftContext = {
  source: 'json-ld',
  sourceUrl: 'https://blog.example/recipes/pho',
  catalog: [
    { id: 'flour-id', name: 'Bột mì', aliases: ['flour'], defaultUnit: 'g', densityGPerMl: 0.53 },
    { id: 'milk-id', name: 'Sữa tươi', aliases: ['milk'], defaultUnit: 'ml', densityGPerMl: 1.03 },
    { id: 'egg-id', name: 'Trứng gà', aliases: ['egg', 'eggs'], defaultUnit: 'piece', densityGPerMl: null },
  ],
  tags: [{ id: 7, slug: 'breakfast', label: 'Bữa sáng' }],
};

const raw = (overrides: Partial<RawRecipe> = {}): RawRecipe => ({
  title: 'Pancakes',
  ingredients: [{ name: 'flour', quantity: '2', unit: 'cups' }],
  steps: [{ text: 'Mix.' }],
  suggestedTags: [],
  ...overrides,
});

describe('buildDraft', () => {
  it('keeps the units the cook used, converts only what the catalog lacks, and flags unmatched ingredients', () => {
    const draft = buildDraft(
      raw({
        ingredients: [
          { name: 'flour', quantity: '2', unit: 'cups', note: 'sifted' },
          { name: 'milk', quantity: '1', unit: 'tbsp' },
          { name: 'eggs', quantity: 3 },
          { name: 'dragon fruit', quantity: '100', unit: 'g' },
        ],
      }),
      context,
    );
    expect(draft.ingredients).toEqual([
      { name: 'flour', quantity: 473.18, unit: 'ml', note: 'sifted', ingredientId: 'flour-id', matchedName: 'Bột mì', isNew: false },
      { name: 'milk', quantity: 1, unit: 'tbsp', note: null, ingredientId: 'milk-id', matchedName: 'Sữa tươi', isNew: false },
      { name: 'eggs', quantity: 3, unit: null, note: null, ingredientId: 'egg-id', matchedName: 'Trứng gà', isNew: false },
      { name: 'dragon fruit', quantity: 100, unit: 'g', note: null, ingredientId: null, matchedName: null, isNew: true },
    ]);
  });

  it('keeps the original wording for unknown units and unparseable quantities, never inventing numbers', () => {
    const draft = buildDraft(
      raw({
        ingredients: [
          { name: 'flour', quantity: '1', unit: 'sachet' },
          { name: 'milk', quantity: 'a splash' },
          { name: 'eggs', quantity: null },
        ],
      }),
      context,
    );
    expect(draft.ingredients.map(({ quantity, unit, note }) => ({ quantity, unit, note }))).toEqual([
      { quantity: null, unit: null, note: '1 sachet' },
      { quantity: null, unit: null, note: 'a splash' },
      { quantity: null, unit: null, note: null },
    ]);
  });

  it('applies defaults, clamps and resolves relative image URLs and tags', () => {
    const draft = buildDraft(
      raw({
        servings: 3.4,
        totalMinutes: 20_000,
        imageUrl: '/img/a.jpg',
        steps: [{ text: 'Boil.', timerSeconds: 90.4 }, { text: 'Serve.' }],
        suggestedTags: ['breakfast', 'nonsense'],
      }),
      context,
    );
    expect(draft).toMatchObject({
      source: 'json-ld',
      baseServings: 3,
      totalMinutes: 10_080,
      imageUrl: 'https://blog.example/img/a.jpg',
      sourceUrl: 'https://blog.example/recipes/pho',
      suggestedTagIds: [7],
      steps: [{ text: 'Boil.', timerSeconds: 90 }, { text: 'Serve.' }],
    });
    expect(buildDraft(raw(), context)).toMatchObject({ baseServings: 2, totalMinutes: null });
  });

  it('drops non-http image URLs and uses the extractor difficulty when given', () => {
    expect(buildDraft(raw({ imageUrl: 'javascript:alert(1)' }), context).imageUrl).toBeNull();
    expect(buildDraft(raw({ difficulty: 4 }), context).difficulty).toBe(4);
  });
});

describe('guessDifficulty', () => {
  it('grows with ingredients, steps and time within 1..5', () => {
    expect(guessDifficulty(3, 2, 15)).toBe(1);
    expect(guessDifficulty(12, 8, 90)).toBe(5);
    expect(guessDifficulty(100, 100, 10_000)).toBe(5);
  });
});
