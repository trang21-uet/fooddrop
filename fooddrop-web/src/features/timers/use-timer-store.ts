import { create } from "zustand";
import { localDb, persist, type StoredTimer } from "@/lib/local-db";
import { addTimerMs, ONE_MINUTE_MS, pauseTimer, resumeTimer } from "./timer-math";

export type TimerEntry = StoredTimer;

interface TimerState {
  hydrated: boolean;
  timers: TimerEntry[];
  hydrate: () => Promise<void>;
  start: (label: string, durationMs: number) => Promise<void>;
  pause: (id: string) => Promise<void>;
  resume: (id: string) => Promise<void>;
  addMinute: (id: string) => Promise<void>;
  /** Cancels a running timer or dismisses a finished one. */
  cancel: (id: string) => Promise<void>;
  markAlerted: (id: string) => Promise<void>;
}

const initial = { hydrated: false, timers: [] } satisfies Partial<TimerState>;

/** Stores absolute `endsAt`, never "seconds remaining", so a reload or a sleeping tab cannot drift. */
export const useTimerStore = create<TimerState>((set, get) => {
  const update = async (id: string, change: (timer: TimerEntry) => TimerEntry) => {
    const current = get().timers.find((timer) => timer.id === id);
    if (!current) return;
    const next = change(current);
    set((state) => ({ timers: state.timers.map((timer) => (timer.id === id ? next : timer)) }));
    await persist(() => localDb().timers.put(next));
  };

  return {
    ...initial,

    hydrate: async () => {
      if (get().hydrated) return;
      try {
        const timers = await localDb().timers.toArray();
        set({ hydrated: true, timers: timers.sort((a, b) => a.endsAt - b.endsAt) });
      } catch (error) {
        console.error("Could not load timers", error);
        set({ hydrated: true });
      }
    },

    start: async (label, durationMs) => {
      const timer: TimerEntry = {
        id: crypto.randomUUID(),
        label: label.trim() || "Hẹn giờ",
        endsAt: Date.now() + durationMs,
        pausedRemainingMs: null,
        alertedAt: null,
      };
      set((state) => ({ timers: [...state.timers, timer] }));
      await persist(() => localDb().timers.put(timer));
    },

    pause: (id) => update(id, (timer) => pauseTimer(timer, Date.now())),
    // Resuming or extending re-arms the done-alert.
    resume: (id) => update(id, (timer) => ({ ...resumeTimer(timer, Date.now()), alertedAt: null })),
    addMinute: (id) => update(id, (timer) => ({ ...addTimerMs(timer, ONE_MINUTE_MS, Date.now()), alertedAt: null })),
    markAlerted: (id) => update(id, (timer) => ({ ...timer, alertedAt: Date.now() })),

    cancel: async (id) => {
      set((state) => ({ timers: state.timers.filter((timer) => timer.id !== id) }));
      await persist(() => localDb().timers.delete(id));
    },
  };
});

/** Resets in-memory state only (sign-out and tests). */
export function resetTimerStore(): void {
  useTimerStore.setState({ ...initial });
}
