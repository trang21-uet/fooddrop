const UNIT_LABELS = { g: "g", ml: "ml", piece: "" } as const;

/** 250 g → "250 g", 2 pieces → "2"; also trims float noise left by unit conversion. */
export function formatQuantity(quantity: number, unit: keyof typeof UNIT_LABELS): string {
  const rounded = Number.parseFloat(quantity.toFixed(2));
  const label = UNIT_LABELS[unit];
  return label ? `${rounded} ${label}` : String(rounded);
}
