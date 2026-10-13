"use client";

import { useRef } from "react";
import type { GachaRecipeCard, GachaSpin } from "./gacha-types";
import { ReelCard } from "./reel-card";
import { useReelAnimation } from "./use-reel-animation";

const PLACEHOLDER_CARDS = Array.from({ length: 14 }, () => null);

interface CaseReelProps {
  spin: GachaSpin | null;
  /** Shown before the first spin; mystery cards while it loads or when the user has no recipe. */
  idleCards?: GachaRecipeCard[];
  spinning: boolean;
  onLanded: () => void;
}

export function CaseReel({ spin, idleCards, spinning, onLanded }: CaseReelProps) {
  const viewportRef = useRef<HTMLDivElement>(null);
  const stripRef = useRef<HTMLDivElement>(null);
  useReelAnimation({ viewportRef, stripRef, spin, spinning, onLanded });

  const cards = spin?.reel ?? (idleCards?.length ? idleCards : PLACEHOLDER_CARDS);
  return (
    // Decorative: the result is announced by the reveal dialog.
    <div
      ref={viewportRef}
      aria-hidden
      className="relative overflow-hidden rounded-[22px] border border-border bg-[#17110f] py-10 shadow-[inset_0_0_60px_rgb(0_0_0/0.5)] sm:rounded-[28px] sm:py-17.5"
    >
      <div ref={stripRef} className="flex w-max gap-3 will-change-transform sm:gap-4" data-testid="reel-strip">
        {cards.map((card, index) => (
          <ReelCard key={index} card={card} />
        ))}
      </div>

      <span className="pointer-events-none absolute inset-y-0 left-0 w-[18%] bg-linear-to-r from-[#17110f] from-[8%] to-transparent sm:w-[22%]" />
      <span className="pointer-events-none absolute inset-y-0 right-0 w-[18%] bg-linear-to-l from-[#17110f] from-[8%] to-transparent sm:w-[22%]" />
      {/* The marker: a thin line across the stage, as in CS2; the card under it is the result. */}
      <span className="pointer-events-none absolute inset-y-0 left-1/2 z-10 w-0.5 -translate-x-1/2 bg-linear-to-b from-[#ffc233] via-accent to-accent-hot shadow-[0_0_10px_var(--accent)]" />
    </div>
  );
}
