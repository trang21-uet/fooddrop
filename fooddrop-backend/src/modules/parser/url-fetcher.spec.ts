import http from 'node:http';
import type { AddressInfo } from 'node:net';
import zlib from 'node:zlib';
import type { SafeLookup } from './public-address.js';
import { assertFetchableUrl, fetchPublicPage, type FetchLimits } from './url-fetcher.js';

// The fake server listens on 127.0.0.1, so these tests inject a lookup that skips the public-address check.
const loopbackLookup: SafeLookup = (_hostname, options, callback) =>
  options.all ? callback(null, [{ address: '127.0.0.1', family: 4 }]) : callback(null, '127.0.0.1', 4);

describe('assertFetchableUrl', () => {
  it.each([
    ['ftp://example.com/a', 'scheme'],
    ['file:///etc/passwd', 'scheme'],
    ['http://user:pw@example.com/', 'credentials'],
    ['http://example.com:6379/', 'port'],
    ['http://127.0.0.1/', 'non-public'],
    ['http://[::1]/', 'non-public'],
    ['http://169.254.169.254/latest/meta-data', 'non-public'],
    ['http://2130706433/', 'non-public'],
    ['http://0x7f.1/', 'non-public'],
    ['not a url', 'invalid'],
  ])('blocks %s', (url, reason) => {
    expect(() => assertFetchableUrl(url)).toThrow(
      expect.objectContaining({ code: 'url_blocked', detail: expect.stringContaining(reason) }),
    );
  });

  it('allows ordinary public URLs', () => {
    expect(assertFetchableUrl('https://example.com/recipe?id=1').hostname).toBe('example.com');
  });
});

describe('fetchPublicPage', () => {
  let server: http.Server;
  let base: string;
  let handler: http.RequestListener;
  const limits: FetchLimits = { maxBytes: 2048, timeoutMs: 1000, maxRedirects: 2, allowedPorts: [''] };

  beforeAll(async () => {
    server = http.createServer((req, res) => handler(req, res));
    await new Promise<void>((resolve) => server.listen(0, '127.0.0.1', resolve));
    const port = String((server.address() as AddressInfo).port);
    limits.allowedPorts = ['', port];
    base = `http://recipes.test:${port}`;
  });
  afterAll(() => new Promise<void>((resolve) => server.close(() => resolve())));

  const get = (path: string) => fetchPublicPage(`${base}${path}`, limits, loopbackLookup);
  const serve = (status: number, headers: http.OutgoingHttpHeaders, body: string | Buffer) => {
    handler = (_req, res) => {
      res.writeHead(status, headers);
      res.end(body);
    };
  };

  it('returns decoded HTML', async () => {
    serve(200, { 'content-type': 'text/html; charset=utf-8' }, '<p>Phở bò</p>');
    expect(await get('/')).toEqual({ finalUrl: `${base}/`, html: '<p>Phở bò</p>' });
  });

  it('decompresses gzip bodies', async () => {
    serve(200, { 'content-type': 'text/html', 'content-encoding': 'gzip' }, zlib.gzipSync('<p>nén</p>'));
    expect((await get('/')).html).toBe('<p>nén</p>');
  });

  it('caps size by content-length and by streamed bytes', async () => {
    serve(200, { 'content-type': 'text/html' }, 'x'.repeat(4096));
    await expect(get('/')).rejects.toMatchObject({ code: 'fetch_failed', detail: 'response too large' });

    handler = (_req, res) => {
      res.writeHead(200, { 'content-type': 'text/html' }); // chunked: no content-length to short-circuit on
      res.write('x'.repeat(1500));
      res.end('y'.repeat(1500));
    };
    await expect(get('/')).rejects.toMatchObject({ code: 'fetch_failed', detail: 'response too large' });
  });

  it('caps size after decompression (zip bomb)', async () => {
    serve(200, { 'content-type': 'text/html', 'content-encoding': 'gzip' }, zlib.gzipSync('a'.repeat(100_000)));
    await expect(get('/')).rejects.toMatchObject({ code: 'fetch_failed' });
  });

  it('follows redirects but re-validates every hop', async () => {
    handler = (req, res) => {
      if (req.url === '/start') res.writeHead(302, { location: '/final' }).end();
      else if (req.url === '/evil') res.writeHead(302, { location: 'http://169.254.169.254/latest' }).end();
      else res.writeHead(200, { 'content-type': 'text/html' }).end('ok');
    };
    expect(await get('/start')).toMatchObject({ finalUrl: `${base}/final`, html: 'ok' });
    await expect(get('/evil')).rejects.toMatchObject({ code: 'url_blocked' });
  });

  it('gives up after too many redirects', async () => {
    handler = (_req, res) => res.writeHead(302, { location: '/loop' }).end();
    await expect(get('/loop')).rejects.toMatchObject({ code: 'fetch_failed', detail: 'too many redirects' });
  });

  it('rejects non-2xx and non-HTML responses', async () => {
    serve(404, { 'content-type': 'text/html' }, 'nope');
    await expect(get('/')).rejects.toMatchObject({ code: 'fetch_failed', detail: 'HTTP 404' });
    serve(200, { 'content-type': 'application/pdf' }, '%PDF');
    await expect(get('/')).rejects.toMatchObject({ code: 'fetch_failed' });
  });

  it('times out on a server that never answers', async () => {
    handler = () => undefined;
    await expect(
      fetchPublicPage(`${base}/`, { ...limits, timeoutMs: 150 }, loopbackLookup),
    ).rejects.toMatchObject({ code: 'fetch_failed', detail: 'timeout' });
  });

  it('blocks hostnames that resolve to private addresses with the production lookup', async () => {
    await expect(fetchPublicPage('http://localhost/')).rejects.toMatchObject({ code: 'url_blocked' });
  });
});
