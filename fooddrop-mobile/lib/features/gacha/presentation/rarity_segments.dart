import 'package:flutter/material.dart';

import '../../../app/food_drop_colors.dart';
import '../../recipes/domain/rarity.dart';

/// A case's rarity mix as one bar, one segment per tier sized by its count. Decorative; the count is in text nearby.
class RaritySegments extends StatelessWidget {
  const RaritySegments({super.key, required this.counts, this.height = 5});

  final Map<Rarity, int> counts;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tiers = Rarity.values.where((rarity) => (counts[rarity] ?? 0) > 0).toList();
    Widget segment(Color color, int flex) => Expanded(
          flex: flex,
          child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height))),
        );

    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: Row(
          spacing: 2,
          children: tiers.isEmpty
              ? [segment(colors.border, 1)]
              : [for (final rarity in tiers) segment(colors.rarity(rarity), counts[rarity]!)],
        ),
      ),
    );
  }
}
