import http from 'node:http';
import https from 'node:https';
import { isIP } from 'node:net';
import { pipeline } from 'node:stream/promises';
import zlib from 'node:zlib';
import { ParseJobError } from './parse-job-error.js';
import { BlockedAddressError, isPublicAddress, safeLookup, type SafeLookup } from './public-address.js';

export interface FetchedPage {
  finalUrl: string;
  html: string;
}

export interface FetchLimits {
  maxBytes: number;
  timeoutMs: number;
  maxRedirects: number;
  /** url.port values to accept; "" is the scheme default. Tests widen it to reach a local server. */
  allowedPorts: readonly string[];
}

export const DEFAULT_FETCH_LIMITS: FetchLimits = { maxBytes: 5 * 1024 * 1024, timeoutMs: 10_000, maxRedirects: 4, allowedPorts: ['', '80', '443'] };

// Plenty of food blogs answer 403 to unknown bots, so identify as a regular browser.
const HEADERS = {
  'User-Agent': 'Mozilla/5.0 (compatible; FoodDrop/1.0; recipe import) AppleWebKit/537.36 Chrome/124.0 Safari/537.36',
  Accept: 'text/html,application/xhtml+xml',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'vi,en;q=0.8',
};

/** Rejects anything that is not a plain http(s) URL on a standard port without embedded credentials. */
export function assertFetchableUrl(raw: string, allowedPorts: readonly string[] = DEFAULT_FETCH_LIMITS.allowedPorts): URL {
  let url: URL;
  try {
    url = new URL(raw);
  } catch {
    throw new ParseJobError('url_blocked', 'invalid URL');
  }
  if (url.protocol !== 'http:' && url.protocol !== 'https:') throw new ParseJobError('url_blocked', 'scheme');
  if (url.username || url.password) throw new ParseJobError('url_blocked', 'credentials in URL');
  if (!allowedPorts.includes(url.port)) throw new ParseJobError('url_blocked', 'port');
  // Literal IPs skip DNS (and therefore the lookup hook), so check them here.
  const host = url.hostname.replace(/^\[|\]$/g, '');
  if (isIP(host) && !isPublicAddress(host)) throw new ParseJobError('url_blocked', 'non-public address');
  return url;
}

function decoderFor(encoding: string | undefined): zlib.Gunzip | zlib.Inflate | zlib.BrotliDecompress | null {
  switch (encoding?.toLowerCase()) {
    case 'gzip':
    case 'x-gzip':
      return zlib.createGunzip();
    case 'deflate':
      return zlib.createInflate();
    case 'br':
      return zlib.createBrotliDecompress();
    case undefined:
    case '':
    case 'identity':
      return null;
    default:
      throw new ParseJobError('fetch_failed', `unsupported content-encoding ${encoding}`);
  }
}

async function readBody(response: http.IncomingMessage, maxBytes: number): Promise<Buffer> {
  const declared = Number(response.headers['content-length']);
  if (Number.isFinite(declared) && declared > maxBytes) throw new ParseJobError('fetch_failed', 'response too large');
  const decoder = decoderFor(response.headers['content-encoding']);
  const chunks: Buffer[] = [];
  let total = 0;
  // The cap applies after decompression so a zip bomb cannot exceed it.
  const collect = async (source: AsyncIterable<Buffer>): Promise<void> => {
    for await (const chunk of source) {
      total += chunk.length;
      if (total > maxBytes) throw new ParseJobError('fetch_failed', 'response too large');
      chunks.push(chunk);
    }
  };
  await (decoder ? pipeline(response, decoder, collect) : pipeline(response, collect));
  return Buffer.concat(chunks);
}

function charsetOf(contentType: string): string {
  const match = /charset=["']?([\w-]+)/i.exec(contentType);
  return match?.[1]?.toLowerCase() ?? 'utf-8';
}

function decode(body: Buffer, contentType: string): string {
  try {
    return new TextDecoder(charsetOf(contentType)).decode(body);
  } catch {
    // Unknown charset label: UTF-8 is right for the overwhelming majority of recipe sites.
    return new TextDecoder('utf-8').decode(body);
  }
}

function request(url: URL, signal: AbortSignal, lookup: SafeLookup): Promise<http.IncomingMessage> {
  const transport = url.protocol === 'https:' ? https : http;
  return new Promise((resolve, reject) => {
    const req = transport.request(url, { method: 'GET', headers: HEADERS, lookup, signal }, resolve);
    req.on('error', reject);
    req.end();
  });
}

/**
 * SSRF-safe GET: every hop (including redirects) is re-validated, DNS results must be public,
 * and size, redirects and total time are capped. `lookup` is injectable for tests only.
 */
export async function fetchPublicPage(
  rawUrl: string,
  limits: FetchLimits = DEFAULT_FETCH_LIMITS,
  lookup: SafeLookup = safeLookup,
): Promise<FetchedPage> {
  const signal = AbortSignal.timeout(limits.timeoutMs);
  let url = assertFetchableUrl(rawUrl, limits.allowedPorts);
  try {
    for (let hop = 0; hop <= limits.maxRedirects; hop++) {
      const response = await request(url, signal, lookup);
      const status = response.statusCode ?? 0;
      if (status >= 300 && status < 400 && response.headers.location) {
        response.resume();
        url = assertFetchableUrl(new URL(response.headers.location, url).toString(), limits.allowedPorts);
        continue;
      }
      if (status < 200 || status >= 300) {
        response.resume();
        throw new ParseJobError('fetch_failed', `HTTP ${status}`);
      }
      const contentType = response.headers['content-type'] ?? '';
      if (!/html|xml|text\/plain/i.test(contentType)) {
        response.resume();
        throw new ParseJobError('fetch_failed', `unsupported content-type ${contentType}`);
      }
      const body = await readBody(response, limits.maxBytes);
      return { finalUrl: url.toString(), html: decode(body, contentType) };
    }
    throw new ParseJobError('fetch_failed', 'too many redirects');
  } catch (error) {
    if (error instanceof ParseJobError) throw error;
    if (signal.aborted) throw new ParseJobError('fetch_failed', 'timeout');
    if (error instanceof BlockedAddressError) throw new ParseJobError('url_blocked', error.message);
    throw new ParseJobError('fetch_failed', error instanceof Error ? error.message : String(error));
  }
}
