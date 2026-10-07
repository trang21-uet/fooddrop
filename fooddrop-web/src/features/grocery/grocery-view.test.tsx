import "fake-indexeddb/auto";
import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it } from "vitest";
import { wipeLocalData } from "@/lib/local-db";
import type { GroceryRecipe } from "./aggregate-grocery";
import { GroceryView } from "./grocery-view";
import { resetGroceryStore, useGroceryStore } from "./use-grocery-store";

const soup: GroceryRecipe = {
  id: "r1",
  title: "Canh cà chua",
  baseServings: 2,
  ingredients: [
    { ingredientId: "tomato", name: "Cà chua", aisle: "produce", quantity: 200, unit: "g" },
    { ingredientId: "egg", name: "Trứng gà", aisle: "dairy", quantity: 2, unit: "piece" },
  ],
};
const salad: GroceryRecipe = {
  id: "r2",
  title: "Salad",
  baseServings: 2,
  ingredients: [{ ingredientId: "tomato", name: "Cà chua", aisle: "produce", quantity: 100, unit: "g" }],
};

beforeEach(async () => {
  await wipeLocalData();
  resetGroceryStore();
  useGroceryStore.setState({ hydrated: true });
});

describe("GroceryView", () => {
  it("shows an empty state", () => {
    render(<GroceryView />);
    expect(screen.getByText(/Chưa có món nào/)).toBeInTheDocument();
  });

  it("merges the same ingredient across recipes, grouped by aisle, and re-derives when servings change", async () => {
    await useGroceryStore.getState().addRecipe(soup, 2);
    await useGroceryStore.getState().addRecipe(salad, 2);
    render(<GroceryView />);

    expect(screen.getByRole("heading", { name: "Rau củ quả" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Trứng & sữa" })).toBeInTheDocument();
    expect(screen.getByText("Cà chua: 300 g")).toBeInTheDocument();

    fireEvent.click(screen.getAllByRole("button", { name: "Tăng khẩu phần" })[1]!);
    expect(await screen.findByText("Cà chua: 350 g")).toBeInTheDocument();
  });

  it("ticks an item and removes a recipe", async () => {
    await useGroceryStore.getState().addRecipe(soup, 2);
    render(<GroceryView />);

    fireEvent.click(screen.getByRole("checkbox", { name: "Trứng gà: 2" }));
    expect(useGroceryStore.getState().checked).toEqual(["egg|piece"]);

    fireEvent.click(screen.getByRole("button", { name: "Bỏ Canh cà chua khỏi danh sách" }));
    expect(await screen.findByText(/Chưa có món nào/)).toBeInTheDocument();
  });
});
