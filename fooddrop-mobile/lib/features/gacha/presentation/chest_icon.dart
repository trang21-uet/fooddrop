import 'package:flutter/material.dart';

/// The case ("hòm") drawing from the design board, outlined in [color], with [tag] on its front plate.
class ChestIcon extends StatelessWidget {
  const ChestIcon({super.key, required this.color, this.tag, this.width = 100});

  final Color color;
  final String? tag;
  final double width;

  @override
  Widget build(BuildContext context) {
    final scale = width / 160;
    return SizedBox(
      width: width,
      height: 140 * scale,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _ChestPainter(color, withPlate: tag != null))),
          if (tag != null)
            Positioned(
              left: 38 * scale,
              top: 96 * scale,
              width: 84 * scale,
              height: 22 * scale,
              child: Center(
                child: Text(
                  tag!,
                  style: TextStyle(color: color, fontSize: 12 * scale, fontWeight: FontWeight.w700, height: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChestPainter extends CustomPainter {
  const _ChestPainter(this.color, {required this.withPlate});

  final Color color;
  final bool withPlate;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 160);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final glow = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    RRect box(double x, double y, double w, double h, double r) => RRect.fromLTRBR(x, y, x + w, y + h, Radius.circular(r));

    final body = box(22, 52, 116, 76, 10);
    final lid = box(14, 34, 132, 26, 9);
    canvas
      ..drawRRect(body, glow)
      ..drawRRect(lid, glow)
      ..drawRRect(body, Paint()..color = const Color(0xFF2A211E))
      ..drawRRect(body, stroke)
      ..drawRect(const Rect.fromLTWH(48, 52, 8, 76), Paint()..color = color.withValues(alpha: 0.35))
      ..drawRect(const Rect.fromLTWH(104, 52, 8, 76), Paint()..color = color.withValues(alpha: 0.35))
      ..drawRRect(lid, Paint()..color = const Color(0xFF33271F))
      ..drawRRect(lid, stroke)
      ..drawRRect(box(70, 52, 20, 26, 5), Paint()..color = color)
      ..drawCircle(const Offset(80, 62), 3.2, Paint()..color = const Color(0xFF120E0D))
      ..drawRect(const Rect.fromLTWH(78.5, 64, 3, 9), Paint()..color = const Color(0xFF120E0D));
    if (withPlate) {
      final plate = box(38, 96, 84, 22, 6);
      canvas
        ..drawRRect(plate, Paint()..color = const Color(0xFF120E0D))
        ..drawRRect(plate, stroke..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(_ChestPainter oldDelegate) => oldDelegate.color != color || oldDelegate.withPlate != withPlate;
}
