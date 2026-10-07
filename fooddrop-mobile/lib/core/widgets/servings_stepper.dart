import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../app/food_drop_colors.dart';

const minServings = 1;
const maxServings = 50;

/// − 4 + control for portion counts. Both buttons are 44px touch targets.
class ServingsStepper extends StatelessWidget {
  const ServingsStepper({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget button(IconData icon, String tooltip, int? target) => Tooltip(
          message: tooltip,
          child: SizedBox.square(
            dimension: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: IconButton(
                onPressed: target == null ? null : () => onChanged(target),
                icon: Icon(icon, size: 20, color: target == null ? colors.textMuted : colors.text),
              ),
            ),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(Icons.remove_rounded, 'Giảm khẩu phần', value > minServings ? value - 1 : null),
        Semantics(
          label: 'Khẩu phần',
          value: '$value',
          child: SizedBox(
            width: 44,
            child: Text('$value', textAlign: TextAlign.center, style: monoStyle(size: 18, color: colors.text)),
          ),
        ),
        button(Icons.add_rounded, 'Tăng khẩu phần', value < maxServings ? value + 1 : null),
      ],
    );
  }
}
