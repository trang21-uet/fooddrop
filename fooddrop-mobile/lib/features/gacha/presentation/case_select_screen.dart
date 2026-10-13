import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/api/api_error.dart';
import '../../../core/widgets/neon_button.dart';
import '../data/gacha_providers.dart';
import '../domain/gacha_case.dart';
import 'case_tile.dart';
import 'gacha_case_style.dart';
import 'rarity_segments.dart';

/// "Chọn hòm": pick a case, then open it on `/drop/:caseId`.
class CaseSelectScreen extends ConsumerStatefulWidget {
  const CaseSelectScreen({super.key});

  @override
  ConsumerState<CaseSelectScreen> createState() => _CaseSelectScreenState();
}

class _CaseSelectScreenState extends ConsumerState<CaseSelectScreen> {
  var _selected = GachaCaseId.all;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cases = ref.watch(gachaCasesProvider);
    final summary = cases.value?.where((item) => item.id == _selected).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn hòm')),
      body: Column(
        children: [
          Expanded(
            child: switch (cases) {
              AsyncData(:final value) => CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      sliver: SliverToBoxAdapter(
                        child: Text('Mỗi hòm chứa một nhóm món.', style: TextStyle(fontSize: 14, color: colors.textMuted)),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.86,
                        children: [
                          for (final item in value)
                            CaseTile(summary: item, selected: item.id == _selected, onTap: () => setState(() => _selected = item.id)),
                        ],
                      ),
                    ),
                  ],
                ),
              AsyncError(:final error) => _Message(
                  text: describeApiError(error),
                  onRetry: () => ref.invalidate(gachaCasesProvider),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
          if (summary != null) _SelectedCaseBar(summary: summary),
        ],
      ),
    );
  }
}

/// The selected case and the button that opens it, pinned above the bottom edge.
class _SelectedCaseBar extends StatelessWidget {
  const _SelectedCaseBar({required this.summary});

  final GachaCaseSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = GachaCaseStyle.of(summary.id);
    final empty = summary.recipeCount == 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: style.color)),
        boxShadow: [BoxShadow(color: style.color.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: -12, offset: const Offset(0, -10))],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + MediaQuery.paddingOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đã chọn', style: TextStyle(fontSize: 12, color: colors.textMuted)),
                      Text(style.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Text('${summary.recipeCount} công thức', style: TextStyle(fontSize: 13, color: colors.textMuted)),
              ],
            ),
            const SizedBox(height: 10),
            RaritySegments(counts: summary.rarityCounts, height: 8),
            const SizedBox(height: 12),
            if (empty) ...[
              Text('Hòm này chưa có món nào. Thêm công thức hoặc gắn thẻ phù hợp.', style: TextStyle(fontSize: 13, color: colors.textMuted)),
              const SizedBox(height: 8),
            ],
            NeonButton(
              label: 'Mở ${style.name}',
              icon: Icons.inventory_2_outlined,
              onPressed: empty ? null : () => context.push('/drop/${summary.id.apiValue}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, textAlign: TextAlign.center),
              TextButton(onPressed: onRetry, child: const Text('Thử lại')),
            ],
          ),
        ),
      );
}
