import { cleanHtmlToText } from './readability-cleaner.js';

const filler = 'Cook the noodles until tender and drain well. '.repeat(10);

describe('cleanHtmlToText', () => {
  it('keeps the article and drops scripts, styles and navigation chrome', () => {
    const html = `<html><head><style>.a{color:red}</style><script>var secret = 1;</script></head><body>
      <nav>Home | About | Login</nav>
      <article><h1>Bún chả</h1><p>${filler}</p><p>Nướng thịt trên than hoa.</p></article>
      <footer>Copyright</footer></body></html>`;
    const text = cleanHtmlToText(html);
    expect(text).toContain('Bún chả');
    expect(text).toContain('Nướng thịt trên than hoa.');
    expect(text).not.toContain('secret');
    expect(text).not.toContain('color:red');
  });

  it('falls back to the body text when there is no article to extract', () => {
    expect(cleanHtmlToText('<html><body><div>Muối 1 muỗng</div></body></html>')).toContain('Muối 1 muỗng');
  });

  it('caps the text sent to the model', () => {
    const html = `<html><body><article>${'<p>bước nấu</p>'.repeat(10_000)}</article></body></html>`;
    expect(cleanHtmlToText(html).length).toBeLessThanOrEqual(30_000);
  });
});
