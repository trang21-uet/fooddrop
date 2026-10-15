import { ChestIcon } from "./chest-icon";
import { caseStyle, type GachaCase } from "./gacha-case-styles";
import { RaritySegments } from "./rarity-segments";

/** One case tile in the picker; pressed when selected. */
export function CaseCard({ item, selected, onSelect }: { item: GachaCase; selected: boolean; onSelect: () => void }) {
  const { name, rule, tag, color } = caseStyle(item);
  return (
    <button
      type="button"
      aria-pressed={selected}
      onClick={onSelect}
      className="flex flex-col items-center gap-2 rounded-[20px] border bg-surface px-4 pt-4.5 pb-4 text-center transition hover:bg-surface-raised"
      style={{
        borderColor: selected ? color : "var(--border)",
        boxShadow: selected ? `0 0 0 1px ${color}, 0 0 28px -4px ${color}aa` : "none",
      }}
    >
      <span
        className="flex h-30 w-full items-center justify-center sm:h-37.5"
        style={{ background: `radial-gradient(closest-side, ${color}33, transparent 90%)` }}
      >
        <ChestIcon color={color} tag={tag} width={130} />
      </span>
      <span className="text-lg font-extrabold tracking-tight">{name}</span>
      <span className="text-[13px] text-muted">{rule}</span>
      <span className="font-mono text-[13px] font-semibold" style={{ color }}>
        {item.recipeCount} công thức
      </span>
      <span className="mt-1 w-full">
        <RaritySegments counts={item.rarityCounts} />
      </span>
    </button>
  );
}
