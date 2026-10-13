"use client";

import Link from "next/link";
import { useEffect, type CSSProperties } from "react";
import { Button, buttonClass } from "@/components/ui/button";
import { BowlIcon, ClockIcon, CloseIcon } from "@/components/ui/icons";
import { formatMinutes } from "../recipes/format-minutes";
import { RARITY_STYLES, RarityBadge, rarityGlowStyle } from "../recipes/rarity-badge";
import { AddResultToGroceryButton } from "./add-result-to-grocery-button";
import type { GachaRecipeCard } from "./gacha-types";

/** How long the burst plays before the store moves from `revealing` to `done`. */
export const REVEAL_EFFECT_MS = 1100;
const PARTICLES = Array.from({ length: 18 }, (_, i) => ({ angle: (360 / 18) * i, distance: 110 + (i % 3) * 40 }));

interface RevealOverlayProps {
  result: GachaRecipeCard;
  revealing: boolean;
  onRevealed: () => void;
  onClose: () => void;
  onSpinAgain: () => void;
  spinAgainDisabled: boolean;
}

export function RevealOverlay({ result, revealing, onRevealed, onClose, onSpinAgain, spinAgainDisabled }: RevealOverlayProps) {
  const color = RARITY_STYLES[result.rarity].color;

  useEffect(() => {
    if (!revealing) return;
    const timer = setTimeout(onRevealed, REVEAL_EFFECT_MS);
    return () => clearTimeout(timer);
  }, [revealing, onRevealed]);

  useEffect(() => {
    const onKey = (event: KeyboardEvent) => event.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/75 p-4 backdrop-blur-sm">
      <div
        role="dialog"
        aria-modal="true"
        aria-labelledby="reveal-title"
        style={{ ...rarityGlowStyle(result.rarity), "--burst": color } as CSSProperties}
        className="reveal-pop glow-rarity relative flex w-full max-w-sm flex-col overflow-hidden rounded-3xl bg-surface"
      >
        <div className="relative flex h-52 items-center justify-center overflow-hidden">
          <span aria-hidden className="reveal-rays absolute inset-[-50%]" />
          {result.imageUrl ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={result.imageUrl} alt="" className="relative size-40 rounded-2xl object-cover shadow-2xl" />
          ) : (
            <BowlIcon width={96} height={96} className="relative text-foreground" />
          )}
          {PARTICLES.map(({ angle, distance }) => (
            <span
              key={angle}
              aria-hidden
              className="reveal-particle absolute top-1/2 left-1/2 size-2 rounded-full"
              style={{ "--angle": `${angle}deg`, "--distance": `${distance}px` } as CSSProperties}
            />
          ))}
          <button
            type="button"
            onClick={onClose}
            aria-label="Đóng"
            className="absolute top-3 right-3 flex size-11 items-center justify-center rounded-full bg-background/70 text-muted hover:text-foreground"
          >
            <CloseIcon />
          </button>
        </div>

        <div className="flex flex-col gap-4 p-5">
          <div className="flex flex-col items-start gap-2">
            <RarityBadge rarity={result.rarity} />
            <h2 id="reveal-title" className="text-2xl leading-tight font-extrabold tracking-tight">
              {result.title}
            </h2>
            <p className="flex items-center gap-3 text-sm text-muted">
              <span className="flex items-center gap-1.5">
                <ClockIcon width={15} height={15} />
                {formatMinutes(result.totalMinutes)}
              </span>
              <span>Độ khó {result.difficulty}/5</span>
            </p>
          </div>
          <div className="flex flex-col gap-2.5">
            {/* autoFocus: the dialog opens with focus on its main action. */}
            <Link href={`/recipes/${result.id}`} autoFocus className={buttonClass("primary", "lg")}>
              Nấu món này
            </Link>
            <AddResultToGroceryButton recipeId={result.id} />
            <Button variant="ghost" onClick={onSpinAgain} disabled={spinAgainDisabled}>
              Quay lại lần nữa
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
