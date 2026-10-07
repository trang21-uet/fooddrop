import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/api/api_error.dart';
import '../../../../core/widgets/overlay_back_button.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../data/recipe_providers.dart';
import '../../domain/recipe.dart';
import '../shared/recipe_artwork.dart';
import 'recipe_detail_sections.dart';
import 'recipe_ingredients_section.dart';
import 'recipe_steps_section.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// Stale-while-revalidate: the cached copy shows immediately, a fresh one replaces it.
  Future<void> _refresh() async {
    try {
      await ref.read(recipeActionsProvider).refreshDetail(widget.recipeId);
    } catch (error) {
      // Offline is expected; the cached copy stays on screen.
      if (!isOffline(error)) debugPrint('Recipe detail refresh failed: $error');
    }
  }

  Future<void> _confirmDelete(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: const Text('Xóa công thức?'),
        content: Text('"${recipe.title}" sẽ bị xóa khỏi thư viện của bạn.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: context.colors.danger),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(recipeActionsProvider).delete(recipe.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = ref.watch(recipeProvider(widget.recipeId));
    final groups = ref.watch(tagGroupsProvider).value ?? const <TagGroup>[];

    return Scaffold(
      body: recipe.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _NotFound(message: describeApiError(error)),
        data: (recipe) {
          if (recipe == null) return const _NotFound(message: 'Công thức này không còn nữa.');
          final tags = [
            for (final group in groups)
              for (final tag in group.tags)
                if (recipe.tagIds.contains(tag.id)) tag,
          ];
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _Hero(recipe: recipe),
                    RecipeSummarySection(recipe: recipe, tags: tags),
                    if (recipe.hasDetail) ...[
                      IngredientsSection(recipe: recipe),
                      StepsSection(recipeTitle: recipe.title, steps: recipe.steps!),
                    ] else
                      const _DetailPending(),
                  ],
                ),
              ),
              _BottomBar(
                onEdit: recipe.hasDetail ? () => context.push('/recipes/${recipe.id}/edit') : null,
                onDelete: () => _confirmDelete(recipe),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rarityColor = colors.rarity(recipe.rarity);
    return Container(
      height: 240 + MediaQuery.paddingOf(context).top,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: rarityColor.withValues(alpha: 0.5))),
        boxShadow: [BoxShadow(color: rarityColor.withValues(alpha: 0.7), blurRadius: 28, spreadRadius: -12, offset: const Offset(0, 8))],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeArtwork(recipe: recipe, iconSize: 96, borderRadius: BorderRadius.zero),
          Positioned(
            left: 16,
            top: MediaQuery.paddingOf(context).top + 16,
            child: OverlayBackButton(label: 'Quay lại danh sách công thức', onPressed: () => context.pop()),
          ),
        ],
      ),
    );
  }
}

/// Summary arrived but steps and ingredients have not been downloaded yet.
class _DetailPending extends StatelessWidget {
  const _DetailPending();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
        child: Text(
          'Đang tải cách làm. Nếu đang offline, hãy kết nối mạng một lần để lưu công thức này vào máy.',
          style: TextStyle(fontSize: 14, height: 1.5, color: context.colors.textMuted),
        ),
      );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onEdit, required this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(color: colors.surface, border: Border(top: BorderSide(color: colors.border))),
      child: Row(
        children: [
          Expanded(child: NeonButton(label: 'Sửa công thức', icon: Icons.edit_outlined, height: 52, onPressed: onEdit)),
          const SizedBox(width: 10),
          Tooltip(
            message: 'Xóa công thức',
            child: SizedBox.square(
              dimension: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: colors.danger)),
                child: IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline_rounded, color: colors.danger),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                NeonButton(label: 'Về danh sách', onPressed: () => context.go('/recipes')),
              ],
            ),
          ),
        ),
      );
}
