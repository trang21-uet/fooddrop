import { isoDurationToMinutes } from './iso-duration.js';

describe('isoDurationToMinutes', () => {
  it.each([
    ['PT30M', 30],
    ['PT1H30M', 90],
    ['P0DT45M', 45],
    ['PT90M', 90],
    ['P1DT2H', 1560],
    ['PT1H', 60],
    ['PT30S', 1],
    ['pt20m', 20],
  ])('%s -> %i minutes', (input, expected) => expect(isoDurationToMinutes(input)).toBe(expected));

  it.each(['', 'PT0M', '30 minutes', 'P', null, 45, undefined])('returns null for %s', (input) => {
    expect(isoDurationToMinutes(input)).toBeNull();
  });
});
