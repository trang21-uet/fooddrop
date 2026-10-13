import { RARITY_STYLES } from "../recipes/rarity-badge";
import { RARITY_ORDER } from "../recipes/recipe-filters";
import type { GachaCase } from "./gacha-case-styles";

/** A case's rarity mix as one bar, a segment per tier sized by its count. Decorative; counts are in text nearby. */
export function RaritySegments({ counts, height = 6 }: { counts: GachaCase["rarityCounts"]; height?: number }) {
  const tiers = RARITY_ORDER.filter((rarity) => counts[rarity] > 0);
  return (
    <span aria-hidden className="flex w-full gap-0.5" style={{ height }}>
      {tiers.length === 0 && <span className="flex-1 rounded-full bg-border" />}
      {tiers.map((rarity) => (
        <span
          key={rarity}
          className="rounded-full"
          style={{ flex: counts[rarity], backgroundColor: RARITY_STYLES[rarity].color }}
        />
      ))}
    </span>
  );
}
