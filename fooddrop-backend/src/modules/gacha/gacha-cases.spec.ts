import type { Rarity } from '../../database/schema/recipes.schema.js';
import { byRarityDesc, CASE_ID_PATTERN, countByRarity, inCase, tagCaseId, type CaseCandidate } from './gacha-cases.js';

const recipe = (overrides: Partial<CaseCandidate> = {}): CaseCandidate => ({
  rarity: 'white',
  totalMinutes: 45,
  tagCaseIds: [],
  ...overrides,
});

describe('gacha cases', () => {
  it('puts every recipe in the all case', () => {
    expect(inCase('all', recipe())).toBe(true);
  });

  it('a tag case holds the recipes carrying that tag', () => {
    const pho = recipe({ tagCaseIds: [tagCaseId('cuisine', 'vietnamese'), tagCaseId('meal_type', 'breakfast')] });
    expect(inCase('cuisine.vietnamese', pho)).toBe(true);
    expect(inCase('meal_type.breakfast', pho)).toBe(true);
    expect(inCase('meal_type.dinner', pho)).toBe(false);
    expect(inCase('cuisine.vietnamese', recipe())).toBe(false);
  });

  it('accepts featured and <dimension>.<tag> ids only', () => {
    for (const id of ['all', 'quick', 'epic', 'cuisine.vietnamese', 'equipment.air-fryer', 'meal_type.side-dish']) {
      expect(CASE_ID_PATTERN.test(id)).toBe(true);
    }
    for (const id of ['secret', 'cuisine', 'cuisine.', 'Cuisine.x', 'a.b.c', 'cuisine.x y']) {
      expect(CASE_ID_PATTERN.test(id)).toBe(false);
    }
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
