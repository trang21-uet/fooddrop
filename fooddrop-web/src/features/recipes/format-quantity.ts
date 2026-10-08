import type { BaseUnit, Unit } from "./recipe-types";

const BASE_LABELS = { g: "g", ml: "ml", piece: "" } as const;

const trimNumber = (quantity: number): number => Number.parseFloat(quantity.toFixed(2));

/** Grocery totals: 250 g → "250 g", 2 pieces → "2"; also trims float noise left by conversion. */
export function formatQuantity(quantity: number, unit: BaseUnit): string {
  const rounded = trimNumber(quantity);
  const label = BASE_LABELS[unit];
  return label ? `${rounded} ${label}` : String(rounded);
}

/** A recipe line as written: "2 thìa canh", "2" (no unit), "" (no quantity: "muối, tùy khẩu vị"). */
export function formatAmount(quantity: number | null, unit: Pick<Unit, "nameVi"> | null): string {
  if (quantity === null) return "";
  const rounded = trimNumber(quantity);
  return unit ? `${rounded} ${unit.nameVi}` : String(rounded);
}
