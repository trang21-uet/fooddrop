import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../domain/recipe.dart';
import '../shared/rarity_dot.dart';

/// Rarity badge, title, quick facts and tags.
class RecipeSummarySection extends StatelessWidget {
  const RecipeSummarySection({super.key, required this.recipe, required this.tags});

  final Recipe recipe;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RarityBadge(rarity: recipe.rarity),
          const SizedBox(height: 14),
          Text(
            recipe.title,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.02, height: 1.05),
          ),
          if (recipe.description != null) ...[
            const SizedBox(height: 10),
            Text(recipe.description!, style: TextStyle(fontSize: 14, height: 1.5, color: colors.textMuted)),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _Fact(label: 'Tổng', value: formatMinutes(recipe.totalMinutes)),
              _Fact(label: 'Độ khó', value: '${recipe.difficulty} / 5'),
              _Fact(label: 'Khẩu phần', value: '${recipe.baseServings} người'),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final tag in tags) _TagPill(tag.label)]),
          ],
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 11, letterSpacing: 0.9, color: context.colors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      );
}

class _TagPill extends StatelessWidget {
  const _TagPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: colors.surfaceRaised,
        shape: StadiumBorder(side: BorderSide(color: colors.border)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
              _TagPill('${recipe.baseServings} người'),
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
                  SizedBox(width: 84, child: Text(item.quantityLabel, style: monoStyle())),
                  Expanded(
                    child: Text(
                      item.note == null ? item.name : '${item.name} · ${item.note}',
                      style: const TextStyle(fontSize: 14),
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

class StepsSection extends StatelessWidget {
  const StepsSection({super.key, required this.steps});

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
                        if (step.timerSeconds != null) ...[const SizedBox(height: 10), _TimerChip(step: step)],
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

/// Shows the step's timer length; starting timers arrives with the timers feature.
class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.step});

  final RecipeStep step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: colors.accent),
          const SizedBox(width: 8),
          Text(formatTimer(step.timerSeconds!), style: monoStyle()),
          if (step.timerLabel != null) ...[
            const SizedBox(width: 8),
            Text(step.timerLabel!, style: TextStyle(fontSize: 13, color: colors.textMuted)),
          ],
        ],
      ),
    );
  }
}
