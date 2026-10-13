import { inferTagSlugs } from './infer-tag-slugs.js';

describe('inferTagSlugs', () => {
  it('reads equipment and technique from Vietnamese titles and categories', () => {
    expect(inferTagSlugs(['Cách làm heo quay bằng nồi chiên không dầu', 'Món chiên'])).toEqual(['air-fryer', 'pan-fry']);
    expect(inferTagSlugs(['Cá kho tộ', 'Canh chua cá lóc'])).toEqual(['braise', 'soup']);
    expect(inferTagSlugs(['Gà chiên ngập dầu'])).toEqual(['deep-fry']);
  });

  it('does not let equipment phrases count as a technique', () => {
    expect(inferTagSlugs(['Khoai tây nồi chiên không dầu'])).toEqual(['air-fryer']);
  });

  it('matches whole words only and respects diacritics', () => {
    expect(inferTagSlugs(['Khoai lang', 'Mực khô nướng', 'Cháy tỏi'])).toEqual([]);
  });

  it('reads English sources and cuisines', () => {
    expect(inferTagSlugs(['Baked salmon', 'Italian', 'pasta, dinner'])).toEqual(['roast-bake', 'italian']);
    expect(inferTagSlugs(['Món chay', 'Đậu hũ sốt cà kiểu Thái'])).toEqual(['vegetarian', 'thai']);
  });

  it('ignores empty input', () => {
    expect(inferTagSlugs([null, undefined, ''])).toEqual([]);
  });
});
