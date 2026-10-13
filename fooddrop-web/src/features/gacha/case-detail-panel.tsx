import Link from "next/link";
import { buttonClass } from "@/components/ui/button";
import { CubeIcon } from "@/components/ui/icons";
import { RARITY_STYLES } from "../recipes/rarity-badge";
import { RARITY_ORDER } from "../recipes/recipe-filters";
import { ChestIcon } from "./chest-icon";
import { CASE_STYLES, type GachaCase } from "./gacha-case-styles";
import { RaritySegments } from "./rarity-segments";

/** The selected case: its rarity mix, its rarest dishes and the button that opens it. */
export function CaseDetailPanel({ item }: { item: GachaCase }) {
  const { name, color } = CASE_STYLES[item.id];
  const tiers = RARITY_ORDER.filter((rarity) => item.rarityCounts[rarity] > 0);
  const hidden = item.recipeCount - item.preview.length;

  return (
    <aside
      aria-label="Chi tiết hòm"
      className="flex flex-col gap-4.5 rounded-[22px] border bg-surface p-6 lg:sticky lg:top-6 lg:w-105 lg:shrink-0"
      style={{ borderColor: color, boxShadow: `0 0 0 1px ${color}, 0 0 28px -4px ${color}aa` }}
    >
      <div className="flex items-center gap-4">
        <ChestIcon color={color} width={84} />
        <div className="flex flex-col gap-0.5">
          <span className="text-xs font-semibold tracking-widest text-muted uppercase">Đã chọn</span>
          <h2 className="text-[26px] leading-tight font-extrabold tracking-tight">{name}</h2>
        </div>
      </div>

      <div className="flex flex-col gap-2.5">
        <div className="flex items-baseline justify-between">
          <span className="text-sm font-semibold">Thành phần theo độ hiếm</span>
          <span className="font-mono text-[13px] text-muted">{item.recipeCount} công thức</span>
        </div>
        <RaritySegments counts={item.rarityCounts} height={10} />
        <ul className="flex flex-wrap gap-x-3.5 gap-y-1.5">
          {tiers.map((rarity) => (
            <li key={rarity} className="flex items-center gap-1.5 text-xs text-muted">
              <span aria-hidden className="size-2 rounded-full" style={{ backgroundColor: RARITY_STYLES[rarity].color }} />
              {RARITY_STYLES[rarity].label} · {item.rarityCounts[rarity]}
            </li>
          ))}
        </ul>
      </div>

      <div className="flex flex-col gap-2">
        <h3 className="text-sm font-semibold">Chứa trong hòm</h3>
        {item.recipeCount === 0 ? (
          <p className="rounded-[14px] border border-border bg-surface-raised p-4 text-sm text-muted">
            Hòm này chưa có món nào. Thêm công thức hoặc gắn thẻ phù hợp để mở được hòm.
          </p>
        ) : (
          <ul className="flex flex-col overflow-hidden rounded-[14px] border border-border">
            {item.preview.map((dish) => {
              const rarity = RARITY_STYLES[dish.rarity];
              return (
                <li key={dish.id} className="flex min-h-12 items-center gap-3 border-t border-border bg-surface-raised px-3.5 first:border-t-0">
                  <span aria-hidden className="size-2.5 shrink-0 rounded-full" style={{ backgroundColor: rarity.color, boxShadow: `0 0 8px ${rarity.color}` }} />
                  <span className="min-w-0 flex-1 truncate text-[15px] font-medium">{dish.title}</span>
                  <span className="shrink-0 text-xs font-semibold" style={{ color: rarity.color }}>
                    {rarity.label}
                  </span>
                </li>
              );
            })}
            {hidden > 0 && (
              <li className="border-t border-border bg-surface-raised px-3.5 py-3 text-[13px] text-muted">và {hidden} món khác</li>
            )}
          </ul>
        )}
      </div>

      <OpenCaseButton item={item} />
    </aside>
  );
}

/** Opens the case on its reel page; an empty case cannot be opened. */
export function OpenCaseButton({ item }: { item: GachaCase }) {
  const { name } = CASE_STYLES[item.id];
  const className = `${buttonClass("primary", "lg")} min-h-14 text-lg font-extrabold`;
  if (item.recipeCount === 0) {
    return (
      <span aria-disabled="true" className={`${className} cursor-not-allowed opacity-50`}>
        <CubeIcon width={22} height={22} />
        Mở {name}
      </span>
    );
  }
  return (
    <Link href={`/drop/${item.id}`} className={`${className} glow-accent`}>
      <CubeIcon width={22} height={22} />
      Mở {name}
    </Link>
  );
}
