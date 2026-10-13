import { create } from "zustand";
import type { CaseId } from "./gacha-case-styles";
import type { GachaSpin } from "./gacha-types";

export type GachaStatus = "idle" | "spinning" | "revealing" | "done";

interface GachaState {
  status: GachaStatus;
  /** The latest server response. Kept after the overlay closes so the reel stays on the result. */
  spin: GachaSpin | null;
  /** The case `spin` came from, so another case's page does not show it. */
  caseId: CaseId | null;
  startSpin: (spin: GachaSpin, caseId: CaseId) => void;
  /** The reel stopped on the winner: show the reveal. */
  reveal: () => void;
  /** The reveal effect finished: actions are ready. */
  finish: () => void;
  dismiss: () => void;
}

/** Only the state machine and the response live here; the reel position stays in the animation. */
export const useGachaStore = create<GachaState>((set, get) => ({
  status: "idle",
  spin: null,
  caseId: null,
  startSpin: (spin, caseId) => set({ status: "spinning", spin, caseId }),
  reveal: () => {
    if (get().status === "spinning") set({ status: "revealing" });
  },
  finish: () => {
    if (get().status === "revealing") set({ status: "done" });
  },
  dismiss: () => set({ status: "idle" }),
}));
