import { SEED_UNITS } from './seed-units.js';

describe('SEED_UNITS', () => {
  it('has unique codes and both names for every unit', () => {
    const codes = SEED_UNITS.map(([code]) => code);
    expect(new Set(codes).size).toBe(codes.length);
    for (const [code, nameVi, nameEn] of SEED_UNITS) {
      expect(nameVi.trim(), code).not.toBe('');
      expect(nameEn.trim(), code).not.toBe('');
    }
  });

  it('only leaves toBase empty for units that cannot be summed', () => {
    for (const [code, , , kind, toBase] of SEED_UNITS) {
      expect(toBase === null, code).toBe(kind === 'other');
    }
  });

  it('keeps the g and ml rows that existing recipe lines point to', () => {
    const codes = SEED_UNITS.map(([code]) => code);
    expect(codes).toEqual(expect.arrayContaining(['g', 'ml']));
  });
});
