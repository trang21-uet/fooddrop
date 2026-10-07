import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/food_drop_colors.dart';
import '../../data/recipe_providers.dart';
import '../../data/sync_controller.dart';
import 'recipe_card.dart';
import 'recipe_filters_controller.dart';
import 'recipe_list_header.dart';

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    ref.listen(syncControllerProvider, (previous, next) {
      if (next.rejectedChanges > 0 && previous?.rejectedChanges != next.rejectedChanges) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Máy chủ từ chối một số thay đổi nên đã khôi phục bản gốc.')),
        );
      }
    });

    return Scaffold(
      floatingActionButton: _AddRecipeButton(onPressed: () => context.push('/recipes/new')),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const RecipeListHeader(),
            const RecipeSearchBar(),
            const RarityFilterRow(),
            const _SyncBanner(),
            Expanded(
              child: RefreshIndicator(
                color: colors.accent,
                backgroundColor: colors.surfaceRaised,
                onRefresh: ref.read(syncControllerProvider.notifier).sync,
                child: const _RecipeList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeList extends ConsumerWidget {
  const _RecipeList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(recipesProvider);
    final recipes = ref.watch(filteredRecipesProvider);
    final filtersActive = ref.watch(recipeFiltersControllerProvider.select((f) => f.isActive));
    final syncing = ref.watch(syncControllerProvider.select((s) => s.phase == SyncPhase.syncing));

    if (!all.hasValue || (all.requireValue.isEmpty && syncing)) {
      return const _Centered(child: CircularProgressIndicator());
    }
    if (recipes.isEmpty) {
      return filtersActive
          ? _EmptyState(
              title: 'Không có công thức khớp',
              message: 'Thử bỏ bớt bộ lọc hoặc đổi từ khóa.',
              actionLabel: 'Xóa bộ lọc',
              onAction: ref.read(recipeFiltersControllerProvider.notifier).clear,
            )
          : const _EmptyState(
              title: 'Chưa có công thức nào',
              message: 'Bấm nút + để thêm món đầu tiên của bạn.',
            );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
      itemCount: recipes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(recipe: recipe, onTap: () => context.push('/recipes/${recipe.id}'));
      },
    );
  }
}

/// Slim notice that the list is showing the copy stored on the phone.
class _SyncBanner extends ConsumerWidget {
  const _SyncBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(syncControllerProvider.select((s) => s.phase));
    final message = switch (phase) {
      SyncPhase.offline => 'Đang offline. Hiển thị bản lưu trên máy, thay đổi sẽ đồng bộ khi có mạng.',
      SyncPhase.failed => 'Không đồng bộ được. Kéo xuống để thử lại.',
      _ => null,
    };
    if (message == null) return const SizedBox.shrink();
    final colors = context.colors;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 18, color: colors.textMuted),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(fontSize: 13, color: colors.textMuted))),
        ],
      ),
    );
  }
}

class _AddRecipeButton extends StatelessWidget {
  const _AddRecipeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: 'Thêm công thức',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.accent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: colors.accent.withValues(alpha: 0.7), blurRadius: 22, spreadRadius: -2)],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onPressed,
            child: SizedBox.square(dimension: 56, child: Icon(Icons.add_rounded, size: 30, color: colors.background)),
          ),
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: constraints.maxHeight, child: Center(child: child)),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message, this.actionLabel, this.onAction});

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _Centered(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.ramen_dining_outlined, size: 48, color: colors.textMuted),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: colors.textMuted)),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(minimumSize: const Size(44, 44), foregroundColor: colors.accent),
                child: Text(actionLabel!, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }
}
