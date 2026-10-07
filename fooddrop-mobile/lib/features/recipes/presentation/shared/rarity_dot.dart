import 'package:flutter/material.dart';

import '../../../../app/food_drop_colors.dart';
import '../../domain/rarity.dart';

/// Small colored dot with the rarity name, as on list cards.
class RarityLabel extends StatelessWidget {
  const RarityLabel({super.key, required this.rarity});

  final Rarity rarity;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.rarity(rarity);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(rarity.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

/// Glowing pill used on the detail screen.
class RarityBadge extends StatelessWidget {
  const RarityBadge({super.key, required this.rarity});

  final Rarity rarity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = colors.rarity(rarity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: ShapeDecoration(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: color.withValues(alpha: 0.5))),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 10)]),
          ),
          const SizedBox(width: 8),
          Text(rarity.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
