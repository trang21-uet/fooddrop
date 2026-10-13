import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/neon_button.dart';
import '../../grocery/data/grocery_providers.dart';
import '../data/gacha_providers.dart';
import '../domain/gacha_case.dart';
import '../domain/gacha_spin.dart';
import 'case_reel.dart';
import 'gacha_case_style.dart';
import 'gacha_controller.dart';
import 'reveal_overlay.dart';
import 'spin_history_section.dart';

/// Below this many recipes the reel repeats a lot, so suggest adding more.
const _smallPool = 5;

/// The reel for one case, opened from the case picker.
class DropScreen extends ConsumerWidget {
  const DropScreen({super.key, required this.caseId});

  final GachaCaseId caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final style = GachaCaseStyle.of(caseId);
    final state = ref.watch(gachaControllerProvider);
    final controller = ref.read(gachaControllerProvider.notifier);
    final summary = ref.watch(gachaCasesProvider).value?.where((item) => item.id == caseId).firstOrNull;
    final empty = summary?.recipeCount == 0;

    ref.listen(gachaControllerProvider.select((s) => s.status), (previous, next) async {
      final result = ref.read(gachaControllerProvider).spin?.result;
      if (next != GachaStatus.revealing || result == null) return;
      final action = await showRevealOverlay(context, result);
      controller.dismiss();
      if (context.mounted) await _onRevealAction(context, ref, action, result);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Quay món')),
      body: ListView(
        padding: const EdgeInsets.only(top: 4, bottom: 96),
        children: [
          _Padded([
            const Text('Hôm nay ăn gì?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.8)),
            const SizedBox(height: 4),
            Text('Mở hộp để bếp quyết định giúp bạn.', style: TextStyle(color: colors.textMuted, fontSize: 15)),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: _CaseChip(style: style, summary: summary)),
            const SizedBox(height: 16),
          ]),
          // Edge to edge, as on the design board.
          CaseReel(
            spin: state.spin,
            idleCards: summary?.preview ?? const [],
            spinning: state.status == GachaStatus.spinning,
            onLanded: controller.landed,
          ),
          _Padded([
            const SizedBox(height: 16),
            NeonButton(
              label: state.status == GachaStatus.spinning ? 'Đang quay…' : 'Mở hộp',
              icon: Icons.inventory_2_outlined,
              loading: state.requesting,
              onPressed: state.busy || empty ? null : () => controller.spin(caseId),
            ),
            if (empty) ...[
              const SizedBox(height: 10),
              Text('Hòm này chưa có món nào. Chọn hòm khác nhé.', style: TextStyle(color: colors.textMuted, fontSize: 13)),
            ],
            if (state.error != null) ...[
              const SizedBox(height: 10),
              Text(state.error!, style: TextStyle(color: colors.danger)),
            ],
            if (state.spin != null && state.status != GachaStatus.spinning && state.spin!.poolSize < _smallPool) ...[
              const SizedBox(height: 10),
              Text(
                'Hòm chỉ có ${state.spin!.poolSize} món — thêm công thức để vòng quay đa dạng hơn.',
                style: TextStyle(color: colors.textMuted, fontSize: 13),
              ),
            ],
            const SizedBox(height: 28),
            const SpinHistorySection(),
          ]),
        ],
      ),
    );
  }

  Future<void> _onRevealAction(BuildContext context, WidgetRef ref, RevealAction? action, GachaCard result) async {
    switch (action) {
      case RevealAction.cook:
        context.push('/recipes/${result.id}');
      case RevealAction.addToGrocery:
        await ref.read(groceryActionsProvider).addRecipe(result.id, result.baseServings);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm "${result.title}" vào danh sách đi chợ.'),
            action: SnackBarAction(label: 'Xem', onPressed: () => context.push('/grocery')),
          ),
        );
      case RevealAction.spinAgain:
        await ref.read(gachaControllerProvider.notifier).spin(caseId);
      case null:
        break;
    }
  }
}

/// "Hòm Bữa tối · 24 công thức · Đổi hòm": back to the case picker.
class _CaseChip extends StatelessWidget {
  const _CaseChip({required this.style, required this.summary});

  final GachaCaseStyle style;
  final GachaCaseSummary? summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceRaised,
      shape: StadiumBorder(side: BorderSide(color: style.color)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.canPop() ? context.pop() : context.go('/drop'),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: style.color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: summary == null ? style.name : '${style.name} · ${summary!.recipeCount} công thức',
                      children: [TextSpan(text: ' · Đổi hòm', style: TextStyle(color: colors.accent))],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The screen's 20 px side margin for everything but the edge-to-edge reel.
class _Padded extends StatelessWidget {
  const _Padded(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      );
}
