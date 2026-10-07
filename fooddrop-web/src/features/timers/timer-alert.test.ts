import { afterEach, describe, expect, it, vi } from "vitest";
import { alertTimerDone } from "./timer-alert";

describe("alertTimerDone", () => {
  afterEach(() => vi.unstubAllGlobals());

  it("tags each notification by timer id so same-named timers do not replace each other", () => {
    const created: { title: string; options: NotificationOptions }[] = [];
    class FakeNotification {
      static permission = "granted";
      constructor(title: string, options: NotificationOptions) {
        created.push({ title, options });
      }
    }
    vi.stubGlobal("Notification", FakeNotification);

    alertTimerDone({ id: "a", label: "Hẹn giờ" });
    alertTimerDone({ id: "b", label: "Hẹn giờ" });

    expect(created.map((c) => c.options.tag)).toEqual(["timer-a", "timer-b"]);
    expect(created[0]!.options.body).toBe("Hẹn giờ");
  });
});
