import "fake-indexeddb/auto";
import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it } from "vitest";
import { resetGroceryStore, useGroceryStore } from "../grocery/use-grocery-store";
import { RecipeIngredientsPanel } from "./recipe-ingredients-panel";
import type { RecipeDetail } from "./recipe-types";

const unit = (code: string, nameVi: string, kind: "mass" | "volume" | "count") => ({ code, nameVi, nameEn: code, kind });

const recipe = {
  id: "r1",
  title: "Canh cà chua",
  baseServings: 2,
  ingredients: [
    {
      ingredient: { id: "tomato", name: "Cà chua", aisle: "produce" },
      quantity: 200,
      unit: unit("g", "g", "mass"),
      note: null,
      base: { quantity: 200, unit: "g" },
    },
    {
      ingredient: { id: "egg", name: "Trứng gà", aisle: "dairy" },
      quantity: 1,
      unit: unit("fruit", "quả", "count"),
      note: null,
      base: { quantity: 1, unit: "piece" },
    },
    { ingredient: { id: "salt", name: "Muối", aisle: "spices" }, quantity: null, unit: null, note: "tùy khẩu vị", base: { quantity: 0, unit: "g" } },
  ],
} as unknown as RecipeDetail;

beforeEach(() => resetGroceryStore());

describe("RecipeIngredientsPanel", () => {
  it("scales ingredients live when servings change", () => {
    render(<RecipeIngredientsPanel recipe={recipe} />);
    expect(screen.getByText("200 g")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Tăng khẩu phần" }));
    expect(screen.getByText("300 g")).toBeInTheDocument();
    expect(screen.getByText("1.5 quả")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Giảm khẩu phần" }));
    fireEvent.click(screen.getByRole("button", { name: "Giảm khẩu phần" }));
    expect(screen.getByText("100 g")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Giảm khẩu phần" })).toBeDisabled();
  });

  it("shows the unit the cook chose and no amount for an ingredient without a quantity", () => {
    render(<RecipeIngredientsPanel recipe={recipe} />);
    expect(screen.getByText("1 quả")).toBeInTheDocument();
    expect(screen.getByText(/Muối/)).toBeInTheDocument();
    expect(screen.getByText("(tùy khẩu vị)")).toBeInTheDocument();
  });

  it("adds the recipe to the grocery list at the chosen servings", async () => {
    render(<RecipeIngredientsPanel recipe={recipe} />);

    fireEvent.click(screen.getByRole("button", { name: "Tăng khẩu phần" }));
    fireEvent.click(screen.getByRole("button", { name: "Thêm vào đi chợ" }));

    expect(await screen.findByRole("link", { name: "Xem danh sách" })).toHaveAttribute("href", "/grocery");
    expect(useGroceryStore.getState().selections).toEqual([{ recipeId: "r1", servings: 3 }]);
  });
});
