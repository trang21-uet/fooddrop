import 'package:flutter/material.dart';

import '../../app/food_drop_colors.dart';

/// 44px rounded-square button floating over a hero image.
class OverlayBackButton extends StatelessWidget {
  const OverlayBackButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: colors.background.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: const SizedBox.square(dimension: 44, child: Icon(Icons.chevron_left_rounded, size: 28)),
        ),
      ),
    );
  }
}
