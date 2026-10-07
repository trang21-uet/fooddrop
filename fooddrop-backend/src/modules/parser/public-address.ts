import { lookup as dnsLookup, type LookupAddress } from 'node:dns';
import ipaddr from 'ipaddr.js';

/**
 * Only globally routable unicast addresses pass: loopback, private, link-local (cloud metadata),
 * carrier-grade NAT, ULA, multicast, reserved and IPv4-mapped IPv6 are all rejected.
 */
export function isPublicAddress(address: string): boolean {
  const bare = address.replace(/^\[|\]$/g, '');
  return ipaddr.isValid(bare) && ipaddr.parse(bare).range() === 'unicast';
}

export class BlockedAddressError extends Error {
  constructor(hostname: string) {
    super(`Blocked non-public address for ${hostname}`);
    this.name = 'BlockedAddressError';
  }
}

type LookupCallback = (
  error: NodeJS.ErrnoException | null,
  address: string | LookupAddress[],
  family?: number,
) => void;

export type SafeLookup = (hostname: string, options: { all?: boolean }, callback: LookupCallback) => void;

/**
 * `lookup` hook for http(s).request. Validating inside the connection's own DNS step (instead of
 * resolving first and connecting later) closes the DNS-rebinding window: the address that is
 * checked is the address that is dialed.
 */
export const safeLookup: SafeLookup = (hostname, options, callback) => {
  dnsLookup(hostname, { all: true }, (error, addresses) => {
    if (error) return callback(error, '', 0);
    if (addresses.length === 0 || addresses.some((entry) => !isPublicAddress(entry.address))) {
      return callback(new BlockedAddressError(hostname), '', 0);
    }
    if (options.all) return callback(null, addresses);
    return callback(null, addresses[0]!.address, addresses[0]!.family);
  });
};
