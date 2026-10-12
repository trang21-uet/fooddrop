import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../shared/photo_url_view.dart';
import 'photo_source_sheet.dart';
import 'recipe_form_controller.dart';

/// The recipe photo: a preview with a remove button, and a button to take or pick a new one.
class RecipeFormCoverImage extends ConsumerWidget {
  const RecipeFormCoverImage({super.key, required this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final provider = recipeFormControllerProvider(recipeId);
    final controller = ref.read(provider.notifier);
    final url = ref.watch(provider.select((s) => s.draft.imageUrl));
    final uploading = ref.watch(provider.select((s) => s.uploadingCover));
    final error = ref.watch(provider.select((s) => s.coverError));

    Future<void> choose() async {
      final source = await showPhotoSourceSheet(context);
      if (source != null) await controller.setCoverPhoto(source);
    }

    final placeholder = ColoredBox(
      color: colors.surfaceRaised,
      child: Center(child: Icon(Icons.ramen_dining_outlined, size: 36, color: colors.textMuted)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ảnh món (tùy chọn)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (url == null) placeholder else PhotoUrlView(url: url, placeholder: placeholder, cacheWidth: 800),
                if (uploading) const Center(child: CircularProgressIndicator()),
                if (url != null && !uploading)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      tooltip: 'Xóa ảnh món',
                      style: IconButton.styleFrom(backgroundColor: colors.background.withValues(alpha: 0.8)),
                      onPressed: controller.removeCover,
                      icon: Icon(Icons.close_rounded, size: 18, color: colors.danger),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: uploading ? null : choose,
          icon: const Icon(Icons.add_a_photo_outlined),
          label: Text(url == null ? 'Thêm ảnh món' : 'Đổi ảnh khác'),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(error, key: const Key('cover-image-error'), style: TextStyle(fontSize: 13, color: colors.danger)),
          ),
      ],
    );
  }
}
