import "fake-indexeddb/auto";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { localDb, wipeLocalData } from "@/lib/local-db";
import { resetTimerStore, useTimerStore } from "./use-timer-store";

const NOW = 1_000_000;

beforeEach(async () => {
  vi.useFakeTimers({ toFake: ["Date"] });
  vi.setSystemTime(NOW);
  await wipeLocalData();
  resetTimerStore();
});

afterEach(() => {
  vi.useRealTimers();
});

describe("timer store", () => {
  it("stores an absolute endsAt and persists it", async () => {
    await useTimerStore.getState().start("Luộc trứng", 600_000);

    const [timer] = useTimerStore.getState().timers;
    expect(timer).toMatchObject({ label: "Luộc trứng", endsAt: NOW + 600_000, pausedRemainingMs: null, alertedAt: null });
    expect(await localDb().timers.get(timer!.id)).toEqual(timer);
  });

  it("falls back to a default label", async () => {
    await useTimerStore.getState().start("   ", 1000);
    expect(useTimerStore.getState().timers[0]!.label).toBe("Hẹn giờ");
  });

  it("pauses and resumes without losing remaining time", async () => {
    await useTimerStore.getState().start("a", 60_000);
    const id = useTimerStore.getState().timers[0]!.id;

    vi.setSystemTime(NOW + 20_000);
    await useTimerStore.getState().pause(id);
    expect(useTimerStore.getState().timers[0]).toMatchObject({ pausedRemainingMs: 40_000 });

    vi.setSystemTime(NOW + 500_000);
    await useTimerStore.getState().resume(id);
    expect(useTimerStore.getState().timers[0]).toMatchObject({ endsAt: NOW + 540_000, pausedRemainingMs: null });
  });

  it("adds a minute and re-arms the alert", async () => {
    await useTimerStore.getState().start("a", 1000);
    const id = useTimerStore.getState().timers[0]!.id;
    await useTimerStore.getState().markAlerted(id);
    expect(useTimerStore.getState().timers[0]!.alertedAt).not.toBeNull();

    await useTimerStore.getState().addMinute(id);
    expect(useTimerStore.getState().timers[0]).toMatchObject({ endsAt: NOW + 1000 + 60_000, alertedAt: null });
  });

  it("restores timers after a reload", async () => {
    await useTimerStore.getState().start("a", 5000);
    const saved = useTimerStore.getState().timers;

    resetTimerStore();
    expect(useTimerStore.getState().timers).toEqual([]);
    await useTimerStore.getState().hydrate();

    expect(useTimerStore.getState()).toMatchObject({ hydrated: true, timers: saved });
  });

  it("cancel removes the timer from memory and storage", async () => {
    await useTimerStore.getState().start("a", 5000);
    const id = useTimerStore.getState().timers[0]!.id;
    await useTimerStore.getState().cancel(id);

    expect(useTimerStore.getState().timers).toEqual([]);
    expect(await localDb().timers.count()).toBe(0);
  });
});
