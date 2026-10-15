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
const featured = (id: string) => ({ id, group: "featured" as const, label: null });
const items = [
  { ...featured("all"), recipeCount: 2, rarityCounts: counts({ white: 1, red: 1 }), preview: [dish("p", "Phở bò", "red"), dish("t", "Trứng", "white")] },
  { ...featured("quick"), recipeCount: 0, rarityCounts: counts(), preview: [] },
  { ...featured("epic"), recipeCount: 1, rarityCounts: counts({ red: 1 }), preview: [dish("p", "Phở bò", "red")] },
  { id: "cuisine.vietnamese", group: "cuisine", label: "Món Việt", recipeCount: 2, rarityCounts: counts({ white: 1, red: 1 }), preview: [dish("p", "Phở bò", "red"), dish("t", "Trứng", "white")] },
  { id: "cuisine.japanese", group: "cuisine", label: "Món Nhật", recipeCount: 1, rarityCounts: counts({ white: 1 }), preview: [dish("t", "Trứng", "white")] },
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

  it("shows the featured tab first and opens the selected case", async () => {
    renderView();
    const all = await screen.findByRole("button", { name: /Hòm Tổng hợp/ });
    expect(all).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByRole("tab", { name: /Nổi bật/ })).toHaveAttribute("aria-selected", "true");
    expect(screen.getAllByRole("button", { pressed: false })).toHaveLength(2);

    const panel = screen.getByRole("complementary", { name: "Chi tiết hòm" });
    expect(within(panel).getByText("Phở bò")).toBeInTheDocument();
    expect(within(panel).getByText("Huyền thoại · 1")).toBeInTheDocument();
    expect(within(panel).getByRole("link", { name: "Mở Hòm Tổng hợp" })).toHaveAttribute("href", "/drop/all");

    fireEvent.click(screen.getByRole("button", { name: /Hòm Cầu kỳ/ }));
    expect(within(panel).getByRole("link", { name: "Mở Hòm Cầu kỳ" })).toHaveAttribute("href", "/drop/epic");
  });

  it("switches tabs to the tag cases of that dimension", async () => {
    renderView();
    fireEvent.click(await screen.findByRole("tab", { name: /Ẩm thực/ }));
    expect(screen.queryByRole("button", { name: /Hòm Tổng hợp/ })).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Hòm Món Việt/ })).toHaveAttribute("aria-pressed", "true");

    fireEvent.click(screen.getByRole("button", { name: /Hòm Món Nhật/ }));
    const panel = screen.getByRole("complementary", { name: "Chi tiết hòm" });
    expect(within(panel).getByRole("link", { name: "Mở Hòm Món Nhật" })).toHaveAttribute("href", "/drop/cuisine.japanese");

    fireEvent.click(screen.getByRole("tab", { name: /Dụng cụ/ }));
    expect(screen.getByText(/Chưa có công thức nào gắn thẻ dụng cụ/)).toBeInTheDocument();
    expect(screen.queryByRole("complementary", { name: "Chi tiết hòm" })).not.toBeInTheDocument();
  });

  it("does not open an empty case", async () => {
    renderView();
    fireEvent.click(await screen.findByRole("button", { name: /Hòm Nhanh gọn/ }));
    const panel = screen.getByRole("complementary", { name: "Chi tiết hòm" });
    expect(within(panel).queryByRole("link")).not.toBeInTheDocument();
    expect(within(panel).getByText(/Hòm này chưa có món nào/)).toBeInTheDocument();
  });
});
