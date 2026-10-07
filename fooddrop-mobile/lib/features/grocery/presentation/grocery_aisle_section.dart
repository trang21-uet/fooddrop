import 'package:flutter/material.dart';

import '../../../app/food_drop_colors.dart';
import '../domain/grocery_aggregation.dart';

/// One aisle heading and its tick-off rows.
class GroceryAisleSection extends StatelessWidget {
  const GroceryAisleSection({super.key, required this.group, required this.checked, required this.onToggle});

  final GroceryAisleGroup group;
  final Set<String> checked;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (aisleLabels[group.aisle] ?? group.aisle).toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.9, color: colors.textMuted),
          ),
          const SizedBox(height: 8),
          // A Material (not a decorated Container) so the tiles' ink splashes stay visible.
          Material(
            color: colors.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: colors.border)),
            child: Column(
              children: [
                for (final item in group.items)
                  CheckboxListTile(
                    key: ValueKey(item.key),
                    value: checked.contains(item.key),
                    onChanged: (_) => onToggle(item.key),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: colors.accent,
                    checkColor: colors.background,
                    title: Text(
                      item.line,
                      style: TextStyle(
                        fontSize: 15,
                        color: checked.contains(item.key) ? colors.textMuted : colors.text,
                        decoration: checked.contains(item.key) ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
