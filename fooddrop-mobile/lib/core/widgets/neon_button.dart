import 'package:flutter/material.dart';

import '../../app/food_drop_colors.dart';

enum NeonButtonStyle { primary, outline, danger }

/// Pill-cornered action button from the design board: orange primary with glow, bordered
/// secondary, red-outlined destructive. Always at least 44px tall.
class NeonButton extends StatelessWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = NeonButtonStyle.primary,
    this.icon,
    this.loading = false,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final NeonButtonStyle style;
  final IconData? icon;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPrimary = style == NeonButtonStyle.primary;
    final foreground = switch (style) {
      NeonButtonStyle.primary => colors.background,
      NeonButtonStyle.outline => colors.text,
      NeonButtonStyle.danger => colors.danger,
    };
    final enabled = onPressed != null && !loading;

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isPrimary ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isPrimary ? null : Border.all(color: style == NeonButtonStyle.danger ? colors.danger : colors.border),
          boxShadow: isPrimary ? colors.accentGlow : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? onPressed : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Center(
                child: loading
                    ? SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: foreground),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[Icon(icon, size: 20, color: foreground), const SizedBox(width: 8)],
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: foreground, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
