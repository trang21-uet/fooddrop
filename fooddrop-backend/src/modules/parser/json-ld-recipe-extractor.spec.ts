import { readFileSync } from 'node:fs';
import { extractJsonLdRecipe } from './json-ld-recipe-extractor.js';

const fixture = (name: string): string => readFileSync(new URL(`./fixtures/${name}`, import.meta.url), 'utf8');

describe('extractJsonLdRecipe', () => {
  it('reads a Recipe out of a Yoast-style @graph with HowToSection steps and ISO durations', () => {
    expect(extractJsonLdRecipe(fixture('yoast-graph.html'))).toEqual({
      title: 'Classic & Fluffy Pancakes',
      description: 'Weekend favourite.',
      imageUrl: '/img/pancakes.jpg',
      servings: 4,
      totalMinutes: 25,
      ingredients: [
        { name: 'all-purpose flour', quantity: '1 1/2', unit: 'cups', note: null },
        { name: 'sugar', quantity: '2', unit: 'tbsp', note: null },
        { name: 'milk', quantity: '1', unit: 'cup', note: null },
        { name: 'egg', quantity: '1', unit: null, note: null },
        { name: 'butter', quantity: '3', unit: 'tbsp', note: 'melted' },
      ],
      steps: [
        { text: 'Whisk the dry ingredients.' },
        { text: 'Add milk, egg and butter.' },
        { text: 'Cook on a hot griddle until golden.' },
      ],
      suggestedTags: ['American', 'Breakfast', 'pancakes', 'brunch'],
    });
  });

  it('skips invalid JSON blocks, accepts multi-typed nodes and splits newline-separated steps', () => {
    const recipe = extractJsonLdRecipe(fixture('vietnamese-array-type.html'));
    expect(recipe).toMatchObject({
      title: 'Thịt kho trứng',
      servings: 4,
      totalMinutes: 75,
      imageUrl: 'https://example.com/thit-kho.jpg',
    });
    expect(recipe?.ingredients).toEqual([
      { name: 'thịt ba chỉ', quantity: '500', unit: 'g', note: null },
      { name: 'trứng', quantity: '4', unit: 'quả', note: null },
      { name: 'nước mắm', quantity: '2', unit: 'muỗng canh', note: null },
      { name: 'Hành lá', quantity: '2', unit: 'cây', note: null },
      { name: 'Muối', quantity: null, unit: null, note: 'vừa đủ' },
    ]);
    expect(recipe?.steps).toHaveLength(3);
  });

  it('returns null for markup without ingredients and steps so the LLM can read the page', () => {
    expect(extractJsonLdRecipe(fixture('metadata-only-recipe.html'))).toBeNull();
  });

  it('returns null when no Recipe node exists', () => {
    expect(extractJsonLdRecipe(fixture('no-structured-data.html'))).toBeNull();
    expect(extractJsonLdRecipe('<html></html>')).toBeNull();
  });
});
