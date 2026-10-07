import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/neon_button.dart';
import '../../recipes/data/recipe_providers.dart';
import '../data/grocery_providers.dart';
import '../domain/grocery_aggregation.dart';
import 'grocery_aisle_section.dart';
import 'grocery_selection_tile.dart';

class GroceryScreen extends ConsumerWidget {
  const GroceryScreen({super.key});

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final text = groceryShareText(ref.read(groceryListProvider), ref.read(groceryCheckedProvider).value ?? const {});
    try {
      await ref.read(shareTextProvider)(text);
    } catch (error) {
      debugPrint('Share failed: $error');
      messenger.showSnackBar(const SnackBar(content: Text('Không chia sẻ được. Thử lại nhé.')));
    }
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final colors = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: const Text('Xóa danh sách đi chợ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: colors.danger),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true) await ref.read(groceryActionsProvider).clearAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selections = ref.watch(grocerySelectionsProvider).value ?? const <GrocerySelection>[];
    final groups = ref.watch(groceryListProvider);
    final checked = ref.watch(groceryCheckedProvider).value ?? const <String>{};
    final recipes = {for (final r in ref.watch(recipesProvider).value ?? const []) r.id: r};
    final actions = ref.read(groceryActionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/recipes')),
        title: const Text('Đi chợ', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          if (groups.isNotEmpty)
            IconButton(
              tooltip: 'Chia sẻ danh sách',
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              onPressed: () => _share(context, ref),
              icon: Icon(Icons.ios_share_rounded, color: colors.accent),
            ),
          if (selections.isNotEmpty)
            PopupMenuButton<String>(
              tooltip: 'Thêm tùy chọn',
              onSelected: (value) => value == 'uncheck' ? actions.uncheckAll() : _confirmClear(context, ref),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'uncheck', enabled: checked.isNotEmpty, child: const Text('Bỏ chọn hết')),
                const PopupMenuItem(value: 'clear', child: Text('Xóa danh sách')),
              ],
            ),
        ],
      ),
      body: selections.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_basket_outlined, size: 48, color: colors.textMuted),
                    const SizedBox(height: 16),
                    const Text('Chưa có món nào', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'Mở một công thức và chọn “Thêm vào đi chợ”.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: colors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    NeonButton(label: 'Xem công thức', onPressed: () => context.go('/recipes'), height: 48),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text('Gộp nguyên liệu từ ${selections.length} công thức', style: TextStyle(fontSize: 14, color: colors.textMuted)),
                const SizedBox(height: 16),
                for (final group in groups) GroceryAisleSection(group: group, checked: checked, onToggle: actions.toggleChecked),
                const SizedBox(height: 8),
                const Text('Món đã chọn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final selection in selections)
                  GrocerySelectionTile(
                    title: recipes[selection.recipeId]?.title ?? 'Công thức',
                    servings: selection.servings,
                    onServings: (value) => actions.setServings(selection.recipeId, value),
                    onRemove: () => actions.removeRecipe(selection.recipeId),
                    onOpen: recipes.containsKey(selection.recipeId) ? () => context.push('/recipes/${selection.recipeId}') : null,
                  ),
              ],
            ),
    );
  }
}
