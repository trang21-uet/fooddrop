import 'package:flutter/material.dart';

import '../../app/food_drop_colors.dart';

/// Bold label above a rounded filled dropdown (52px), matching [LabeledTextField].
class LabeledDropdown<T> extends StatelessWidget {
  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    OutlineInputBorder border(Color color) =>
        OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: color));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          isExpanded: true,
          onChanged: (next) {
            if (next is T) onChanged(next);
          },
          style: TextStyle(fontSize: 16, color: colors.text),
          dropdownColor: colors.surfaceRaised,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(minHeight: 52),
            enabledBorder: border(colors.border),
            focusedBorder: border(colors.accent),
          ),
        ),
      ],
    );
  }
}
