import 'package:flutter/material.dart';

import '../../../../app/food_drop_colors.dart';

/// "Thêm hẹn giờ" / "Có hẹn giờ" chip; filled accent while a timer is set.
class StepTimerToggle extends StatelessWidget {
  const StepTimerToggle({super.key, required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = on ? colors.background : colors.text;
    return Semantics(
      toggled: on,
      child: Material(
        color: on ? colors.accent : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: on ? colors.accent : colors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: foreground),
                  const SizedBox(width: 8),
                  Text(
                    on ? 'Có hẹn giờ' : 'Thêm hẹn giờ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: foreground),
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
