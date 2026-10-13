/// Reel layout in logical pixels. Same math as the web reel (`reel-geometry.ts`).
class ReelLayout {
  const ReelLayout({required this.cardWidth, required this.gap, required this.viewportWidth});

  final double cardWidth;

  /// Space between two cards.
  final double gap;

  /// Width of the visible window; the marker sits at its center.
  final double viewportWidth;

  double get pitch => cardWidth + gap;

  /// Strip translation (applied as `-offset`) that puts the marker on the winning card,
  /// `offsetJitter` card widths away from its center. At offset 0 the marker is over the first cards.
  double targetOffset(int winningIndex, double offsetJitter) =>
      winningIndex * pitch + cardWidth / 2 + offsetJitter * cardWidth - viewportWidth / 2;

  /// Card slot under the marker. It changes exactly when the marker crosses a slot boundary,
  /// which is when the tick plays: ticks follow position, never time.
  int slotUnderMarker(double offset) => ((offset + viewportWidth / 2) / pitch).floor();
}
