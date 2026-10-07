import { parseIngredientLine } from './parse-ingredient-line.js';

const parse = (line: string) => {
  const { name, quantity, unit, note } = parseIngredientLine(line);
  return { name, quantity, unit, note };
};

describe('parseIngredientLine', () => {
  it('splits quantity, unit, name and preparation note', () => {
    expect(parse('2 cups all-purpose flour, sifted')).toEqual({
      name: 'all-purpose flour', quantity: '2', unit: 'cups', note: 'sifted',
    });
  });

  it('handles mixed numbers, fractions and unicode fractions', () => {
    expect(parse('1 1/2 tbsp olive oil')).toMatchObject({ quantity: '1 1/2', unit: 'tbsp', name: 'olive oil' });
    expect(parse('1/2 tsp salt')).toMatchObject({ quantity: '1/2', unit: 'tsp', name: 'salt' });
    expect(parse('1½ cups milk')).toMatchObject({ quantity: '1 1/2', unit: 'cups', name: 'milk' });
  });

  it('keeps ranges and moves parentheticals to the note', () => {
    expect(parse('2-3 cloves garlic (minced)')).toEqual({ name: 'garlic', quantity: '2-3', unit: 'cloves', note: 'minced' });
  });

  it('treats a count with no unit as a bare quantity', () => {
    expect(parse('3 eggs')).toEqual({ name: 'eggs', quantity: '3', unit: null, note: null });
  });

  it('reads Vietnamese units, attached units and decimal commas', () => {
    expect(parse('200g thịt bò')).toMatchObject({ quantity: '200', unit: 'g', name: 'thịt bò' });
    expect(parse('2 muỗng canh đường')).toMatchObject({ quantity: '2', unit: 'muỗng canh', name: 'đường' });
    expect(parse('1,5 kg thịt ba chỉ')).toMatchObject({ quantity: '1,5', unit: 'kg', name: 'thịt ba chỉ' });
  });

  it('reads amounts written after the name', () => {
    expect(parse('Thịt bò: 300g')).toMatchObject({ name: 'Thịt bò', quantity: '300', unit: 'g' });
    expect(parse('Hành lá - 2 cây')).toMatchObject({ name: 'Hành lá', quantity: '2', unit: 'cây' });
  });

  it('extracts "to taste" wording as a note with no quantity', () => {
    expect(parse('Salt, to taste')).toEqual({ name: 'Salt', quantity: null, unit: null, note: 'to taste' });
    expect(parse('Muối vừa đủ')).toMatchObject({ name: 'Muối', quantity: null, note: 'vừa đủ' });
  });

  it('falls back to the whole line as the name', () => {
    expect(parse('Fresh basil leaves')).toEqual({ name: 'Fresh basil leaves', quantity: null, unit: null, note: null });
  });

  it('strips "of" after the unit', () => {
    expect(parse('1 cup of water')).toMatchObject({ unit: 'cup', name: 'water' });
  });
});

describe('parseIngredientLine amount qualifiers', () => {
  it('moves "to serve" and "plus extra" wording out of the name', () => {
    expect(parseIngredientLine('caster sugar to serve')).toMatchObject({ name: 'caster sugar', note: 'to serve' });
    expect(parseIngredientLine('2 tbsp sunflower or vegetable oil plus a little extra for frying')).toMatchObject({
      name: 'sunflower or vegetable oil', quantity: '2', unit: 'tbsp', note: 'plus a little extra for frying',
    });
    expect(parseIngredientLine('1 lemon, cut into wedges, to serve')).toMatchObject({ name: 'lemon', note: expect.stringContaining('to serve') });
  });
});
