import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/overlay_back_button.dart';

/// Banner image fading into the page background, optionally with a back button.
class AuthHeroHeader extends StatelessWidget {
  const AuthHeroHeader({super.key, required this.height, this.backLabel});

  final double height;

  /// Accessible label for the back button; null hides it.
  final String? backLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/auth-hero.jpg', fit: BoxFit.cover, cacheWidth: 1000, excludeFromSemantics: true),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.background.withValues(alpha: 0.6),
                  colors.background.withValues(alpha: 0),
                  colors.background.withValues(alpha: 0.2),
                  colors.background,
                ],
                stops: const [0, 0.3, 0.6, 1],
              ),
            ),
          ),
          if (backLabel != null)
            Positioned(
              left: 16,
              top: MediaQuery.paddingOf(context).top + 8,
              child: OverlayBackButton(label: backLabel!, onPressed: () => context.pop()),
            ),
        ],
      ),
    );
  }
}

class AuthFormError extends StatelessWidget {
  const AuthFormError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Semantics(
          liveRegion: true,
          child: Text(message, style: TextStyle(fontSize: 13, color: context.colors.danger)),
        ),
      );
}

class AuthSwitchRow extends StatelessWidget {
  const AuthSwitchRow({super.key, required this.question, required this.action, required this.onTap});

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: TextStyle(fontSize: 14, color: colors.textMuted)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(minimumSize: const Size(44, 44), foregroundColor: colors.accent),
          child: Text(action, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
