import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/food_drop_colors.dart';
import '../../domain/recipe.dart';

/// A step photo: the server URL once synced, or the picked file's `file:` URI before that.
/// Falls back to an icon tile when there is no URL yet or it does not load (offline).
class StepImageView extends StatelessWidget {
  const StepImageView({super.key, required this.image, this.fit = BoxFit.cover, this.cacheWidth = 400});

  final RecipeStepImage image;
  final BoxFit fit;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    final url = image.url;
    Widget placeholder() => ColoredBox(
          color: context.colors.surfaceRaised,
          child: Center(child: Icon(Icons.image_outlined, color: context.colors.textMuted)),
        );
    if (url == null) return placeholder();
    final uri = Uri.tryParse(url);
    if (uri != null && uri.scheme == 'file') {
      return Image.file(
        File.fromUri(uri),
        fit: fit,
        cacheWidth: cacheWidth,
        excludeFromSemantics: true,
        errorBuilder: (context, error, stackTrace) => placeholder(),
      );
    }
    return Image.network(
      url,
      fit: fit,
      cacheWidth: cacheWidth,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) => placeholder(),
      loadingBuilder: (context, child, progress) => progress == null ? child : placeholder(),
    );
  }
}
