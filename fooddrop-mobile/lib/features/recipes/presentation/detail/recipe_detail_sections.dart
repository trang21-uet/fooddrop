import 'package:flutter/material.dart';

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
