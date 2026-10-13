import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/neon_button.dart';
import '../../recipes/presentation/shared/photo_url_view.dart';
import '../domain/gacha_spin.dart';
import 'gacha_controller.dart';
import 'reveal_burst.dart';

/// What the user picked in the reveal dialog; the screen acts on it after the dialog closes.
enum RevealAction { cook, addToGrocery, spinAgain }

const revealEffectDuration = Duration(milliseconds: 1100);

Future<RevealAction?> showRevealOverlay(BuildContext context, GachaCard result) => showGeneralDialog<RevealAction>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Đóng',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 380),
      transitionBuilder: (context, animation, _, child) => ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: animation, child: child),
      ),
      pageBuilder: (context, _, _) => RevealOverlay(result: result),
    );

/// The drawn dish with a rarity-coloured burst. Moves the controller from revealing to done.
class RevealOverlay extends ConsumerStatefulWidget {
  const RevealOverlay({super.key, required this.result});

  final GachaCard result;

  @override
  ConsumerState<RevealOverlay> createState() => _RevealOverlayState();
}

class _RevealOverlayState extends ConsumerState<RevealOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(vsync: this, duration: revealEffectDuration);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Reduced motion: no sparks, straight to the actions.
      if (MediaQuery.disableAnimationsOf(context)) {
        _burst.value = 1;
        _finish();
      } else {
        _burst.forward().whenCompleteOrCancel(_finish);
      }
    });
  }

  void _finish() {
    if (mounted) ref.read(gachaControllerProvider.notifier).revealed();
  }

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final result = widget.result;
    final rarity = colors.rarity(result.rarity);
    final icon = Center(child: Icon(Icons.ramen_dining_outlined, size: 84, color: colors.text));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          color: colors.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: rarity)),
          shadowColor: rarity,
          elevation: 18,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200,
                  child: AnimatedBuilder(
                    animation: _burst,
                    builder: (context, child) => CustomPaint(
                      painter: RevealBurstPainter(color: rarity, progress: _burst.value),
                      child: child,
                    ),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: result.imageUrl == null
                              ? icon
                              : PhotoUrlView(url: result.imageUrl!, placeholder: icon, cacheWidth: 420),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(result.rarity.label, style: TextStyle(color: rarity, fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(result.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.15)),
                      const SizedBox(height: 6),
                      Text(
                        '${result.totalMinutes} phút · Độ khó ${result.difficulty}/5',
                        style: TextStyle(color: colors.textMuted, fontSize: 14),
                      ),
                      const SizedBox(height: 18),
                      NeonButton(label: 'Nấu món này', onPressed: () => Navigator.of(context).pop(RevealAction.cook)),
                      const SizedBox(height: 10),
                      NeonButton(
                        label: 'Thêm vào đi chợ',
                        style: NeonButtonStyle.outline,
                        height: 48,
                        onPressed: () => Navigator.of(context).pop(RevealAction.addToGrocery),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(RevealAction.spinAgain),
                        style: TextButton.styleFrom(minimumSize: const Size(44, 48), foregroundColor: colors.textMuted),
                        child: const Text('Quay lại lần nữa', style: TextStyle(fontWeight: FontWeight.w700)),
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
