import { shortenRecipeTitle } from './recipe-title-shortener.js';

describe('shortenRecipeTitle', () => {
  it('takes the longest source keyword that starts the title after "Cách làm"', () => {
    const keywords = ['cá ngừ nấu canh chua', 'canh chua cá ngừ', 'canh chua', 'cá ngừ'];
    expect(shortenRecipeTitle('Cách làm canh chua cá ngừ thơm ngon không tanh, chuẩn vị miền Trung tại nhà', keywords)).toBe(
      'Canh chua cá ngừ',
    );
  });

  it.each([
    ['2 Cách nấu chè đậu xanh nha đam thanh mát, giải nhiệt cho ngày nóng', 'Chè đậu xanh nha đam'],
    ['Hướng dẫn cách nấu canh cà xanh với thịt ba chỉ, đậu hũ cực kỳ đưa cơm', 'Canh cà xanh với thịt ba chỉ'],
    ['Bí quyết làm cá hấp nước tương ngọt thịt, thơm ngon đậm đà', 'Cá hấp nước tương'],
    ['Cách làm món bồng khoai nấu ốc om cơm mẻ chuẩn vị miền Bắc', 'Bồng khoai nấu ốc om cơm mẻ'],
    ['Cách làm heo quay bằng nồi chiên không dầu da giòn rụm cực ngon', 'Heo quay'],
    ['Tự làm bánh Phú Sĩ sầu riêng lá dứa kem tươi thơm béo chuẩn vị cực dễ', 'Bánh Phú Sĩ sầu riêng lá dứa kem tươi'],
    ['Cách ướp sườn nướng ngon và mềm với công thức đơn giản', 'Sườn nướng'],
    ['Cách làm má đùi gà chiên xù với nồi chiên không dầu', 'Má đùi gà chiên xù'],
    ['Cách làm chả tôm thịt chiên vàng giòn rụm cực ngon', 'Chả tôm thịt chiên'],
  ])('cuts "%s" at the first praise word or comma', (title, dish) => {
    expect(shortenRecipeTitle(title)).toBe(dish);
  });

  it('keeps two words even when the second is a praise word', () => {
    expect(shortenRecipeTitle('Cách làm bánh ngon tại nhà')).toBe('Bánh ngon');
  });

  it('only drops a trailing clause from titles without a how-to prefix', () => {
    expect(shortenRecipeTitle('Chè tuyết giáp sữa tươi đu đủ: Công thức giải nhiệt mùa hè cực đã')).toBe('Chè tuyết giáp sữa tươi đu đủ');
    expect(shortenRecipeTitle('Thịt kho tàu thơm ngon', ['thịt kho'])).toBe('Thịt kho tàu thơm ngon');
    expect(shortenRecipeTitle('Classic & Fluffy Pancakes')).toBe('Classic & Fluffy Pancakes');
  });

  it('ignores single-word keywords and keywords that end mid-word', () => {
    expect(shortenRecipeTitle('Cách làm chè khúc bạch bằng whipping cream', ['chè', 'chè khúc b'])).toBe('Chè khúc bạch');
  });

  it('falls back to the original when nothing is left', () => {
    expect(shortenRecipeTitle('Cách làm , mẹo hay')).toBe('Cách làm , mẹo hay');
  });
});
