import 'package:flutter/material.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/servings_stepper.dart';

/// A recipe on the grocery list with its servings stepper and a remove button.
class GrocerySelectionTile extends StatelessWidget {
  const GrocerySelectionTile({
    super.key,
    required this.title,
    required this.servings,
    required this.onServings,
    required this.onRemove,
    this.onOpen,
  });

  final String title;
  final int servings;
  final ValueChanged<int> onServings;
  final VoidCallback onRemove;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
          ServingsStepper(value: servings.clamp(minServings, maxServings), onChanged: onServings),
          IconButton(
            tooltip: 'Bỏ $title khỏi danh sách',
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            onPressed: onRemove,
            icon: Icon(Icons.close_rounded, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
