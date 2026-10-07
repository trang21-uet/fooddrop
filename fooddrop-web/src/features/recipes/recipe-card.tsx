import Link from "next/link";
import { BowlIcon, ClockIcon } from "@/components/ui/icons";
import { formatMinutes } from "./format-minutes";
import { RARITY_STYLES, RarityBadge, rarityGlowStyle } from "./rarity-badge";
import type { RecipeSummary } from "./recipe-types";

export function RecipeCard({ recipe }: { recipe: RecipeSummary }) {
  const color = RARITY_STYLES[recipe.rarity].color;

  return (
    <Link
      href={`/recipes/${recipe.id}`}
      style={rarityGlowStyle(recipe.rarity)}
      className="glow-rarity flex h-full flex-col overflow-hidden rounded-2xl bg-surface transition hover:-translate-y-0.5 hover:bg-surface-raised"
    >
      <div
        className="relative flex h-37 items-center justify-center"
        style={{ backgroundImage: `linear-gradient(135deg, color-mix(in srgb, ${color} 22%, var(--surface)), var(--background))` }}
      >
        {recipe.imageUrl ? (
          // User-supplied URL on an arbitrary host, so next/image's remote-host allowlist does not fit.
          // eslint-disable-next-line @next/next/no-img-element
          <img src={recipe.imageUrl} alt="" loading="lazy" className="absolute inset-0 size-full object-cover" />
        ) : (
          <BowlIcon width={60} height={60} className="text-foreground/80" />
        )}
        <RarityBadge rarity={recipe.rarity} className="absolute top-3 left-3" />
      </div>
      <div className="flex flex-1 flex-col gap-2.5 p-4">
        <h2 className="line-clamp-2 text-[17px] leading-tight font-bold tracking-tight">{recipe.title}</h2>
        <p className="flex items-center gap-3.5 text-[13px] text-muted">
          <span className="flex items-center gap-1.5">
            <ClockIcon width={15} height={15} />
            {formatMinutes(recipe.totalMinutes)}
          </span>
          <span>Độ khó {recipe.difficulty}/5</span>
        </p>
        {recipe.tags.length > 0 && (
          <ul className="mt-auto flex flex-wrap gap-1.5">
            {recipe.tags.slice(0, 4).map((tag) => (
              <li key={tag.id} className="rounded-full bg-surface-raised px-2.5 py-0.5 text-xs text-muted">
                {tag.label}
              </li>
            ))}
          </ul>
        )}
      </div>
    </Link>
  );
}
