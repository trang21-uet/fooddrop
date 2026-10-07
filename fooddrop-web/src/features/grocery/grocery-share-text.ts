import { formatQuantity } from "../recipes/format-quantity";
import { AISLE_LABELS } from "./aisle-labels";
import { groceryItemKey, type GroceryAisleGroup, type GroceryItem } from "./aggregate-grocery";

/** "Cà chua: 550 g"; items with no amount (unknown unit) are just the name. */
export function groceryItemLine(item: GroceryItem): string {
  return item.quantity > 0 ? `${item.name}: ${formatQuantity(item.quantity, item.unit)}` : item.name;
}

/** Plain-text list of what is still to buy (unticked items), grouped by aisle, for a chat or note app. */
export function groceryShareText(groups: readonly GroceryAisleGroup[], checked: ReadonlySet<string>): string {
  const sections = groups
    .map((group) => ({ aisle: group.aisle, items: group.items.filter((item) => !checked.has(groceryItemKey(item))) }))
    .filter((group) => group.items.length > 0)
    .map((group) => [AISLE_LABELS[group.aisle], ...group.items.map((item) => `- ${groceryItemLine(item)}`)].join("\n"));
  return ["Danh sách đi chợ", ...(sections.length > 0 ? sections : ["Đã mua đủ."])].join("\n\n");
}
