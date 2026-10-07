import "fake-indexeddb/auto";
import { act, renderHook } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { resetTimerStore, useTimerStore } from "./use-timer-store";
import { useTimerAlerts } from "./use-timer-alerts";

const alertTimerDone = vi.hoisted(() => vi.fn());
vi.mock("./timer-alert", () => ({ alertTimerDone }));

beforeEach(() => {
  alertTimerDone.mockClear();
  resetTimerStore();
});

describe("useTimerAlerts", () => {
  it("rings a just-expired timer exactly once and silently retires one that ended long ago", async () => {
    useTimerStore.setState({
      hydrated: true,
      timers: [
        { id: "late", label: "Hầm xương", endsAt: Date.now() - 5000, pausedRemainingMs: null, alertedAt: null },
        { id: "stale", label: "Hôm qua", endsAt: Date.now() - 3_600_000, pausedRemainingMs: null, alertedAt: null },
        { id: "later", label: "Đang chạy", endsAt: Date.now() + 600_000, pausedRemainingMs: null, alertedAt: null },
        { id: "paused", label: "Tạm dừng", endsAt: 0, pausedRemainingMs: 30_000, alertedAt: null },
      ],
    });

    renderHook(() => useTimerAlerts());
    await act(async () => {});
    await act(async () => {});

    expect(alertTimerDone).toHaveBeenCalledTimes(1);
    expect(alertTimerDone).toHaveBeenCalledWith(expect.objectContaining({ id: "late", label: "Hầm xương" }));
    const alertedAt = (id: string) => useTimerStore.getState().timers.find((t) => t.id === id)!.alertedAt;
    expect(alertedAt("late")).not.toBeNull();
    expect(alertedAt("stale")).not.toBeNull();
    expect(alertedAt("later")).toBeNull();
  });
});
