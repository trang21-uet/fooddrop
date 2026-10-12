import 'package:flutter/material.dart';

import '../../../../app/food_drop_colors.dart';
import '../../domain/recipe.dart';
import 'photo_url_view.dart';

/// Recipe picture: the photo when there is one and it loads, otherwise a rarity-tinted tile with
/// a bowl icon (also what shows offline).
class RecipeArtwork extends StatelessWidget {
  const RecipeArtwork({super.key, required this.recipe, this.iconSize = 36, this.borderRadius});

  final Recipe recipe;
  final double iconSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = Color.lerp(colors.surface, colors.rarity(recipe.rarity), 0.2)!;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [tint, colors.surface]),
      ),
      child: Center(
        child: Icon(Icons.ramen_dining_outlined, size: iconSize, color: colors.text.withValues(alpha: 0.8)),
      ),
    );

    final url = recipe.imageUrl;
    final child = url == null ? placeholder : PhotoUrlView(url: url, placeholder: placeholder, cacheWidth: 600);
    return ClipRRect(borderRadius: borderRadius ?? BorderRadius.circular(12), child: child);
  }
}
