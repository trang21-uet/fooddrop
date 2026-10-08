import { ApiError, unwrap } from "./api-error";

describe("unwrap", () => {
  it("returns the data of a successful response", () => {
    expect(unwrap({ data: { id: 1 }, response: new Response(null, { status: 200 }) })).toEqual({ id: 1 });
  });

  it("throws an ApiError carrying the status and the server message", () => {
    const failure = { error: { message: "Not found" }, response: new Response(null, { status: 404 }) };
    expect(() => unwrap(failure)).toThrow(expect.objectContaining({ status: 404, message: "Not found" }));
    expect(() => unwrap(failure)).toThrow(ApiError);
  });
});
