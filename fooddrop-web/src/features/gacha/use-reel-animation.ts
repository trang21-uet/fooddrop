"use client";

import { useEffect, useRef, type RefObject } from "react";
import { reelEase } from "./cubic-bezier";
import type { GachaSpin } from "./gacha-types";
import { slotUnderMarker, targetOffset, type ReelLayout } from "./reel-geometry";
import { playTick } from "./tick-sound-player";

export const SPIN_DURATION_MS = 7000;
export const REDUCED_MOTION_FADE_MS = 1000;
/** Before the first spin the marker sits on this card, so cards fill both sides. */
const IDLE_INDEX = 3;

interface ReelAnimationOptions {
  viewportRef: RefObject<HTMLDivElement | null>;
  stripRef: RefObject<HTMLDivElement | null>;
  spin: GachaSpin | null;
  /** True while the store is `spinning`; otherwise the strip rests on the result (or the start). */
  spinning: boolean;
  onLanded: () => void;
}

const prefersReducedMotion = () =>
  typeof window.matchMedia === "function" && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

/** Card size and gap come from the rendered strip, so CSS stays the single source of the layout. */
function measure(viewport: HTMLElement, strip: HTMLElement): ReelLayout | null {
  const card = strip.firstElementChild;
  if (!card) return null;
  return {
    cardWidth: card.getBoundingClientRect().width,
    gap: Number.parseFloat(getComputedStyle(strip).columnGap) || 0,
    viewportWidth: viewport.clientWidth,
  };
}

/**
 * Drives the strip's `transform` directly from requestAnimationFrame: the offset never enters React
 * state, so a 7 s spin causes no re-render. A tick plays whenever the marker enters a new card slot.
 */
export function useReelAnimation({ viewportRef, stripRef, spin, spinning, onLanded }: ReelAnimationOptions): void {
  const landedRef = useRef(onLanded);
  useEffect(() => {
    landedRef.current = onLanded;
  }, [onLanded]);

  useEffect(() => {
    const viewport = viewportRef.current;
    const strip = stripRef.current;
    if (!viewport || !strip) return;
    const place = (offset: number) => {
      strip.style.transform = `translate3d(${-offset}px, 0, 0)`;
    };
    // At rest the marker is on the winner where the spin stopped (near-miss jitter included), otherwise on an idle card.
    const restingOffset = (layout: ReelLayout) =>
      spin ? targetOffset(layout, spin.winningIndex, spin.offsetJitter) : targetOffset(layout, IDLE_INDEX, 0);

    if (!spin || !spinning) {
      const settle = () => {
        const layout = measure(viewport, strip);
        if (layout) place(restingOffset(layout));
      };
      settle();
      if (typeof ResizeObserver === "undefined") return;
      const observer = new ResizeObserver(settle);
      observer.observe(viewport);
      return () => observer.disconnect();
    }

    const layout = measure(viewport, strip);
    if (!layout) {
      landedRef.current();
      return;
    }
    const end = restingOffset(layout);

    if (prefersReducedMotion()) {
      place(end);
      strip.animate?.([{ opacity: 0 }, { opacity: 1 }], { duration: REDUCED_MOTION_FADE_MS, easing: "ease-out" });
      const timer = setTimeout(() => landedRef.current(), REDUCED_MOTION_FADE_MS);
      return () => clearTimeout(timer);
    }

    place(0);
    let slot = slotUnderMarker(layout, 0);
    let frame = 0;
    const startedAt = performance.now();
    const step = (now: number) => {
      const progress = Math.min(1, (now - startedAt) / SPIN_DURATION_MS);
      const offset = reelEase(progress) * end;
      place(offset);
      const next = slotUnderMarker(layout, offset);
      if (next !== slot) {
        slot = next;
        playTick();
      }
      if (progress < 1) frame = requestAnimationFrame(step);
      else landedRef.current();
    };
    frame = requestAnimationFrame(step);
    return () => cancelAnimationFrame(frame);
  }, [viewportRef, stripRef, spin, spinning]);
}
