import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../domain/recipe_draft.dart';
import 'recipe_form_controller.dart';

class RecipeFormSteps extends ConsumerWidget {
  const RecipeFormSteps({super.key, required this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = recipeFormControllerProvider(recipeId);
    final steps = ref.watch(provider.select((s) => s.draft.steps));
    final errors = ref.watch(provider.select((s) => s.errors));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, step) in steps.indexed)
          _StepRow(
            key: ValueKey(step.uid),
            index: index,
            step: step,
            isFirst: index == 0,
            isLast: index == steps.length - 1,
            error: errors?.stepRows[index],
            recipeId: recipeId,
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

class _StepRow extends ConsumerWidget {
  const _StepRow({
    super.key,
    required this.index,
    required this.step,
    required this.isFirst,
    required this.isLast,
    required this.error,
    required this.recipeId,
  });

  final int index;
  final DraftStep step;
  final bool isFirst;
  final bool isLast;
  final String? error;
  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final controller = ref.read(recipeFormControllerProvider(recipeId).notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: error == null ? colors.border : colors.danger),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.accent)),
                child: Text('${index + 1}', style: monoStyle()),
              ),
              const Spacer(),
              _IconAction(
                tooltip: 'Chuyển bước ${index + 1} lên',
                icon: Icons.arrow_upward_rounded,
                onPressed: isFirst ? null : () => controller.moveStep(step.uid, -1),
              ),
              _IconAction(
                tooltip: 'Chuyển bước ${index + 1} xuống',
                icon: Icons.arrow_downward_rounded,
                onPressed: isLast ? null : () => controller.moveStep(step.uid, 1),
              ),
              _IconAction(
                tooltip: 'Xóa bước ${index + 1}',
                icon: Icons.close_rounded,
                onPressed: () => controller.removeStep(step.uid),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LabeledTextField(
            fieldKey: ValueKey('step-text-${step.uid}'),
            label: 'Mô tả bước',
            initialValue: step.text,
            maxLines: 3,
            errorText: error,
            onChanged: (value) => controller.updateStepText(step.uid, value),
          ),
          const SizedBox(height: 12),
          LabeledTextField(
            label: 'Hẹn giờ (phút, tùy chọn)',
            initialValue: step.timerMinutes?.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => controller.updateStepTimer(step.uid, value),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.tooltip, required this.icon, required this.onPressed});

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: onPressed == null ? context.colors.border : context.colors.textMuted),
      );
}
