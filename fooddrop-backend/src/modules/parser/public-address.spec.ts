import { isPublicAddress, safeLookup } from './public-address.js';

describe('isPublicAddress', () => {
  it.each(['8.8.8.8', '93.184.216.34', '2606:4700:4700::1111'])('allows public %s', (address) => {
    expect(isPublicAddress(address)).toBe(true);
  });

  it.each([
    '127.0.0.1', '10.0.0.5', '172.16.3.4', '192.168.1.1', '169.254.169.254', '100.64.0.1', '0.0.0.0',
    '224.0.0.1', '255.255.255.255', '::1', '::', 'fe80::1', 'fc00::1', '::ffff:127.0.0.1', '[::1]', 'not-an-ip',
  ])('blocks %s', (address) => {
    expect(isPublicAddress(address)).toBe(false);
  });
});

describe('safeLookup', () => {
  const lookup = (hostname: string, all = false) =>
    new Promise<unknown>((resolve) =>
      safeLookup(hostname, { all }, (error, address, family) => resolve({ error: error?.name, address, family })),
    );

  it('rejects hostnames that resolve to loopback', async () => {
    expect(await lookup('localhost')).toMatchObject({ error: 'BlockedAddressError' });
    expect(await lookup('localhost', true)).toMatchObject({ error: 'BlockedAddressError' });
  });
});
