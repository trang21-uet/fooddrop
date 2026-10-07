import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../../../core/widgets/servings_stepper.dart';
import '../../../grocery/data/grocery_providers.dart';
import '../../domain/recipe.dart';

/// Ingredient list with a live servings stepper and "add to grocery list".
class IngredientsSection extends ConsumerStatefulWidget {
  const IngredientsSection({super.key, required this.recipe});

  final Recipe recipe;

  @override
  ConsumerState<IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends ConsumerState<IngredientsSection> {
  late int _servings = widget.recipe.baseServings;

  Future<void> _addToGrocery() async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    await ref.read(groceryActionsProvider).addRecipe(widget.recipe.id, _servings);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Đã thêm vào danh sách đi chợ'),
          action: SnackBarAction(label: 'Xem', onPressed: () => router.push('/grocery')),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final recipe = widget.recipe;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Nguyên liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
              ServingsStepper(value: _servings, onChanged: (value) => setState(() => _servings = value)),
            ],
          ),
          const SizedBox(height: 8),
          if (recipe.ingredients.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Chưa có nguyên liệu.', style: TextStyle(fontSize: 14, color: colors.textMuted)),
            ),
          for (final item in recipe.ingredients)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.border))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(width: 84, child: Text(item.scaledLabel(_servings, recipe.baseServings), style: monoStyle())),
                  Expanded(
                    child: Text(
                      item.note == null ? item.name : '${item.name} · ${item.note}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          if (recipe.ingredients.isNotEmpty) ...[
            const SizedBox(height: 14),
            NeonButton(
              label: 'Thêm vào đi chợ',
              icon: Icons.shopping_basket_outlined,
              style: NeonButtonStyle.outline,
              height: 48,
              onPressed: _addToGrocery,
            ),
          ],
        ],
      ),
    );
  }
}
