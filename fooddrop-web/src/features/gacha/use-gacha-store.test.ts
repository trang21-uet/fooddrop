import type { GachaSpin } from "./gacha-types";
import { useGachaStore } from "./use-gacha-store";

const spin = { spinId: "s1" } as GachaSpin;

describe("useGachaStore", () => {
  beforeEach(() => useGachaStore.setState({ status: "idle", spin: null, caseId: null }));

  it("walks idle → spinning → revealing → done", () => {
    const { startSpin, reveal, finish } = useGachaStore.getState();
    startSpin(spin, "all");
    expect(useGachaStore.getState()).toMatchObject({ status: "spinning", spin, caseId: "all" });
    reveal();
    expect(useGachaStore.getState().status).toBe("revealing");
    finish();
    expect(useGachaStore.getState().status).toBe("done");
  });

  it("ignores out-of-order events", () => {
    const { reveal, finish } = useGachaStore.getState();
    finish();
    reveal();
    expect(useGachaStore.getState().status).toBe("idle");
  });

  it("keeps the result after the overlay is dismissed", () => {
    useGachaStore.getState().startSpin(spin, "all");
    useGachaStore.getState().dismiss();
    expect(useGachaStore.getState()).toMatchObject({ status: "idle", spin });
  });
});
