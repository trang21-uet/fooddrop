import Link from "next/link";
import { buttonClass } from "@/components/ui/button";
import { DeleteRecipeButton } from "./delete-recipe-button";
import { StartStepTimerButton } from "../timers/start-step-timer-button";
import { RarityBadge, rarityGlowStyle } from "./rarity-badge";
import { RecipeIngredientsPanel } from "./recipe-ingredients-panel";
import type { RecipeDetail } from "./recipe-types";

/** Server Component: steps and notes are user text, rendered as plain text nodes (React escapes them). */
export function RecipeDetailView({ recipe }: { recipe: RecipeDetail }) {
  return (
    <article className="flex flex-col gap-8">
      <header
        style={rarityGlowStyle(recipe.rarity)}
        className="glow-rarity flex flex-col gap-4 rounded-2xl bg-surface p-5 sm:p-6"
      >
        <div className="flex flex-wrap items-start justify-between gap-3">
          <h1 className="text-3xl font-bold tracking-tight">{recipe.title}</h1>
          <RarityBadge rarity={recipe.rarity} />
        </div>
        {recipe.description && <p className="whitespace-pre-line text-muted">{recipe.description}</p>}
        <dl className="flex flex-wrap gap-x-8 gap-y-2 text-sm">
          <Stat label="Thời gian" value={`${recipe.totalMinutes} phút`} />
          <Stat label="Độ khó" value={`${recipe.difficulty}/5`} />
          <Stat label="Khẩu phần" value={String(recipe.baseServings)} />
        </dl>
        {recipe.tags.length > 0 && (
          <ul className="flex flex-wrap gap-1.5">
            {recipe.tags.map((tag) => (
              <li key={tag.id} className="rounded-md bg-background px-2 py-0.5 text-xs text-muted">
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
      </header>

      <div className="grid gap-8 md:grid-cols-[1fr_2fr]">
        <RecipeIngredientsPanel recipe={recipe} />

        <section aria-labelledby="steps-heading">
          <h2 id="steps-heading" className="mb-3 text-lg font-semibold">
            Cách làm
          </h2>
          <ol className="flex flex-col gap-3">
            {recipe.steps.map((step) => (
              <li key={step.order} className="flex gap-4 rounded-xl border border-border bg-surface p-4">
                <span aria-hidden className="font-mono text-lg font-bold text-accent">
                  {step.order}
                </span>
                <div className="flex flex-col gap-1">
                  <p className="whitespace-pre-line">{step.text}</p>
                  {step.timerSeconds && (
                    <StartStepTimerButton
                      seconds={step.timerSeconds}
                      label={step.timerLabel ?? `${recipe.title} · bước ${step.order}`}
                    />
                  )}
                </div>
              </li>
            ))}
          </ol>
        </section>
      </div>
    </article>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex gap-2">
      <dt className="text-muted">{label}</dt>
      <dd className="font-semibold">{value}</dd>
    </div>
  );
}
