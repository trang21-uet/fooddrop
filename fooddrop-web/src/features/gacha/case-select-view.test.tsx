import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { fireEvent, render, screen, within } from "@testing-library/react";
import { CaseSelectView } from "./case-select-view";

const get = vi.fn();

vi.mock("next/navigation", () => ({ useRouter: () => ({ push: vi.fn(), replace: vi.fn(), refresh: vi.fn() }) }));
vi.mock("@/lib/api/api-client", () => ({ apiClient: { GET: (...args: unknown[]) => get(...args) } }));

const counts = (overrides: Partial<Record<"white" | "blue" | "purple" | "pink" | "red", number>> = {}) => ({
  white: 0,
  blue: 0,
  purple: 0,
  pink: 0,
  red: 0,
  ...overrides,
});
const dish = (id: string, title: string, rarity: "white" | "red") => ({
  id,
  title,
  imageUrl: null,
  rarity,
  totalMinutes: 20,
  difficulty: 1,
  baseServings: 2,
});
const items = [
  { id: "all", recipeCount: 2, rarityCounts: counts({ white: 1, red: 1 }), preview: [dish("p", "Phở bò", "red"), dish("t", "Trứng", "white")] },
  { id: "breakfast", recipeCount: 0, rarityCounts: counts(), preview: [] },
  { id: "lunch", recipeCount: 0, rarityCounts: counts(), preview: [] },
  { id: "dinner", recipeCount: 0, rarityCounts: counts(), preview: [] },
  { id: "quick", recipeCount: 1, rarityCounts: counts({ white: 1 }), preview: [dish("t", "Trứng", "white")] },
  { id: "epic", recipeCount: 1, rarityCounts: counts({ red: 1 }), preview: [dish("p", "Phở bò", "red")] },
];

function renderView() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <CaseSelectView />
    </QueryClientProvider>,
  );
}

describe("CaseSelectView", () => {
  beforeEach(() => {
    get.mockReset().mockResolvedValue({ data: { items }, response: new Response(null, { status: 200 }) });
  });

  it("shows every case and opens the selected one", async () => {
    renderView();
    const all = await screen.findByRole("button", { name: /Hòm Tổng hợp/ });
    expect(all).toHaveAttribute("aria-pressed", "true");
    expect(screen.getAllByRole("button", { pressed: false })).toHaveLength(5);

    const panel = screen.getByRole("complementary", { name: "Chi tiết hòm" });
    expect(within(panel).getByText("Phở bò")).toBeInTheDocument();
    expect(within(panel).getByText("Huyền thoại · 1")).toBeInTheDocument();
    expect(within(panel).getByRole("link", { name: "Mở Hòm Tổng hợp" })).toHaveAttribute("href", "/drop/all");

    fireEvent.click(screen.getByRole("button", { name: /Hòm Nhanh gọn/ }));
    expect(within(panel).getByRole("link", { name: "Mở Hòm Nhanh gọn" })).toHaveAttribute("href", "/drop/quick");
  });

  it("does not open an empty case", async () => {
    renderView();
    fireEvent.click(await screen.findByRole("button", { name: /Hòm Bữa sáng/ }));
    const panel = screen.getByRole("complementary", { name: "Chi tiết hòm" });
    expect(within(panel).queryByRole("link")).not.toBeInTheDocument();
    expect(within(panel).getByText(/Hòm này chưa có món nào/)).toBeInTheDocument();
  });
});
