import { act, fireEvent, render, screen } from "@testing-library/react";
import { RecipeFilterBar } from "./recipe-filter-bar";
import type { RecipeFilters } from "./recipe-filters";

const empty: RecipeFilters = { tagIds: [], rarities: [], q: "" };

describe("RecipeFilterBar", () => {
  afterEach(() => vi.useRealTimers());

  it("toggles rarities and treats 'Tất cả' as no rarity filter", () => {
    const onChange = vi.fn();
    const { rerender } = render(<RecipeFilterBar filters={empty} onChange={onChange} />);
    expect(screen.getByRole("button", { name: "Tất cả" })).toHaveAttribute("aria-pressed", "true");

    fireEvent.click(screen.getByRole("button", { name: "Huyền thoại" }));
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, rarities: ["red"] });

    rerender(<RecipeFilterBar filters={{ ...empty, rarities: ["red"] }} onChange={onChange} />);
    expect(screen.getByRole("button", { name: "Huyền thoại" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByRole("button", { name: "Tất cả" })).toHaveAttribute("aria-pressed", "false");
    fireEvent.click(screen.getByRole("button", { name: "Tất cả" }));
    expect(onChange).toHaveBeenLastCalledWith(empty);
  });

  it("sets and clears the max-minutes filter from the select", () => {
    const onChange = vi.fn();
    render(<RecipeFilterBar filters={{ ...empty, maxMinutes: 30 }} onChange={onChange} />);
    const select = screen.getByRole("combobox", { name: "Thời gian tối đa" });
    expect(select).toHaveValue("30");

    fireEvent.change(select, { target: { value: "120" } });
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, maxMinutes: 120 });
    fireEvent.change(select, { target: { value: "" } });
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, maxMinutes: undefined });
  });

  it("debounces search input before updating filters", () => {
    vi.useFakeTimers();
    const onChange = vi.fn();
    render(<RecipeFilterBar filters={empty} onChange={onChange} />);
    fireEvent.change(screen.getByRole("searchbox", { name: "Tìm công thức" }), { target: { value: "pho" } });
    expect(onChange).not.toHaveBeenCalled();
    act(() => void vi.advanceTimersByTime(350));
    expect(onChange).toHaveBeenCalledWith({ ...empty, q: "pho" });
  });
});
