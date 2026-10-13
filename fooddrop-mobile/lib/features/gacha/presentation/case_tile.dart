import 'package:flutter/material.dart';

import '../../../app/food_drop_colors.dart';
import '../domain/gacha_case.dart';
import 'chest_icon.dart';
import 'gacha_case_style.dart';
import 'rarity_segments.dart';

/// One case in the picker grid; glows in its colour when selected.
class CaseTile extends StatelessWidget {
  const CaseTile({super.key, required this.summary, required this.selected, required this.onTap});

  final GachaCaseSummary summary;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = GachaCaseStyle.of(summary.id);

    return Semantics(
      button: true,
      selected: selected,
      label: '${style.name}, ${summary.recipeCount} công thức',
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: selected ? style.color : colors.border, width: selected ? 1.5 : 1),
        ),
        shadowColor: style.color,
        elevation: selected ? 10 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              children: [
                SizedBox(height: 96, child: Center(child: ChestIcon(color: style.color, tag: style.tag))),
                const SizedBox(height: 4),
                Text(style.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  '${summary.recipeCount} công thức',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: style.color, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 8),
                RaritySegments(counts: summary.rarityCounts),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
