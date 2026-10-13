import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rays and sparks behind the revealed dish, drawn in the rarity colour. [progress] runs 0 → 1
/// once; sparks fly out and fade, rays turn a little and stay.
class RevealBurstPainter extends CustomPainter {
  const RevealBurstPainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  static const _rays = 12;
  static const _sparks = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.longestSide * 0.75;

    canvas.drawCircle(
      center,
      radius * 0.6,
      Paint()
        ..shader = RadialGradient(colors: [color.withValues(alpha: 0.45), color.withValues(alpha: 0)])
            .createShader(Rect.fromCircle(center: center, radius: radius * 0.6)),
    );

    final rayPaint = Paint()
      ..shader = RadialGradient(colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)])
          .createShader(Rect.fromCircle(center: center, radius: radius));
    final turn = progress * math.pi / 6;
    const sweep = math.pi / _rays / 1.5;
    for (var i = 0; i < _rays; i++) {
      final angle = turn + i * 2 * math.pi / _rays;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + radius * math.cos(angle - sweep / 2), center.dy + radius * math.sin(angle - sweep / 2))
        ..lineTo(center.dx + radius * math.cos(angle + sweep / 2), center.dy + radius * math.sin(angle + sweep / 2))
        ..close();
      canvas.drawPath(path, rayPaint);
    }

    if (progress <= 0 || progress >= 1) return;
    final fly = Curves.easeOut.transform(progress);
    final sparkPaint = Paint()
      ..color = color.withValues(alpha: 1 - progress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    for (var i = 0; i < _sparks; i++) {
      final angle = i * 2 * math.pi / _sparks;
      final distance = (90 + (i % 3) * 30) * fly;
      canvas.drawCircle(
        center + Offset(math.cos(angle) * distance, math.sin(angle) * distance),
        4 * (1 - progress * 0.7),
        sparkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(RevealBurstPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
}
