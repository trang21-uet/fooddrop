import 'package:flutter/material.dart';

import '../features/recipes/domain/rarity.dart';

/// Design tokens from the "Giao diện Food Drop" board (same values as web `globals.css`).
@immutable
class FoodDropColors extends ThemeExtension<FoodDropColors> {
  const FoodDropColors({
    this.background = const Color(0xFF120E0D),
    this.surface = const Color(0xFF1C1614),
    this.surfaceRaised = const Color(0xFF261E1B),
    this.border = const Color(0xFF3A2D28),
    this.text = const Color(0xFFF4ECE8),
    this.textMuted = const Color(0xFFA8998F),
    this.accent = const Color(0xFFFF8A1F),
    this.accentHot = const Color(0xFFFF3B30),
    this.danger = const Color(0xFFFF5D52),
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color accent;
  final Color accentHot;
  final Color danger;

  Color rarity(Rarity rarity) => switch (rarity) {
        Rarity.white => const Color(0xFFD9D4D0),
        Rarity.blue => const Color(0xFF4B9BFF),
        Rarity.purple => const Color(0xFFA56BFF),
        Rarity.pink => const Color(0xFFFF5FC4),
        Rarity.red => const Color(0xFFFF3B30),
      };

  /// Soft outer glow used on rarity-bordered cards.
  List<BoxShadow> glow(Color color, {double opacity = 0.67, double blur = 14}) => [
        BoxShadow(color: color.withValues(alpha: opacity), blurRadius: blur, spreadRadius: -6),
      ];

  /// Neon glow under primary buttons.
  List<BoxShadow> get accentGlow => [
        BoxShadow(color: accent.withValues(alpha: 0.7), blurRadius: 24, spreadRadius: -4),
      ];

  @override
  FoodDropColors copyWith() => this;

  @override
  FoodDropColors lerp(ThemeExtension<FoodDropColors>? other, double t) => this;
}

extension FoodDropColorsContext on BuildContext {
  FoodDropColors get colors => Theme.of(this).extension<FoodDropColors>()!;
}
