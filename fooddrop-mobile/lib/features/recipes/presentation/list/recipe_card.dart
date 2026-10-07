import 'package:flutter/material.dart';

import '../../../../app/food_drop_colors.dart';
import '../../domain/recipe.dart';
import '../shared/recipe_artwork.dart';
import '../shared/rarity_dot.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rarityColor = colors.rarity(recipe.rarity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rarityColor.withValues(alpha: 0.4)),
        boxShadow: colors.glow(rarityColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox.square(dimension: 84, child: RecipeArtwork(recipe: recipe)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RarityLabel(rarity: recipe.rarity),
                          if (recipe.isPending) ...[
                            const Spacer(),
                            Tooltip(
                              message: 'Chưa đồng bộ',
                              child: Icon(Icons.cloud_upload_outlined, size: 16, color: colors.textMuted),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${formatMinutes(recipe.totalMinutes)} · Độ khó ${recipe.difficulty}/5',
                        style: TextStyle(fontSize: 13, color: colors.textMuted),
                      ),
                    ],
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
