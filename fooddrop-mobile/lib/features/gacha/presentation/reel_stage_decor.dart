import 'package:flutter/material.dart';

/// Everything drawn over the reel strip: edge fades and the CS2-style marker, a thin line across the
/// stage; the card under it is the result. Static, so it never repaints during a spin.
class ReelStageDecor extends StatelessWidget {
  const ReelStageDecor({super.key, required this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          alignment: Alignment.center,
          children: [
            for (final left in [true, false])
              Positioned(
                top: 0,
                bottom: 0,
                left: left ? 0 : null,
                right: left ? null : 0,
                width: constraints.maxWidth * 0.18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: left ? Alignment.centerLeft : Alignment.centerRight,
                      end: left ? Alignment.centerRight : Alignment.centerLeft,
                      colors: [background, background.withValues(alpha: 0)],
                      stops: const [0.06, 1],
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFC233), Color(0xFFFF8A1F), Color(0xFFFF3B30)],
                  ),
                  boxShadow: [BoxShadow(color: Color(0xAAFF8A1F), blurRadius: 10)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
