import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/gacha/domain/reel_geometry.dart';
import 'package:fooddrop/features/gacha/presentation/case_reel.dart';

void main() {
  const layout = ReelLayout(cardWidth: 120, gap: 8, viewportWidth: 390);

  test('lands the marker inside the winning card for every jitter', () {
    for (final jitter in [-0.4, -0.1, 0.0, 0.25, 0.4]) {
      final offset = layout.targetOffset(60, jitter);
      expect(layout.slotUnderMarker(offset), 60);
      final markerInsideCard = offset + layout.viewportWidth / 2 - 60 * layout.pitch;
      expect(markerInsideCard, greaterThan(0));
      expect(markerInsideCard, lessThan(layout.cardWidth));
    }
  });

  test('counts one boundary per slot crossed, whatever the frame rate', () {
    final end = layout.targetOffset(60, 0.3);
    final expected = layout.slotUnderMarker(end) - layout.slotUnderMarker(0);
    for (final frames in [17, 420, 5000]) {
      var crossed = 0;
      var slot = layout.slotUnderMarker(0);
      for (var frame = 1; frame <= frames; frame++) {
        final next = layout.slotUnderMarker(reelCurve.transform(frame / frames) * end);
        crossed += next - slot;
        slot = next;
      }
      expect(crossed, expected);
    }
  });

  test('the reel curve is the CSS cubic-bezier(0.1, 0.7, 0.1, 1)', () {
    expect(reelCurve, isA<Cubic>());
    expect(reelCurve.transform(0.2), greaterThan(0.6));
    expect(1 - reelCurve.transform(0.9), lessThan(0.01));
  });
}
