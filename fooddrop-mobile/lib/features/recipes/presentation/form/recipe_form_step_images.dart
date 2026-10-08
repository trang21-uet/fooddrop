import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../parser/data/photo_picker.dart';
import '../../data/step_photo_uploader.dart';
import '../../domain/recipe_draft.dart';
import '../shared/step_image_view.dart';
import 'recipe_form_controller.dart';

const _thumbSize = 88.0;

/// Photos of one step: thumbnails with a remove button, and an add tile that offers camera or gallery.
class StepImagesEditor extends ConsumerWidget {
  const StepImagesEditor({super.key, required this.step, required this.index, required this.recipeId});

  final DraftStep step;
  final int index;
  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final provider = recipeFormControllerProvider(recipeId);
    final controller = ref.read(provider.notifier);
    final uploading = ref.watch(provider.select((s) => s.uploadingSteps.contains(step.uid)));
    final canAdd = step.images.length < maxStepImages && !uploading;

    Future<void> choose() async {
      final source = await showModalBottomSheet<PhotoSource>(
        context: context,
        builder: (sheet) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Chụp ảnh'),
                onTap: () => Navigator.of(sheet).pop(PhotoSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Chọn từ thư viện (nhiều ảnh)'),
                onTap: () => Navigator.of(sheet).pop(PhotoSource.gallery),
              ),
            ],
          ),
        ),
      );
      if (source != null) await controller.addStepPhotos(step.uid, source);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ảnh minh họa (tùy chọn)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (position, image) in step.images.indexed)
              SizedBox(
                width: _thumbSize,
                height: _thumbSize,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(12), child: StepImageView(image: image)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        tooltip: 'Xóa ảnh ${position + 1} của bước ${index + 1}',
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(backgroundColor: colors.background.withValues(alpha: 0.8)),
                        onPressed: () => controller.removeStepImage(step.uid, image.key),
                        icon: Icon(Icons.close_rounded, size: 18, color: colors.danger),
                      ),
                    ),
                  ],
                ),
              ),
            Semantics(
              button: true,
              label: 'Thêm ảnh cho bước ${index + 1}',
              excludeSemantics: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: canAdd ? choose : null,
                child: Container(
                  width: _thumbSize,
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: uploading
                      ? const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))
                      : Icon(Icons.add_photo_alternate_outlined, color: canAdd ? colors.accent : colors.border),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
