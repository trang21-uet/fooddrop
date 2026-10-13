import { readFileSync } from 'node:fs';
import { extractDienMayXanhSections } from './dienmayxanh-recipe-extractor.js';

const html = readFileSync(new URL('./fixtures/dienmayxanh-two-versions.html', import.meta.url), 'utf8');
const PAGE_URL = 'https://www.dienmayxanh.com/vao-bep/cach-lam-heo-quay-00061';

describe('extractDienMayXanhSections', () => {
  it('reads only the first version of the dish', () => {
    const sections = extractDienMayXanhSections(html, PAGE_URL);
    expect(sections?.servings).toBe(3);
    expect(sections?.difficulty).toBe(3);
    expect(sections?.ingredients).toEqual([
      { name: 'Thịt ba chỉ heo', quantity: '500', unit: 'gr', note: 'chọn miếng ít mỡ' },
      { name: 'Giấm', quantity: '2', unit: 'muỗng cà phê', note: null },
      { name: 'Muối', quantity: '1', unit: 'ít', note: null },
    ]);
    expect(sections?.steps.map((step) => step.name)).toEqual(['Luộc thịt', 'Thành phẩm']);
  });

  it('keeps a step whole, with its heading, "Lưu ý" note and photos', () => {
    expect(extractDienMayXanhSections(html, PAGE_URL)?.steps[0]).toEqual({
      name: 'Luộc thịt',
      text: 'Thịt mua về rửa sạch.\nLuộc 7 phút.',
      note: 'Để ý không luộc quá lâu.',
      imageUrls: ['https://cdn.tgdd.vn/GalleryStep/luoc-thit.jpg', 'https://cdn.tgdd.vn/GalleryStep/luoc-thit-1.jpg'],
    });
  });

  it('reads a single-version page that has no .box-recipe wrapper', () => {
    const single = html.replace(/<div id="recipeId\d+" class="box-recipe">/g, '<div>');
    expect(extractDienMayXanhSections(single, PAGE_URL)?.steps).toHaveLength(2);
  });

  it('maps every "Độ khó" label onto 1..5 and leaves unknown ones to the caller', () => {
    const withLevel = (label: string) =>
      extractDienMayXanhSections(html.replace('Trung b&#236;nh', label), PAGE_URL)?.difficulty;
    expect(['Rất dễ', 'Dễ', 'Trung bình', 'Khó', 'Rất khó', 'Siêu khó'].map(withLevel)).toEqual([1, 2, 3, 4, 5, null]);
  });

  it('ignores other hosts and pages without the markup', () => {
    expect(extractDienMayXanhSections(html, 'https://blog.example/heo-quay')).toBeNull();
    expect(extractDienMayXanhSections('<html><body></body></html>', PAGE_URL)).toBeNull();
    expect(extractDienMayXanhSections(html, 'not a url')).toBeNull();
  });
});
