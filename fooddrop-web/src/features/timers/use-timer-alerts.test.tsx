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
  it("rings an expired timer exactly once, including one that ended while the app was closed", async () => {
    useTimerStore.setState({
      hydrated: true,
      timers: [
        { id: "late", label: "Hầm xương", endsAt: Date.now() - 5000, pausedRemainingMs: null, alertedAt: null },
        { id: "later", label: "Đang chạy", endsAt: Date.now() + 600_000, pausedRemainingMs: null, alertedAt: null },
        { id: "paused", label: "Tạm dừng", endsAt: 0, pausedRemainingMs: 30_000, alertedAt: null },
      ],
    });

    renderHook(() => useTimerAlerts());
    await act(async () => {});
    await act(async () => {});

    expect(alertTimerDone).toHaveBeenCalledTimes(1);
    expect(alertTimerDone).toHaveBeenCalledWith("Hầm xương");
    expect(useTimerStore.getState().timers.find((t) => t.id === "late")!.alertedAt).not.toBeNull();
  });
});
