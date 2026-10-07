import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../../timers/data/timer_providers.dart';
import '../../domain/recipe.dart';

class StepsSection extends StatelessWidget {
  const StepsSection({super.key, required this.recipeTitle, required this.steps});

  final String recipeTitle;
  final List<RecipeStep> steps;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cách làm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final (index, step) in steps.indexed)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.accent)),
                    child: Text('${index + 1}', style: monoStyle()),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.text, style: const TextStyle(fontSize: 14, height: 1.55)),
                        if (step.timerSeconds != null) ...[
                          const SizedBox(height: 10),
                          _StartTimerChip(step: step, label: step.timerLabel ?? '$recipeTitle · bước ${index + 1}'),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Starts a timer prefilled from the step.
class _StartTimerChip extends ConsumerWidget {
  const _StartTimerChip({required this.step, required this.label});

  final RecipeStep step;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    Future<void> start() async {
      final messenger = ScaffoldMessenger.of(context);
      final router = GoRouter.of(context);
      await ref.read(timerActionsProvider).start(label, Duration(seconds: step.timerSeconds!));
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Đã bắt đầu hẹn giờ'),
            action: SnackBarAction(label: 'Xem', onPressed: () => router.push('/timers')),
          ),
        );
    }

    return Semantics(
      button: true,
      label: 'Bắt đầu hẹn giờ ${formatTimer(step.timerSeconds!)}',
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: colors.border)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: start,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: colors.accent),
                  const SizedBox(width: 8),
                  Text(formatTimer(step.timerSeconds!), style: monoStyle()),
                  if (step.timerLabel != null) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(step.timerLabel!, style: TextStyle(fontSize: 13, color: colors.textMuted)),
                    ),
                  ],
                  const SizedBox(width: 10),
                  Icon(Icons.play_arrow_rounded, size: 20, color: colors.accent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
