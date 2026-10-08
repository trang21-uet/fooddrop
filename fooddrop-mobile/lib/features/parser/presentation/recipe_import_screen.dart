import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/labeled_text_field.dart';
import '../../../core/widgets/neon_button.dart';
import '../../timers/data/timer_providers.dart' show nowMsProvider, tickerProvider;
import '../data/parse_cooldown.dart';
import '../data/photo_picker.dart';
import 'recipe_import_controller.dart';

/// Paste a link or photograph a recipe; the draft then opens in the regular recipe form for review.
class RecipeImportScreen extends ConsumerStatefulWidget {
  const RecipeImportScreen({super.key});

  @override
  ConsumerState<RecipeImportScreen> createState() => _RecipeImportScreenState();
}

class _RecipeImportScreenState extends ConsumerState<RecipeImportScreen> {
  final _url = TextEditingController();

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(recipeImportControllerProvider);
    final controller = ref.read(recipeImportControllerProvider.notifier);
    final working = state.phase == ImportPhase.working;
    final cooldownEndsAt = ref.watch(parseCooldownProvider);
    int secondsLeft() => parseCooldownSecondsLeft(cooldownEndsAt, ref.read(nowMsProvider)());
    // The shared ticker only runs (and rebuilds this screen twice a second) while a wait is counting down.
    if (secondsLeft() > 0) ref.watch(tickerProvider);
    final cooldownLeft = secondsLeft();
    final blocked = working || cooldownLeft > 0;

    ref.listen(recipeImportControllerProvider, (_, next) {
      if (next.phase != ImportPhase.done) return;
      // The draft is waiting in ImportedDraft; replace this screen so "back" returns to the list.
      context.pushReplacement('/recipes/new');
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Nhập công thức', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            key: const Key('in-development-notice'),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.accent.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.construction_rounded, size: 18, color: colors.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Đang phát triển: tính năng này chưa hoàn thiện nên kết quả có thể chưa chính xác.',
                    style: TextStyle(fontSize: 13, color: colors.text),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dán liên kết hoặc chụp ảnh công thức, Food Drop sẽ tạo bản nháp để bạn chỉnh sửa.',
            style: TextStyle(fontSize: 14, color: colors.textMuted),
          ),
          const SizedBox(height: 24),
          LabeledTextField(
            label: 'Liên kết công thức',
            controller: _url,
            hint: 'https://…',
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            onSubmitted: blocked ? null : (_) => _submitUrl(controller),
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: 'Đọc công thức từ liên kết',
            height: 52,
            loading: working,
            onPressed: blocked ? null : () => _submitUrl(controller),
          ),
          const SizedBox(height: 28),
          Text('Hoặc dùng ảnh', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textMuted)),
          const SizedBox(height: 12),
          NeonButton(
            label: 'Chụp ảnh công thức',
            icon: Icons.photo_camera_outlined,
            style: NeonButtonStyle.outline,
            height: 52,
            onPressed: blocked ? null : () => controller.importPhoto(PhotoSource.camera),
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: 'Chọn ảnh từ thư viện',
            icon: Icons.photo_library_outlined,
            style: NeonButtonStyle.outline,
            height: 52,
            onPressed: blocked ? null : () => controller.importPhoto(PhotoSource.gallery),
          ),
          if (cooldownLeft > 0)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'Bạn vừa nhập một công thức. Hãy chờ $cooldownLeft giây nữa để nhập tiếp.',
                key: const Key('import-cooldown'),
                style: TextStyle(fontSize: 14, color: colors.textMuted),
              ),
            ),
          if (working)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'Đang đọc công thức… thường mất vài giây.',
                key: const Key('import-progress'),
                style: TextStyle(fontSize: 14, color: colors.textMuted),
              ),
            ),
          if (state.phase == ImportPhase.failed)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(state.message ?? '', key: const Key('import-error'), style: TextStyle(fontSize: 14, color: colors.danger)),
            ),
        ],
      ),
    );
  }

  void _submitUrl(RecipeImportController controller) {
    final url = _url.text.trim();
    if (url.isNotEmpty) controller.importUrl(url);
  }
}
