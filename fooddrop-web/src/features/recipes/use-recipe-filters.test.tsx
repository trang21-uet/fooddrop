import { act, renderHook } from "@testing-library/react";
import { useRecipeFilters } from "./use-recipe-filters";

const replace = vi.fn();
let search = "";

vi.mock("next/navigation", () => ({
  useRouter: () => ({ replace }),
  usePathname: () => "/recipes",
  useSearchParams: () => new URLSearchParams(search),
}));

describe("useRecipeFilters (URL sync)", () => {
  beforeEach(() => {
    replace.mockClear();
    search = "";
  });

  it("derives filters from the URL", () => {
    search = "tags=3,4&rarity=pink&maxMinutes=15&q=ga";
    const { result } = renderHook(() => useRecipeFilters());
    expect(result.current.filters).toEqual({ tagIds: [3, 4], rarities: ["pink"], maxMinutes: 15, q: "ga" });
  });

  it("writes filters to the URL without scrolling", () => {
    const { result } = renderHook(() => useRecipeFilters());
    act(() => result.current.setFilters({ tagIds: [7], rarities: ["blue", "red"], q: "" }));
    expect(replace).toHaveBeenCalledWith("/recipes?tags=7&rarity=blue%2Cred", { scroll: false });
  });

  it("drops the query string entirely when filters are cleared", () => {
    search = "tags=7";
    const { result } = renderHook(() => useRecipeFilters());
    act(() => result.current.setFilters({ tagIds: [], rarities: [], q: "" }));
    expect(replace).toHaveBeenCalledWith("/recipes", { scroll: false });
  });
});
