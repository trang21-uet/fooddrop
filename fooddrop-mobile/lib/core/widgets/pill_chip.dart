import 'package:flutter/material.dart';

import '../../app/food_drop_colors.dart';

/// Selectable pill (tags, rarity filter, difficulty). [color] tints the selected border and dot.
class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
    this.showDot = false,
    this.filledWhenSelected = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;
  final bool showDot;

  /// Solid accent fill when selected (tag pickers) instead of a raised surface (rarity row).
  final bool filledWhenSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = color ?? colors.accent;
    final filled = selected && filledWhenSelected;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: filled ? tint : (selected ? colors.surfaceRaised : Colors.transparent),
        shape: StadiumBorder(side: BorderSide(color: selected ? tint : colors.border)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showDot) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tint,
                        boxShadow: [BoxShadow(color: tint, blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: filled ? colors.background : (selected ? colors.text : colors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
