import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../domain/recipe_draft.dart';
import 'ingredient_picker_sheet.dart';
import 'recipe_form_controller.dart';

class RecipeFormIngredients extends ConsumerWidget {
  const RecipeFormIngredients({super.key, required this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = recipeFormControllerProvider(recipeId);
    final rows = ref.watch(provider.select((s) => s.draft.ingredients));
    final rowErrors = ref.watch(provider.select((s) => s.errors?.ingredientRows)) ?? const {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, row) in rows.indexed)
          _IngredientRow(
            key: ValueKey(row.uid),
            row: row,
            error: rowErrors[index],
            recipeId: recipeId,
          ),
        const SizedBox(height: 4),
        NeonButton(
          label: 'Thêm nguyên liệu',
          icon: Icons.add_rounded,
          style: NeonButtonStyle.outline,
          height: 48,
          onPressed: () async {
            final option = await showIngredientPicker(context);
            if (option != null) ref.read(provider.notifier).addIngredient(option);
          },
        ),
      ],
    );
  }
}

class _IngredientRow extends ConsumerWidget {
  const _IngredientRow({super.key, required this.row, required this.error, required this.recipeId});

  final DraftIngredient row;
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
              Expanded(child: Text(row.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              IconButton(
                tooltip: 'Xóa ${row.name}',
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
                onPressed: () => controller.removeIngredient(row.uid),
                icon: Icon(Icons.close_rounded, color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledTextField(
                  label: 'Số lượng',
                  initialValue: row.quantityText,
                  hint: '1 1/2',
                  keyboardType: TextInputType.text,
                  onChanged: (value) => controller.updateIngredient(row.uid, quantity: value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabeledTextField(
                  label: 'Đơn vị',
                  initialValue: row.unitText,
                  hint: 'g, ml, thìa…',
                  onChanged: (value) => controller.updateIngredient(row.uid, unit: value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LabeledTextField(
            label: 'Ghi chú (tùy chọn)',
            initialValue: row.note,
            hint: 'thái nhỏ',
            onChanged: (value) => controller.updateIngredient(row.uid, note: value),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(error!, style: TextStyle(fontSize: 13, color: colors.danger)),
            ),
        ],
      ),
    );
  }
}
