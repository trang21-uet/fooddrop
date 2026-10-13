export interface ReelLayout {
  cardWidth: number;
  /** Space between two cards. */
  gap: number;
  /** Width of the visible window; the marker sits at its center. */
  viewportWidth: number;
}

/** Distance from one card's left edge to the next. */
export const cardPitch = ({ cardWidth, gap }: ReelLayout) => cardWidth + gap;

/**
 * Strip translation (px, applied as `translateX(-offset)`) that puts the marker on the winning card,
 * `offsetJitter` card widths away from its center. At offset 0 the marker is over the first cards.
 */
export function targetOffset(layout: ReelLayout, winningIndex: number, offsetJitter: number): number {
  const markerOnStrip = winningIndex * cardPitch(layout) + layout.cardWidth / 2 + offsetJitter * layout.cardWidth;
  return markerOnStrip - layout.viewportWidth / 2;
}

/**
 * Index of the card slot under the marker. It changes exactly when the marker crosses a slot
 * boundary, which is when the tick plays — ticks follow position, never time.
 */
export function slotUnderMarker(layout: ReelLayout, offset: number): number {
  return Math.floor((offset + layout.viewportWidth / 2) / cardPitch(layout));
}
