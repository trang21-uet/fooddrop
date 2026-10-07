import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../data/recipe_providers.dart';
import 'recipe_form_controller.dart';

/// Title, description, time, servings and difficulty.
class RecipeFormBasics extends ConsumerWidget {
  const RecipeFormBasics({super.key, required this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = recipeFormControllerProvider(recipeId);
    final controller = ref.read(provider.notifier);
    final initial = ref.read(provider).draft;
    final errors = ref.watch(provider.select((s) => s.errors));
    final difficulty = ref.watch(provider.select((s) => s.draft.difficulty));
    final digits = [FilteringTextInputFormatter.digitsOnly];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextField(
          fieldKey: const ValueKey('recipe-title'),
          label: 'Tên món',
          initialValue: initial.title,
          hint: 'Phở bò',
          errorText: errors?.title,
          onChanged: controller.setTitle,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        LabeledTextField(
          label: 'Mô tả (tùy chọn)',
          initialValue: initial.description,
          maxLines: 3,
          onChanged: controller.setDescription,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledTextField(
                fieldKey: const ValueKey('recipe-minutes'),
                label: 'Tổng thời gian (phút)',
                initialValue: '${initial.totalMinutes}',
                keyboardType: TextInputType.number,
                inputFormatters: digits,
                errorText: errors?.totalMinutes,
                onChanged: controller.setTotalMinutes,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledTextField(
                fieldKey: const ValueKey('recipe-servings'),
                label: 'Khẩu phần',
                initialValue: '${initial.baseServings}',
                keyboardType: TextInputType.number,
                inputFormatters: digits,
                errorText: errors?.baseServings,
                onChanged: controller.setServings,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Độ khó', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (var level = 1; level <= 5; level++)
              PillChip(
                label: '$level',
                selected: difficulty == level,
                filledWhenSelected: true,
                onTap: () => controller.setDifficulty(level),
              ),
          ],
        ),
      ],
    );
  }
}

/// Tag chips grouped by dimension.
class RecipeFormTags extends ConsumerWidget {
  const RecipeFormTags({super.key, required this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = recipeFormControllerProvider(recipeId);
    final selected = ref.watch(provider.select((s) => s.draft.tagIds));
    final groups = ref.watch(tagGroupsProvider).value ?? const [];
    if (groups.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              group.label.toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: context.colors.textMuted),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in group.tags)
                PillChip(
                  label: tag.label,
                  selected: selected.contains(tag.id),
                  filledWhenSelected: true,
                  onTap: () => ref.read(provider.notifier).toggleTag(tag.id),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
