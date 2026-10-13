"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import Link from "next/link";
import { useCallback, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { CubeIcon } from "@/components/ui/icons";
import { useSignOutOnUnauthorized } from "@/features/auth/use-sign-out-on-unauthorized";
import { CaseReel } from "./case-reel";
import { CASE_STYLES, type CaseId } from "./gacha-case-styles";
import { preloadReelImages } from "./preload-reel-images";
import { requestSpin, spinErrorMessage } from "./request-spin";
import { RevealOverlay } from "./reveal-overlay";
import { SpinHistoryList } from "./spin-history-list";
import { playReveal, prepareReelSounds, unlockReelSounds } from "./tick-sound-player";
import { useGachaCasesQuery } from "./use-gacha-cases-query";
import { useGachaStore } from "./use-gacha-store";
import { SPIN_HISTORY_KEY } from "./use-spin-history-query";

/** Below this many recipes the reel repeats a lot, so suggest adding more. */
const SMALL_POOL = 5;

/** The reel for one case, opened from the case picker. */
export function DropView({ caseId }: { caseId: CaseId }) {
  const style = CASE_STYLES[caseId];
  const cases = useGachaCasesQuery();
  const current = cases.data?.find((item) => item.id === caseId);
  const queryClient = useQueryClient();
  const { status, startSpin, reveal, finish, dismiss } = useGachaStore();
  // A spin from another case's page is not shown here.
  const spin = useGachaStore((state) => (state.caseId === caseId ? state.spin : null));

  const spinMutation = useMutation({
    mutationFn: async () => {
      const result = await requestSpin(caseId);
      await preloadReelImages(result);
      return result;
    },
    onSuccess: (result) => startSpin(result, caseId),
  });
  useSignOutOnUnauthorized(spinMutation.error ?? cases.error);

  // Build the audio graph now: creating it on the spin click can stall the reel start.
  useEffect(() => {
    void prepareReelSounds();
  }, []);

  // Leaving the page closes the reveal; a spin still running replays when the user comes back.
  useEffect(() => () => {
    if (useGachaStore.getState().status !== "spinning") useGachaStore.getState().dismiss();
  }, []);

  const onLanded = useCallback(() => {
    const result = useGachaStore.getState().spin?.result;
    if (result) playReveal(result.rarity);
    reveal();
    void queryClient.invalidateQueries({ queryKey: SPIN_HISTORY_KEY });
  }, [reveal, queryClient]);

  const busy = spinMutation.isPending || status === "spinning" || status === "revealing";
  const spinNow = () => {
    spinMutation.mutate();
    // Inside the click handler, so the browser lets the AudioContext start.
    void unlockReelSounds();
  };

  return (
    <div className="flex flex-col items-center gap-6">
      <div className="flex flex-col items-center gap-2 text-center">
        <h1 className="text-4xl leading-none font-extrabold tracking-tighter sm:text-5xl">Hôm nay ăn gì?</h1>
        <p className="text-[17px] text-muted">Mở hộp để bếp quyết định giúp bạn.</p>
      </div>

      <Link
        href="/drop"
        className="flex min-h-11 items-center gap-2 rounded-full border bg-surface-raised px-4 text-[13px] font-semibold"
        style={{ borderColor: style.color, boxShadow: `0 0 14px -4px ${style.color}` }}
      >
        <span aria-hidden className="size-2 rounded-full" style={{ backgroundColor: style.color, boxShadow: `0 0 8px ${style.color}` }} />
        {style.name}
        {current && ` · ${current.recipeCount} công thức`}
        <span className="text-accent">&nbsp;· Đổi hòm</span>
      </Link>

      <section aria-label="Vòng quay" className="flex w-full flex-col items-center gap-5">
        <div className="w-full">
          <CaseReel spin={spin} idleCards={current?.preview} spinning={status === "spinning" && spin !== null} onLanded={onLanded} />
        </div>

        <Button variant="primary" size="lg" onClick={spinNow} disabled={busy || current?.recipeCount === 0} className="min-h-15 min-w-60 text-xl font-extrabold glow-accent">
          <CubeIcon width={22} height={22} />
          {spinMutation.isPending ? "Đang mở…" : status === "spinning" ? "Đang quay…" : "Mở hộp"}
        </Button>

        <div aria-live="polite" className="flex flex-col items-center gap-1 text-center text-sm">
          {status === "spinning" && <span className="sr-only">Đang quay…</span>}
          {current?.recipeCount === 0 && <p className="text-muted">Hòm này chưa có món nào. Chọn hòm khác nhé.</p>}
          {spinMutation.isError && (
            <p role="alert" className="text-danger">
              {spinErrorMessage(spinMutation.error)}
            </p>
          )}
          {spin && status !== "spinning" && spin.poolSize < SMALL_POOL && (
            <p className="text-muted">Hòm chỉ có {spin.poolSize} món — thêm công thức để vòng quay đa dạng hơn.</p>
          )}
        </div>

        <div className="w-full max-w-3xl">
          <SpinHistoryList />
        </div>
      </section>

      {spin && (status === "revealing" || status === "done") && (
        <RevealOverlay
          result={spin.result}
          revealing={status === "revealing"}
          onRevealed={finish}
          onClose={dismiss}
          onSpinAgain={() => {
            dismiss();
            spinNow();
          }}
          spinAgainDisabled={spinMutation.isPending}
        />
      )}
    </div>
  );
}
