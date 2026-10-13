import type { Rarity } from '../../database/schema/recipes.schema.js';
import { byRarityDesc, CASE_IDS, countByRarity, inCase, type CaseCandidate, type CaseId } from './gacha-cases.js';

const recipe = (overrides: Partial<CaseCandidate> = {}): CaseCandidate => ({
  rarity: 'white',
  totalMinutes: 45,
  mealTypes: [],
  ...overrides,
});

const cases = (candidate: CaseCandidate): CaseId[] => CASE_IDS.filter((id) => inCase(id, candidate));

describe('gacha cases', () => {
  it('puts every recipe in the all case', () => {
    expect(cases(recipe())).toEqual(['all']);
  });

  it('sorts meals by their meal_type tags', () => {
    expect(cases(recipe({ mealTypes: ['breakfast', 'dinner'] }))).toEqual(['all', 'breakfast', 'dinner']);
    expect(cases(recipe({ mealTypes: ['lunch'] }))).toEqual(['all', 'lunch']);
  });

  it('quick holds recipes of 30 minutes or less', () => {
    expect(inCase('quick', recipe({ totalMinutes: 30 }))).toBe(true);
    expect(inCase('quick', recipe({ totalMinutes: 31 }))).toBe(false);
  });

  it('epic holds the pink and red tiers only', () => {
    const tiers: Rarity[] = ['white', 'blue', 'purple', 'pink', 'red'];
    expect(tiers.filter((rarity) => inCase('epic', recipe({ rarity })))).toEqual(['pink', 'red']);
  });

  it('counts and orders by rarity', () => {
    const list = [
      { title: 'B', rarity: 'blue' as const },
      { title: 'A', rarity: 'red' as const },
      { title: 'C', rarity: 'blue' as const },
    ];
    expect(countByRarity(list)).toEqual({ white: 0, blue: 2, purple: 0, pink: 0, red: 1 });
    expect([...list].sort(byRarityDesc).map((r) => r.title)).toEqual(['A', 'B', 'C']);
  });
});
