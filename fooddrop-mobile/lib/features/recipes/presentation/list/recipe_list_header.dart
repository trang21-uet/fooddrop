import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../domain/rarity.dart';
import 'recipe_filter_sheet.dart';
import 'recipe_filters_controller.dart';

/// Logo, title and the avatar that opens the account sheet.
class RecipeListHeader extends ConsumerWidget {
  const RecipeListHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final session = ref.watch(authControllerProvider).value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              'assets/icon/app-icon-foreground.png',
              width: 36,
              height: 36,
              cacheWidth: 108,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Công thức', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.84)),
          ),
          IconButton(
            tooltip: 'Nhập công thức từ liên kết hoặc ảnh (đang phát triển)',
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            onPressed: () => context.push('/recipes/import'),
            icon: Icon(Icons.auto_awesome_outlined, color: colors.accent),
          ),
          const SizedBox(width: 4),
          Semantics(
            button: true,
            label: 'Tài khoản${session == null ? '' : ': ${session.name}'}',
            child: Material(
              color: colors.surfaceRaised,
              shape: CircleBorder(side: BorderSide(color: colors.border)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _showAccountSheet(context),
                child: SizedBox.square(
                  dimension: 44,
                  child: Center(
                    child: Text(
                      session?.initials ?? '?',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.accent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAccountSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _AccountSheet(),
    );

class _AccountSheet extends ConsumerWidget {
  const _AccountSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final session = ref.watch(authControllerProvider).value;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session?.name ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(session?.email ?? '', style: TextStyle(fontSize: 14, color: colors.textMuted)),
          const SizedBox(height: 20),
          NeonButton(
            label: 'Đăng xuất',
            style: NeonButtonStyle.danger,
            icon: Icons.logout_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}

/// Search field plus the filter-sheet button (badge shows how many sheet filters are on).
class RecipeSearchBar extends ConsumerWidget {
  const RecipeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final count = ref.watch(recipeFiltersControllerProvider.select((f) => f.sheetFilterCount));
    OutlineInputBorder border(Color color) =>
        OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: color));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: ref.read(recipeFiltersControllerProvider.notifier).setQuery,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm công thức hoặc nguyên liệu',
                hintStyle: TextStyle(color: colors.textMuted, fontSize: 15),
                prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted, size: 20),
                filled: true,
                fillColor: colors.surface,
                constraints: const BoxConstraints(minHeight: 48),
                contentPadding: EdgeInsets.zero,
                enabledBorder: border(colors.border),
                focusedBorder: border(colors.accent),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Semantics(
            button: true,
            label: count == 0 ? 'Mở bộ lọc' : 'Mở bộ lọc, đang bật $count',
            child: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              backgroundColor: colors.accent,
              textColor: colors.background,
              child: Material(
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: count > 0 ? colors.accent : colors.border),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => showRecipeFilterSheet(context),
                  child: SizedBox.square(dimension: 48, child: Icon(Icons.tune_rounded, color: colors.text)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RarityFilterRow extends ConsumerWidget {
  const RarityFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selected = ref.watch(recipeFiltersControllerProvider.select((f) => f.rarity));
    final controller = ref.read(recipeFiltersControllerProvider.notifier);

    return SizedBox(
      height: 68,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          PillChip(label: 'Tất cả', selected: selected == null, showDot: true, onTap: () => controller.setRarity(null)),
          for (final rarity in Rarity.values) ...[
            const SizedBox(width: 8),
            PillChip(
              label: rarity.label,
              selected: selected == rarity,
              color: colors.rarity(rarity),
              showDot: true,
              onTap: () => controller.setRarity(rarity),
            ),
          ],
        ],
      ),
    );
  }
}
