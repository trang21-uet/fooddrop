import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import type { GachaRecipeCard, GachaSpin } from "./gacha-types";
import { DropView } from "./drop-view";
import { useGachaStore } from "./use-gacha-store";

const get = vi.fn();
const post = vi.fn();
const playReveal = vi.fn();

vi.mock("next/navigation", () => ({ useRouter: () => ({ push: vi.fn(), replace: vi.fn(), refresh: vi.fn() }) }));
vi.mock("@/lib/api/api-client", () => ({
  apiClient: { GET: (...args: unknown[]) => get(...args), POST: (...args: unknown[]) => post(...args) },
}));
vi.mock("./tick-sound-player", () => ({
  prepareReelSounds: vi.fn(async () => undefined),
  unlockReelSounds: vi.fn(async () => undefined),
  playTick: vi.fn(),
  playReveal: (...args: unknown[]) => playReveal(...args),
}));

const card = (id: string, overrides: Partial<GachaRecipeCard> = {}): GachaRecipeCard => ({
  id,
  title: `Món ${id}`,
  imageUrl: null,
  rarity: "white",
  totalMinutes: 15,
  difficulty: 1,
  baseServings: 2,
  ...overrides,
});
const winner = card("win", { title: "Bún chả", rarity: "purple" });
const spin: GachaSpin = {
  spinId: "11111111-1111-4111-8111-111111111111",
  caseType: "cook",
  createdAt: "2026-10-13T00:00:00.000Z",
  result: winner,
  reel: Array.from({ length: 70 }, (_, i) => (i === 60 ? winner : card(`f${i}`))),
  winningIndex: 60,
  offsetJitter: 0.1,
  poolSize: 3,
};
const dinnerCase = (recipeCount: number) => ({
  id: "dinner",
  recipeCount,
  rarityCounts: { white: 0, blue: 0, purple: recipeCount, pink: 0, red: 0 },
  preview: recipeCount ? [winner] : [],
});
let cases = [dinnerCase(3)];
const ok = (data: unknown, status = 200) => ({ data, response: new Response(null, { status }) });

function renderView() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <DropView caseId="dinner" />
    </QueryClientProvider>,
  );
}

describe("DropView", () => {
  beforeEach(() => {
    useGachaStore.setState({ status: "idle", spin: null, caseId: null });
    cases = [dinnerCase(3)];
    get.mockReset().mockImplementation(async (path: string) => ok({ items: path === "/gacha/cases" ? cases : [] }));
    post.mockReset();
    playReveal.mockReset();
    // Reduced motion: the reel fades to the result instead of a 7 s spin.
    vi.stubGlobal("matchMedia", (query: string) => ({ matches: query.includes("reduce"), addEventListener: vi.fn(), removeEventListener: vi.fn() }));
  });

  afterEach(() => vi.unstubAllGlobals());

  it("spins, lands on the server's result and reveals it", async () => {
    post.mockResolvedValue(ok(spin, 201));
    renderView();
    expect(await screen.findByRole("link", { name: /Hòm Bữa tối · 3 công thức.*Đổi hòm/ })).toHaveAttribute("href", "/drop");
    fireEvent.click(screen.getByRole("button", { name: "Mở hộp" }));

    expect(await screen.findByRole("button", { name: "Đang quay…" })).toBeDisabled();
    const dialog = await screen.findByRole("dialog", {}, { timeout: 3000 });
    expect(dialog).toHaveTextContent("Bún chả");
    expect(screen.getByRole("link", { name: "Nấu món này" })).toHaveAttribute("href", "/recipes/win");
    expect(playReveal).toHaveBeenCalledWith("purple");
    expect(post).toHaveBeenCalledWith("/gacha/spins", { body: { caseType: "cook", caseId: "dinner" } });
    // History is refetched only after landing.
    await waitFor(() => expect(get.mock.calls.filter(([path]) => path === "/gacha/spins")).toHaveLength(2));
    expect(screen.getByText(/Hòm chỉ có 3 món/)).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Đóng" }));
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Mở hộp" })).toBeEnabled();
  });

  it("explains when the server finds the case empty", async () => {
    post.mockResolvedValue({
      data: undefined,
      error: { statusCode: 422, code: "gacha_empty_pool", message: "This case has no recipes" },
      response: new Response(null, { status: 422 }),
    });
    renderView();
    await screen.findByRole("link", { name: /Đổi hòm/ });
    fireEvent.click(screen.getByRole("button", { name: "Mở hộp" }));

    expect(await screen.findByRole("alert")).toHaveTextContent("Hòm này chưa có món nào");
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
  });

  it("disables opening an empty case", async () => {
    cases = [dinnerCase(0)];
    renderView();
    expect(await screen.findByText("Hòm này chưa có món nào. Chọn hòm khác nhé.")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Mở hộp" })).toBeDisabled();
  });

  it("does not show another case's spin", () => {
    useGachaStore.setState({ status: "done", spin, caseId: "quick" });
    renderView();
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
  });
});
