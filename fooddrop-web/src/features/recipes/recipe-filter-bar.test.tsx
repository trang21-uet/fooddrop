import { act, fireEvent, render, screen } from "@testing-library/react";
import { RecipeFilterBar } from "./recipe-filter-bar";
import type { RecipeFilters } from "./recipe-filters";
import type { TagDimension } from "./recipe-types";

const dimensions: TagDimension[] = [
  {
    id: 1,
    slug: "cuisine",
    label: "Cuisine",
    tags: [
      { id: 10, slug: "vietnamese", label: "Vietnamese" },
      { id: 11, slug: "japanese", label: "Japanese" },
    ],
  },
];
const empty: RecipeFilters = { tagIds: [], rarities: [], q: "" };

describe("RecipeFilterBar", () => {
  afterEach(() => vi.useRealTimers());

  it("groups tag chips under their dimension and reflects the selection", () => {
    render(<RecipeFilterBar filters={{ ...empty, tagIds: [11] }} dimensions={dimensions} onChange={vi.fn()} />);
    expect(screen.getByRole("group", { name: "Cuisine" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Japanese" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByRole("button", { name: "Vietnamese" })).toHaveAttribute("aria-pressed", "false");
  });

  it("toggles a tag on and off", () => {
    const onChange = vi.fn();
    const { rerender } = render(<RecipeFilterBar filters={empty} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Vietnamese" }));
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, tagIds: [10] });

    rerender(<RecipeFilterBar filters={{ ...empty, tagIds: [10] }} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Vietnamese" }));
    expect(onChange).toHaveBeenLastCalledWith(empty);
  });

  it("sets rarity and max-minutes filters, and a second click on time clears it", () => {
    const onChange = vi.fn();
    render(<RecipeFilterBar filters={{ ...empty, maxMinutes: 30 }} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Huyền thoại" }));
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, maxMinutes: 30, rarities: ["red"] });
    fireEvent.click(screen.getByRole("button", { name: "≤ 30 phút" }));
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, maxMinutes: undefined });
  });

  it("debounces search input before updating filters", () => {
    vi.useFakeTimers();
    const onChange = vi.fn();
    render(<RecipeFilterBar filters={empty} dimensions={dimensions} onChange={onChange} />);
    fireEvent.change(screen.getByRole("searchbox", { name: "Tìm công thức" }), { target: { value: "pho" } });
    expect(onChange).not.toHaveBeenCalled();
    act(() => void vi.advanceTimersByTime(350));
    expect(onChange).toHaveBeenCalledWith({ ...empty, q: "pho" });
  });

  it("offers the clear button only when something is active", () => {
    const onChange = vi.fn();
    const { rerender } = render(<RecipeFilterBar filters={empty} dimensions={dimensions} onChange={onChange} />);
    expect(screen.queryByRole("button", { name: "Xóa bộ lọc" })).not.toBeInTheDocument();

    rerender(<RecipeFilterBar filters={{ ...empty, tagIds: [10] }} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Xóa bộ lọc" }));
    expect(onChange).toHaveBeenCalledWith(empty);
  });
});
