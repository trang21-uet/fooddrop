import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';

const _difficultyLabels = ['Rất dễ', 'Dễ', 'Vừa', 'Khó', 'Rất khó'];

/// Labelled 1–5 difficulty slider in a box, with "3 · Vừa" beside the track.
class RecipeFormDifficultySlider extends StatelessWidget {
  const RecipeFormDifficultySlider({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = _difficultyLabels[value - 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Độ khó', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 4, right: 16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 8,
                    activeTrackColor: colors.accent,
                    inactiveTrackColor: colors.border,
                    thumbColor: colors.accent,
                    overlayColor: colors.accent.withValues(alpha: 0.16),
                    trackShape: const RoundedRectSliderTrackShape(),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11, elevation: 0, pressedElevation: 0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Slider(
                    key: const ValueKey('recipe-difficulty'),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: value.toDouble(),
                    semanticFormatterCallback: (_) => '$value · $label',
                    onChanged: (next) => onChanged(next.round()),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$value', style: monoStyle(size: 15, weight: FontWeight.w700, color: colors.accent)),
                    TextSpan(text: ' · $label'),
                  ],
                ),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
