import { fireEvent, render, screen } from "@testing-library/react";
import type { RecipeFilters } from "./recipe-filters";
import { RecipeTagFilters } from "./recipe-tag-filters";
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

describe("RecipeTagFilters", () => {
  it("groups tag chips under their dimension and reflects the selection", () => {
    render(<RecipeTagFilters filters={{ ...empty, tagIds: [11] }} dimensions={dimensions} onChange={vi.fn()} />);
    expect(screen.getByRole("group", { name: "Cuisine" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Japanese" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByRole("button", { name: "Vietnamese" })).toHaveAttribute("aria-pressed", "false");
  });

  it("toggles a tag on and off", () => {
    const onChange = vi.fn();
    const { rerender } = render(<RecipeTagFilters filters={empty} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Vietnamese" }));
    expect(onChange).toHaveBeenLastCalledWith({ ...empty, tagIds: [10] });

    rerender(<RecipeTagFilters filters={{ ...empty, tagIds: [10] }} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Vietnamese" }));
    expect(onChange).toHaveBeenLastCalledWith(empty);
  });

  it("clears every filter, not just tags", () => {
    const onChange = vi.fn();
    const active: RecipeFilters = { tagIds: [10], rarities: ["red"], maxMinutes: 30, q: "pho" };
    render(<RecipeTagFilters filters={active} dimensions={dimensions} onChange={onChange} />);
    fireEvent.click(screen.getByRole("button", { name: "Xóa tất cả" }));
    expect(onChange).toHaveBeenCalledWith(empty);
  });
});
