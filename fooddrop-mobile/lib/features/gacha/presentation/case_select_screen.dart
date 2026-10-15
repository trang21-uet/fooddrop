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

/// "Chọn hòm": pick a tab and a case, then open it on `/drop/:caseId`.
class CaseSelectScreen extends ConsumerStatefulWidget {
  const CaseSelectScreen({super.key});

  @override
  ConsumerState<CaseSelectScreen> createState() => _CaseSelectScreenState();
}

class _CaseSelectScreenState extends ConsumerState<CaseSelectScreen> {
  var _group = GachaCaseGroup.featured;
  var _selected = 'all';

  void _openTab(GachaCaseGroup group, List<GachaCaseSummary>? cases) => setState(() {
        _group = group;
        // Keep the bottom bar on a case of the open tab.
        final first = cases?.where((item) => item.group == group).firstOrNull;
        if (first != null) _selected = first.id;
      });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cases = ref.watch(gachaCasesProvider);
    final visible = cases.value?.where((item) => item.group == _group).toList() ?? const <GachaCaseSummary>[];
    final summary = visible.where((item) => item.id == _selected).firstOrNull;

    return DefaultTabController(
      length: GachaCaseGroup.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chọn hòm'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: (index) => _openTab(GachaCaseGroup.values[index], cases.value),
            tabs: [
              for (final group in GachaCaseGroup.values)
                Tab(text: '${gachaCaseGroupLabel(group)} ${cases.value?.where((item) => item.group == group).length ?? ''}'.trim()),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: switch (cases) {
                AsyncData() when visible.isEmpty => _Message(
                    text: 'Chưa có công thức nào gắn thẻ ${gachaCaseGroupLabel(_group).toLowerCase()}. '
                        'Gắn thẻ cho công thức để có hòm ở đây.',
                  ),
                AsyncData() => CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                            for (final item in visible)
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
    final style = GachaCaseStyle.of(summary);
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
              onPressed: empty ? null : () => context.push('/drop/${summary.id}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, textAlign: TextAlign.center),
              if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('Thử lại')),
            ],
          ),
        ),
      );
}
