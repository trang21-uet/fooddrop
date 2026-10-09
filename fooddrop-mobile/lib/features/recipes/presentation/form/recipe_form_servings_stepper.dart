import 'package:flutter/material.dart';

import '../../../../app/food_drop_colors.dart';

const _maxBaseServings = 100;

/// Labelled "− 2 +" box for a recipe's base servings, as tall as the text fields beside it.
class RecipeFormServingsStepper extends StatelessWidget {
  const RecipeFormServingsStepper({super.key, required this.value, required this.onChanged, this.errorText});

  final int value;
  final ValueChanged<int> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget button(IconData icon, String tooltip, int? target, Color color) => IconButton(
          tooltip: tooltip,
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
          onPressed: target == null ? null : () => onChanged(target),
          icon: Icon(icon, size: 22, color: target == null ? colors.border : color),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Khẩu phần', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: errorText == null ? colors.border : colors.danger),
          ),
          child: Row(
            children: [
              button(Icons.remove_rounded, 'Giảm khẩu phần', value > 1 ? value - 1 : null, colors.text),
              Expanded(
                child: Semantics(
                  label: 'Khẩu phần',
                  value: '$value',
                  excludeSemantics: true,
                  child: Text(
                    '$value người',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              button(Icons.add_rounded, 'Tăng khẩu phần', value < _maxBaseServings ? value + 1 : null, colors.accent),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(errorText!, style: TextStyle(fontSize: 13, color: colors.danger)),
          ),
      ],
    );
  }
}
