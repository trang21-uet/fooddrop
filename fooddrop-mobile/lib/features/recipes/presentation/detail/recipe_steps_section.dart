import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../domain/recipe.dart';
import 'recipe_step_extras.dart';

class StepsSection extends StatelessWidget {
  const StepsSection({super.key, required this.recipeTitle, required this.steps});

  final String recipeTitle;
  final List<RecipeStep> steps;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cách làm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final (index, step) in steps.indexed)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.accent)),
                    child: Text('${index + 1}', style: monoStyle()),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: _StepBody(step: step, number: index + 1, recipeTitle: recipeTitle)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Title, text, photos, note, timer: the design's order, 10 px apart.
class _StepBody extends StatelessWidget {
  const _StepBody({required this.step, required this.number, required this.recipeTitle});

  final RecipeStep step;
  final int number;
  final String recipeTitle;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (step.name != null)
        Text(step.name!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.16)),
      Text(step.text, style: const TextStyle(fontSize: 14, height: 1.55)),
      if (step.images.isNotEmpty) StepPhotoStrip(images: step.images, stepNumber: number),
      if (step.note != null) StepNoteBox(note: step.note!),
      if (step.timerSeconds != null)
        StartStepTimerChip(seconds: step.timerSeconds!, label: step.timerLabel ?? '$recipeTitle · bước $number'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const SizedBox(height: 10),
          child,
        ],
      ],
    );
  }
}
