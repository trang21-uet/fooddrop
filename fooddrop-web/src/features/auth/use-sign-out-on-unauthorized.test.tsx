import { renderHook, waitFor } from "@testing-library/react";
import { ApiError } from "@/lib/api/api-error";
import { useSignOutOnUnauthorized } from "./use-sign-out-on-unauthorized";

const replace = vi.fn();
const signOut = vi.fn(async () => ({}));

vi.mock("next/navigation", () => ({ useRouter: () => ({ replace }) }));
vi.mock("@/lib/auth-client", () => ({ authClient: { signOut: () => signOut() } }));

describe("useSignOutOnUnauthorized", () => {
  beforeEach(() => {
    replace.mockClear();
    signOut.mockClear();
  });

  it("clears the session and goes to /login on a 401", async () => {
    renderHook(() => useSignOutOnUnauthorized(new ApiError(401, "Unauthorized")));
    await waitFor(() => expect(replace).toHaveBeenCalledWith("/login"));
    expect(signOut).toHaveBeenCalledTimes(1);
  });

  it.each([new ApiError(500, "boom"), new Error("network"), null])("ignores %s", async (error) => {
    renderHook(() => useSignOutOnUnauthorized(error));
    await Promise.resolve();
    expect(signOut).not.toHaveBeenCalled();
    expect(replace).not.toHaveBeenCalled();
  });
});
