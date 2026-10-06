import type { CSSProperties } from "react";
import type { Rarity } from "./recipe-types";

export const RARITY_STYLES: Record<Rarity, { label: string; color: string }> = {
  white: { label: "Thường", color: "var(--rarity-white)" },
  blue: { label: "Khá hiếm", color: "var(--rarity-blue)" },
  purple: { label: "Hiếm", color: "var(--rarity-purple)" },
  pink: { label: "Sử thi", color: "var(--rarity-pink)" },
  red: { label: "Huyền thoại", color: "var(--rarity-red)" },
};

/** Inline `--glow` feeds the `glow-rarity` utility so cards and badges share one colour source. */
export function rarityGlowStyle(rarity: Rarity): CSSProperties {
  return { "--glow": RARITY_STYLES[rarity].color } as CSSProperties;
}

export function RarityBadge({ rarity }: { rarity: Rarity }) {
  const { label, color } = RARITY_STYLES[rarity];
  return (
    <span
      className="inline-flex items-center gap-1.5 rounded-full border px-2 py-0.5 text-xs font-semibold"
      style={{ color, borderColor: color }}
    >
      <span aria-hidden className="size-1.5 rounded-full" style={{ backgroundColor: color }} />
      {label}
    </span>
  );
}
