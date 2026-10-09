import { InfoIcon } from "@/components/ui/icons";
import { StartStepTimerButton } from "../timers/start-step-timer-button";
import type { RecipeDetail } from "./recipe-types";

type RecipeStep = RecipeDetail["steps"][number];

/** One numbered step card: text, photos, then the note box and the timer button. User text renders as plain text. */
export function RecipeStepItem({ step, recipeTitle }: { step: RecipeStep; recipeTitle: string }) {
  return (
    <li className="flex gap-4 rounded-2xl border border-border bg-surface p-4 sm:gap-[18px] sm:p-5">
      <span
        aria-hidden
        className="flex size-9 shrink-0 items-center justify-center rounded-full border border-accent bg-surface-raised font-mono text-[15px] font-semibold text-accent"
      >
        {step.order}
      </span>
      <div className="flex min-w-0 flex-1 flex-col gap-3">
        {step.name && <h3 className="text-lg font-bold tracking-tight">{step.name}</h3>}
        <p className="whitespace-pre-line leading-relaxed">{step.text}</p>
        {step.images.length > 0 && (
          <ul className="flex flex-wrap gap-3">
            {step.images.map((image, index) =>
              image.url ? (
                <li key={image.key}>
                  <a href={image.url} target="_blank" rel="noopener noreferrer" className="block">
                    {/* eslint-disable-next-line @next/next/no-img-element -- signed storage URLs, not optimizable */}
                    <img
                      src={image.url}
                      alt={`Ảnh ${index + 1} của bước ${step.order}`}
                      loading="lazy"
                      className="h-[116px] w-[168px] rounded-xl border border-border object-cover"
                    />
                  </a>
                </li>
              ) : null,
            )}
          </ul>
        )}
        {step.note && (
          <div className="flex items-start gap-3 rounded-xl border border-border bg-surface-raised px-3.5 py-3">
            <InfoIcon width={18} height={18} className="mt-0.5 shrink-0 text-accent" />
            <p className="text-sm leading-normal whitespace-pre-line text-foreground/85">
              <strong className="font-bold text-accent">Lưu ý:</strong> {step.note}
            </p>
          </div>
        )}
        {step.timerSeconds && (
          <StartStepTimerButton
            seconds={step.timerSeconds}
            label={step.timerLabel ?? `${recipeTitle} · bước ${step.order}`}
            caption={step.timerLabel}
          />
        )}
      </div>
    </li>
  );
}
