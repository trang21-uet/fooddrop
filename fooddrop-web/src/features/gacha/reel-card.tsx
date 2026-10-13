import { BowlIcon, CubeIcon } from "@/components/ui/icons";
import { RARITY_STYLES } from "../recipes/rarity-badge";
import type { GachaRecipeCard } from "./gacha-types";

const cardClass = "flex h-55 w-37.5 shrink-0 flex-col overflow-hidden rounded-2xl bg-[#241c19] sm:h-70 sm:w-60 sm:rounded-[20px]";

/** One slot of the reel: the photo on top, the name below; the border colour is the rarity. `null` is the mystery card shown while loading. */
export function ReelCard({ card }: { card: GachaRecipeCard | null }) {
  if (!card) {
    return (
      <div className={`${cardClass} items-center justify-center border border-border text-muted`}>
        <CubeIcon width={40} height={40} />
      </div>
    );
  }
  const { color } = RARITY_STYLES[card.rarity];
  return (
    <div className={`${cardClass} border-2`} style={{ borderColor: color, boxShadow: `0 0 18px 1px color-mix(in srgb, ${color} 60%, transparent)` }}>
      <div
        className="relative flex min-h-0 flex-1 items-center justify-center"
        style={{ backgroundImage: `radial-gradient(circle at 50% 45%, color-mix(in srgb, ${color} 25%, #241c19), #241c19 75%)` }}
      >
        {card.imageUrl ? (
          // User-supplied URL on an arbitrary host, so next/image's remote-host allowlist does not fit.
          // eslint-disable-next-line @next/next/no-img-element
          <img src={card.imageUrl} alt="" draggable={false} decoding="async" className="absolute inset-0 size-full object-cover" />
        ) : (
          <BowlIcon width={64} height={64} className="text-foreground/70" />
        )}
      </div>
      <p className="truncate border-t border-border bg-surface px-3 py-2.5 text-[13px] font-bold sm:px-4 sm:py-3.5 sm:text-base">
        {card.title}
      </p>
    </div>
  );
}
