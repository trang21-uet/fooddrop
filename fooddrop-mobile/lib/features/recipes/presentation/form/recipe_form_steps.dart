import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/neon_button.dart';
import 'recipe_form_controller.dart';
import 'recipe_form_step_card.dart';

class RecipeFormSteps extends ConsumerWidget {
  const RecipeFormSteps({super.key, required this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = recipeFormControllerProvider(recipeId);
    final steps = ref.watch(provider.select((s) => s.draft.steps));
    final errors = ref.watch(provider.select((s) => s.errors));
    final imageError = ref.watch(provider.select((s) => s.imageError));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, step) in steps.indexed)
          RecipeFormStepCard(
            key: ValueKey(step.uid),
            index: index,
            step: step,
            isFirst: index == 0,
            isLast: index == steps.length - 1,
            error: errors?.stepRows[index],
            recipeId: recipeId,
          ),
        if (imageError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(imageError, key: const Key('step-image-error'), style: TextStyle(fontSize: 13, color: context.colors.danger)),
          ),
        if (errors?.steps != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(errors!.steps!, style: TextStyle(fontSize: 13, color: context.colors.danger)),
          ),
        NeonButton(
          label: 'Thêm bước',
          icon: Icons.add_rounded,
          style: NeonButtonStyle.outline,
          height: 48,
          onPressed: ref.read(provider.notifier).addStep,
        ),
      ],
    );
  }
}
