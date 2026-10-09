import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../../timers/data/timer_providers.dart';
import '../../domain/recipe.dart';
import '../shared/step_image_view.dart';

/// "Lưu ý:" box under a step's photos.
class StepNoteBox extends StatelessWidget {
  const StepNoteBox({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline_rounded, size: 18, color: colors.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Lưu ý: ', style: TextStyle(fontWeight: FontWeight.w700, color: colors.accent)),
                  TextSpan(text: note),
                ],
              ),
              style: TextStyle(fontSize: 13, height: 1.5, color: colors.text.withValues(alpha: 0.85)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Starts a timer prefilled from the step.
class StartStepTimerChip extends ConsumerWidget {
  const StartStepTimerChip({super.key, required this.seconds, required this.label});

  final int seconds;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    Future<void> start() async {
      final messenger = ScaffoldMessenger.of(context);
      final router = GoRouter.of(context);
      await ref.read(timerActionsProvider).start(label, Duration(seconds: seconds));
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
      label: 'Bắt đầu hẹn giờ ${formatTimer(seconds)}',
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
                  Text(formatTimer(seconds), style: monoStyle()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Step photos as a horizontal strip; a tap opens the photo full screen with pinch-to-zoom.
class StepPhotoStrip extends StatelessWidget {
  const StepPhotoStrip({super.key, required this.images, required this.stepNumber});

  final List<RecipeStepImage> images;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (position, image) in images.indexed)
            Padding(
              padding: EdgeInsets.only(right: position == images.length - 1 ? 0 : 10),
              child: Semantics(
                button: true,
                label: 'Xem ảnh ${position + 1} của bước $stepNumber',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => _openFullScreen(context, image),
                  child: Container(
                    width: 128,
                    height: 92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(11), child: StepImageView(image: image)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openFullScreen(BuildContext context, RecipeStepImage image) => showDialog<void>(
        context: context,
        builder: (dialog) => Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              InteractiveViewer(child: StepImageView(image: image, fit: BoxFit.contain, cacheWidth: null)),
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(
                  child: IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.of(dialog).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
