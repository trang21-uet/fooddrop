import { extractArticleUrls, extractCategoryUrls } from './dienmayxanh-recipe-links.js';

const html = `
  <a href="/vao-bep/mon-kho">Món kho</a>
  <a href="/vao-bep/cach-lam-heo-quay-00061"><img></a>
  <a href="/vao-bep/cach-lam-heo-quay-00061">Heo quay</a>
  <a href="https://www.dienmayxanh.com/vao-bep/canh-chua-ca-24504">Canh chua</a>
  <a href="/vao-bep/xem-truoc">Preview</a>
  <a href="/vao-bep/mon-kho?page=2">Page 2</a>
  <a href="/tivi">TV</a>
  <a href="https://other.example/vao-bep/mon-lau">Other site</a>`;

describe('dienmayxanh links', () => {
  it('lists article URLs once, absolute, in page order', () => {
    expect(extractArticleUrls(html)).toEqual([
      'https://www.dienmayxanh.com/vao-bep/cach-lam-heo-quay-00061',
      'https://www.dienmayxanh.com/vao-bep/canh-chua-ca-24504',
    ]);
  });

  it('lists category URLs, skipping robots-disallowed paths and other sites', () => {
    expect(extractCategoryUrls(html)).toEqual(['https://www.dienmayxanh.com/vao-bep/mon-kho']);
  });
});
