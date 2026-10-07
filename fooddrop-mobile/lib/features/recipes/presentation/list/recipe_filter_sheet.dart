import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../data/recipe_providers.dart';
import '../../domain/recipe_filters.dart';
import 'recipe_filters_controller.dart';

Future<void> showRecipeFilterSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const RecipeFilterSheet(),
    );

/// Tags grouped by dimension plus a max-time filter. Changes apply to the list immediately.
class RecipeFilterSheet extends ConsumerWidget {
  const RecipeFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final filters = ref.watch(recipeFiltersControllerProvider);
    final controller = ref.read(recipeFiltersControllerProvider.notifier);
    final groups = ref.watch(tagGroupsProvider).value ?? const [];

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              shrinkWrap: true,
              children: [
                const Text('Bộ lọc', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.22)),
                const SizedBox(height: 20),
                _SectionTitle('Thời gian nấu'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PillChip(
                      label: 'Tất cả',
                      selected: filters.maxMinutes == null,
                      filledWhenSelected: true,
                      onTap: () => controller.setMaxMinutes(null),
                    ),
                    for (final minutes in maxMinutesOptions)
                      PillChip(
                        label: '≤ $minutes phút',
                        selected: filters.maxMinutes == minutes,
                        filledWhenSelected: true,
                        onTap: () => controller.setMaxMinutes(minutes),
                      ),
                  ],
                ),
                for (final group in groups) ...[
                  const SizedBox(height: 22),
                  _SectionTitle(group.label),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in group.tags)
                        PillChip(
                          label: tag.label,
                          selected: filters.tagIds.contains(tag.id),
                          filledWhenSelected: true,
                          onTap: () => controller.toggleTag(tag.id),
                        ),
                    ],
                  ),
                ],
                if (groups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Text(
                      'Chưa tải được thẻ. Kết nối mạng một lần để lấy danh sách thẻ.',
                      style: TextStyle(fontSize: 14, color: colors.textMuted),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 16 + MediaQuery.paddingOf(context).bottom),
            child: Row(
              children: [
                Expanded(
                  child: NeonButton(
                    label: 'Xóa lọc',
                    style: NeonButtonStyle.outline,
                    onPressed: filters.sheetFilterCount == 0 ? null : controller.clearSheetFilters,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: NeonButton(label: 'Xong', onPressed: () => Navigator.of(context).pop())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: context.colors.textMuted),
        ),
      );
}
