import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/labeled_dropdown.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../data/recipe_providers.dart';
import '../../domain/recipe_draft.dart';
import '../../domain/recipe_unit.dart';
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
    final adding = ref.watch(provider.select((s) => s.addingIngredients));
    final addError = ref.watch(provider.select((s) => s.ingredientError));
    final unresolved = rows.where((row) => row.ingredientId.isEmpty && row.name.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (unresolved.isNotEmpty)
          _UnresolvedBanner(
            names: [for (final row in unresolved) row.name.trim()],
            adding: adding,
            error: addError,
            onAdd: ref.read(provider.notifier).addUnresolvedIngredientsToCatalog,
          ),
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
    final units = ref.watch(unitsProvider).value ?? const <RecipeUnit>[];
    // The catalog may not have synced yet; keep a saved unit selectable so the dropdown never loses it.
    final known = units.any((unit) => unit.code == row.unitCode);

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
                  label: 'Số lượng (tùy chọn)',
                  initialValue: row.quantityText,
                  hint: '1 1/2',
                  keyboardType: TextInputType.text,
                  onChanged: (value) => controller.updateIngredient(row.uid, quantity: value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabeledDropdown<String>(
                  key: ValueKey('unit-${row.uid}'),
                  label: 'Đơn vị (tùy chọn)',
                  value: row.unitCode,
                  items: [
                    const DropdownMenuItem(value: '', child: Text('Không có')),
                    for (final unit in units) DropdownMenuItem(value: unit.code, child: Text(unit.label)),
                    if (!known && row.unitCode.isNotEmpty) DropdownMenuItem(value: row.unitCode, child: Text(row.unitCode)),
                  ],
                  onChanged: (value) => controller.updateIngredient(row.uid, unitCode: value),
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

/// Imported ingredients that are not in the shared catalog yet; one tap adds them all.
class _UnresolvedBanner extends StatelessWidget {
  const _UnresolvedBanner({required this.names, required this.adding, required this.error, required this.onAdd});

  final List<String> names;
  final bool adding;
  final String? error;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${names.length} nguyên liệu chưa có trong danh mục: ${names.join(', ')}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          NeonButton(
            label: 'Thêm ${names.length} nguyên liệu mới vào danh mục',
            style: NeonButtonStyle.outline,
            height: 48,
            loading: adding,
            onPressed: onAdd,
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
