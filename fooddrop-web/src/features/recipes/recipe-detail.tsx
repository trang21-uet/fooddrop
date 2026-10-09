import Link from "next/link";
import { buttonClass } from "@/components/ui/button";
import { BowlIcon } from "@/components/ui/icons";
import { DeleteRecipeButton } from "./delete-recipe-button";
import { formatMinutes } from "./format-minutes";
import { RARITY_STYLES, RarityBadge, rarityGlowStyle } from "./rarity-badge";
import { RecipeIngredientsPanel } from "./recipe-ingredients-panel";
import { RecipeStepItem } from "./recipe-step-item";
import type { RecipeDetail } from "./recipe-types";

/** Server Component: steps and notes are user text, rendered as plain text nodes (React escapes them). */
export function RecipeDetailView({ recipe }: { recipe: RecipeDetail }) {
  return (
    <article className="flex flex-col gap-8">
      <header className="flex flex-wrap items-stretch gap-8">
        <RecipeCover recipe={recipe} />
        <div className="flex flex-[1_1_420px] flex-col justify-center gap-4">
          <RarityBadge rarity={recipe.rarity} className="self-start" />
          <h1 className="text-4xl leading-[1.02] font-extrabold tracking-tight sm:text-5xl">{recipe.title}</h1>
          {recipe.description && (
            <p className="max-w-[520px] text-[17px] leading-relaxed whitespace-pre-line text-muted">{recipe.description}</p>
          )}
          <dl className="flex flex-wrap gap-7">
            <Stat label="Tổng thời gian" value={formatMinutes(recipe.totalMinutes)} />
            <Stat label="Độ khó" value={`${recipe.difficulty} / 5`} />
            <Stat label="Khẩu phần" value={`${recipe.baseServings} người`} />
          </dl>
          {recipe.tags.length > 0 && (
            <ul className="flex flex-wrap gap-2">
              {recipe.tags.map((tag) => (
                <li key={tag.id} className="rounded-full border border-border bg-surface-raised px-3.5 py-1.5 text-[13px] font-semibold">
                  {tag.label}
                </li>
              ))}
            </ul>
          )}
          <div className="flex flex-wrap items-center gap-3">
            <Link href={`/recipes/${recipe.id}/edit`} className={buttonClass("secondary")}>
              Sửa
            </Link>
            <DeleteRecipeButton recipeId={recipe.id} />
            {recipe.sourceUrl && (
              <a
                href={recipe.sourceUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-accent underline-offset-4 hover:underline"
              >
                Nguồn gốc
              </a>
            )}
          </div>
        </div>
      </header>

      <div className="grid gap-8 md:grid-cols-[1fr_2fr]">
        <RecipeIngredientsPanel recipe={recipe} />

        <section aria-labelledby="steps-heading" className="flex min-w-0 flex-col gap-4">
          <h2 id="steps-heading" className="text-[22px] font-bold">
            Cách làm
          </h2>
          <ol className="flex flex-col gap-3.5">
            {recipe.steps.map((step) => (
              <RecipeStepItem key={step.order} step={step} recipeTitle={recipe.title} />
            ))}
          </ol>
        </section>
      </div>
    </article>
  );
}

/** Dish photo framed in the rarity glow; a rarity-tinted bowl when there is no photo. */
function RecipeCover({ recipe }: { recipe: RecipeDetail }) {
  const color = RARITY_STYLES[recipe.rarity].color;
  return (
    <div
      style={{
        ...rarityGlowStyle(recipe.rarity),
        backgroundImage: `linear-gradient(135deg, color-mix(in srgb, ${color} 22%, var(--surface)), var(--background))`,
      }}
      className="glow-rarity relative flex min-h-64 flex-[1_1_380px] items-center justify-center overflow-hidden rounded-[20px] sm:min-h-80"
    >
      {recipe.imageUrl ? (
        // User-supplied URL on an arbitrary host, so next/image's remote-host allowlist does not fit.
        // eslint-disable-next-line @next/next/no-img-element
        <img src={recipe.imageUrl} alt={recipe.title} className="absolute inset-0 size-full object-cover" />
      ) : (
        <BowlIcon width={120} height={120} strokeWidth={1} className="text-foreground/80" />
      )}
    </div>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex flex-col gap-0.5">
      <dt className="text-xs tracking-[0.08em] text-muted uppercase">{label}</dt>
      <dd className="text-[22px] font-bold">{value}</dd>
    </div>
  );
}
