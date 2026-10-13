import { reelEase } from "./cubic-bezier";
import { cardPitch, slotUnderMarker, targetOffset, type ReelLayout } from "./reel-geometry";

const layout: ReelLayout = { cardWidth: 160, gap: 8, viewportWidth: 900 };

describe("reelEase", () => {
  it("starts at 0, ends at 1 and never moves backwards", () => {
    expect(reelEase(0)).toBe(0);
    expect(reelEase(1)).toBe(1);
    let previous = 0;
    for (let i = 1; i <= 1000; i++) {
      const value = reelEase(i / 1000);
      expect(value).toBeGreaterThanOrEqual(previous);
      previous = value;
    }
  });

  it("covers most of the distance early and crawls at the end", () => {
    expect(reelEase(0.2)).toBeGreaterThan(0.6);
    expect(1 - reelEase(0.9)).toBeLessThan(0.01);
  });
});

describe("reel geometry", () => {
  it("lands the marker inside the winning card for every jitter", () => {
    for (const jitter of [-0.4, -0.1, 0, 0.25, 0.4]) {
      const offset = targetOffset(layout, 60, jitter);
      expect(slotUnderMarker(layout, offset)).toBe(60);
      const markerInsideCard = offset + layout.viewportWidth / 2 - 60 * cardPitch(layout);
      expect(markerInsideCard).toBeGreaterThan(0);
      expect(markerInsideCard).toBeLessThan(layout.cardWidth);
    }
  });

  it("ticks once per boundary crossed, whatever the frame rate", () => {
    const end = targetOffset(layout, 60, 0.3);
    const expected = slotUnderMarker(layout, end) - slotUnderMarker(layout, 0);
    for (const frames of [17, 420, 5000]) {
      let ticks = 0;
      let slot = slotUnderMarker(layout, 0);
      for (let frame = 1; frame <= frames; frame++) {
        const next = slotUnderMarker(layout, reelEase(frame / frames) * end);
        // A long frame can skip several boundaries; each still counts (the player plays at most one).
        ticks += next - slot;
        slot = next;
      }
      expect(ticks).toBe(expected);
    }
  });
});
