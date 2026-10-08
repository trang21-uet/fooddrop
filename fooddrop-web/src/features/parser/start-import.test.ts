import { ApiError } from "@/lib/api/api-error";
import { startUrlImport } from "./start-import";

const post = vi.fn();
vi.mock("@/lib/api/api-client", () => ({ apiClient: { POST: (...args: unknown[]) => post(...args) } }));

const answer = (status: number, body: object) =>
  status < 400
    ? { data: body, response: new Response(null, { status }) }
    : { error: body, response: new Response(null, { status }) };

describe("startUrlImport", () => {
  beforeEach(() => post.mockReset());

  it("returns the created job with the server's cooldown", async () => {
    post.mockResolvedValue(answer(201, { id: "job-1", cooldownSeconds: 45 }));
    await expect(startUrlImport("https://blog.example/a")).resolves.toMatchObject({ id: "job-1", cooldownSeconds: 45 });
    expect(post).toHaveBeenCalledWith("/parser/jobs", { body: { url: "https://blog.example/a" } });
  });

  it("carries retryAfterSeconds from a cooldown 429", async () => {
    post.mockResolvedValue(answer(429, { statusCode: 429, code: "parse_cooldown", message: "Please wait", retryAfterSeconds: 42 }));
    const error = await startUrlImport("https://blog.example/a").catch((e: unknown) => e);
    expect(error).toBeInstanceOf(ApiError);
    expect(error).toMatchObject({ status: 429, retryAfterSeconds: 42 });
  });

  it("has no retryAfterSeconds on the daily-quota 429", async () => {
    post.mockResolvedValue(answer(429, { statusCode: 429, code: "parse_daily_quota", message: "Daily recipe import limit reached" }));
    const error = await startUrlImport("https://blog.example/a").catch((e: unknown) => e);
    expect(error).toMatchObject({ status: 429, retryAfterSeconds: undefined });
  });
});
