import Link from "next/link";
import { RarityBadge, rarityGlowStyle } from "./rarity-badge";
import type { RecipeSummary } from "./recipe-types";

export function RecipeCard({ recipe }: { recipe: RecipeSummary }) {
  return (
    <Link
      href={`/recipes/${recipe.id}`}
      style={rarityGlowStyle(recipe.rarity)}
      className="glow-rarity flex h-full flex-col gap-3 rounded-xl bg-surface p-4 transition hover:-translate-y-0.5 hover:bg-surface-raised"
    >
      <div className="flex items-start justify-between gap-2">
        <h2 className="line-clamp-2 text-base font-semibold leading-snug">{recipe.title}</h2>
        <RarityBadge rarity={recipe.rarity} />
      </div>
      {recipe.description && <p className="line-clamp-2 text-sm text-muted">{recipe.description}</p>}
      <p className="mt-auto text-xs text-muted">
        {recipe.totalMinutes} phút · Độ khó {recipe.difficulty}/5 · {recipe.baseServings} khẩu phần
      </p>
      {recipe.tags.length > 0 && (
        <ul className="flex flex-wrap gap-1.5">
          {recipe.tags.slice(0, 4).map((tag) => (
            <li key={tag.id} className="rounded-md bg-background px-2 py-0.5 text-xs text-muted">
              {tag.label}
            </li>
          ))}
        </ul>
      )}
    </Link>
  );
}
