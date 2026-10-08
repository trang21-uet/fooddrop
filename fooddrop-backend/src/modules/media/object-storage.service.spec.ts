import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DeleteObjectsCommand } from '@aws-sdk/client-s3';
import { ObjectStorageService } from './object-storage.service.js';

const values: Record<string, string | undefined> = {
  S3_ACCESS_KEY_ID: 'key',
  S3_SECRET_ACCESS_KEY: 'secret',
  S3_ENDPOINT: 'http://localhost:9000',
  S3_REGION: 'auto',
  S3_BUCKET: 'bucket',
};

function setup(overrides: Record<string, string | undefined> = {}) {
  const config = { get: (name: string) => ({ ...values, ...overrides })[name] } as unknown as ConfigService<never, true>;
  const service = new ObjectStorageService(config);
  const send = vi.fn();
  (service as unknown as { client: { send: typeof send } | null }).client = overrides.S3_ACCESS_KEY_ID === '' ? null : { send };
  return { service, send };
}

describe('ObjectStorageService.deleteObjects', () => {
  afterEach(() => vi.restoreAllMocks());

  it('deletes in batches of at most 1000 keys', async () => {
    const { service, send } = setup();
    send.mockResolvedValue({});

    await service.deleteObjects(Array.from({ length: 2500 }, (_, i) => `recipes/u1/${i}.jpg`));

    expect(send).toHaveBeenCalledTimes(3);
    const sizes = send.mock.calls.map(([command]) => (command as DeleteObjectsCommand).input.Delete?.Objects?.length);
    expect(sizes).toEqual([1000, 1000, 500]);
  });

  it('logs keys the store refused, which do not make the call throw', async () => {
    const { service, send } = setup();
    const warn = vi.spyOn(Logger.prototype, 'warn').mockImplementation(() => {});
    send.mockResolvedValue({ Errors: [{ Key: 'recipes/u1/a.jpg', Code: 'AccessDenied' }] });

    await expect(service.deleteObjects(['recipes/u1/a.jpg'])).resolves.toBeUndefined();

    expect(warn).toHaveBeenCalledWith(expect.stringContaining('AccessDenied'));
  });

  it('never throws when the request itself fails, and keeps going with the next batch', async () => {
    const { service, send } = setup();
    const warn = vi.spyOn(Logger.prototype, 'warn').mockImplementation(() => {});
    send.mockRejectedValueOnce(new Error('network down')).mockResolvedValue({});

    await expect(service.deleteObjects(Array.from({ length: 1500 }, (_, i) => `k${i}`))).resolves.toBeUndefined();

    expect(send).toHaveBeenCalledTimes(2);
    expect(warn).toHaveBeenCalledTimes(1);
  });

  it('does nothing when storage is not configured or there is nothing to delete', async () => {
    const { service, send } = setup({ S3_ACCESS_KEY_ID: '' });
    await service.deleteObjects(['recipes/u1/a.jpg']);
    const configured = setup();
    await configured.service.deleteObjects([]);

    expect(send).not.toHaveBeenCalled();
    expect(configured.send).not.toHaveBeenCalled();
  });
});
