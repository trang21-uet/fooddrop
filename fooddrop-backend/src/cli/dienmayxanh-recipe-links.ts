// Link discovery for Điện máy XANH "Vào bếp" listing pages. robots.txt allows /vao-bep/ except /vao-bep/xem-truoc.
export const DIENMAYXANH_ORIGIN = 'https://www.dienmayxanh.com';
export const DIENMAYXANH_HOME = `${DIENMAYXANH_ORIGIN}/vao-bep/`;

// Articles end in a numeric id ("cach-lam-heo-quay-00061"); categories ("mon-kho") have no digits.
const ARTICLE_HREF = /href="(?:https:\/\/www\.dienmayxanh\.com)?(\/vao-bep\/[a-z0-9-]+-\d{4,6})"/g;
const CATEGORY_HREF = /href="(?:https:\/\/www\.dienmayxanh\.com)?(\/vao-bep\/[a-z-]+)"/g;
const BLOCKED_PATHS = new Set(['/vao-bep/xem-truoc']);

function uniqueUrls(html: string, pattern: RegExp): string[] {
  const paths = [...html.matchAll(pattern)].map((match) => match[1]!).filter((path) => !BLOCKED_PATHS.has(path));
  return [...new Set(paths)].map((path) => `${DIENMAYXANH_ORIGIN}${path}`);
}

/** Absolute article URLs in page order. Some are tips or travel articles; the parser rejects those. */
export const extractArticleUrls = (html: string): string[] => uniqueUrls(html, ARTICLE_HREF);

/** Absolute category URLs ("/vao-bep/mon-kho") in page order. */
export const extractCategoryUrls = (html: string): string[] => uniqueUrls(html, CATEGORY_HREF);
