import { describe, expect, it } from "vitest";
import type { GroceryAisleGroup } from "./aggregate-grocery";
import { groceryShareText } from "./grocery-share-text";

const groups: GroceryAisleGroup[] = [
  {
    aisle: "produce",
    items: [
      { ingredientId: "tomato", name: "Cà chua", unit: "g", quantity: 550 },
      { ingredientId: "chili", name: "Ớt", unit: "g", quantity: 0 },
    ],
  },
  { aisle: "dairy", items: [{ ingredientId: "egg", name: "Trứng gà", unit: "piece", quantity: 2 }] },
];

describe("groceryShareText", () => {
  it("lists unticked items grouped by aisle", () => {
    expect(groceryShareText(groups, new Set())).toBe(
      "Danh sách đi chợ\n\nRau củ quả\n- Cà chua: 550 g\n- Ớt\n\nTrứng & sữa\n- Trứng gà: 2",
    );
  });

  it("drops ticked items and empty aisles", () => {
    expect(groceryShareText(groups, new Set(["tomato|g", "chili|g"]))).toBe("Danh sách đi chợ\n\nTrứng & sữa\n- Trứng gà: 2");
  });

  it("says so when everything is bought", () => {
    expect(groceryShareText(groups, new Set(["tomato|g", "chili|g", "egg|piece"]))).toBe("Danh sách đi chợ\n\nĐã mua đủ.");
  });
});
