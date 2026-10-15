import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/gacha_providers.dart';
import '../domain/gacha_spin.dart';
import '../domain/spin_error_message.dart';

part 'gacha_controller.g.dart';

enum GachaStatus { idle, spinning, revealing, done }

class GachaState {
  const GachaState({this.status = GachaStatus.idle, this.spin, this.requesting = false, this.error});

  final GachaStatus status;

  /// The latest server response; kept after the reveal closes so the reel rests on the result.
  final GachaSpin? spin;

  /// Waiting for the server to draw.
  final bool requesting;
  final String? error;

  bool get busy => requesting || status == GachaStatus.spinning || status == GachaStatus.revealing;
}

/// Only the state machine and the response live here; the reel offset stays in the AnimationController.
@riverpod
class GachaController extends _$GachaController {
  @override
  GachaState build() => const GachaState();

  /// Opens a cook case; the server draws from the case's recipes.
  Future<void> spin(String caseId) async {
    if (state.busy) return;
    state = GachaState(spin: state.spin, requesting: true);
    // Sounds load while the server draws; init never throws (a failure means haptic-only).
    final soundsReady = ref.read(reelSoundPlayerProvider).init();
    try {
      final spin = await ref.read(gachaRemoteProvider).spin(caseId);
      await (ref.read(reelImagePreloaderProvider).preload(spin), soundsReady).wait;
      if (!ref.mounted) return;
      state = GachaState(status: GachaStatus.spinning, spin: spin);
    } catch (error) {
      if (!ref.mounted) return;
      state = GachaState(spin: state.spin, error: spinErrorMessage(error));
    }
  }

  /// The reel stopped on the winner.
  void landed() {
    final spin = state.spin;
    if (state.status != GachaStatus.spinning || spin == null) return;
    ref.read(reelSoundPlayerProvider).reveal(spin.result.rarity);
    state = GachaState(status: GachaStatus.revealing, spin: spin);
    ref.invalidate(spinHistoryProvider);
  }

  /// The reveal effect finished.
  void revealed() {
    if (state.status == GachaStatus.revealing) state = GachaState(status: GachaStatus.done, spin: state.spin);
  }

  void dismiss() => state = GachaState(spin: state.spin);
}
