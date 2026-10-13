import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../recipes/domain/rarity.dart';

/// Reel feedback. Every call is fire-and-forget and never throws, so a broken audio stack only
/// costs the sound: the reel still spins and the haptic still fires.
abstract class ReelSoundPlayer {
  /// Preloads the sounds; call before the first spin.
  Future<void> init();

  /// One card boundary crossed.
  void tick();

  void reveal(Rarity rarity);
}

/// `flutter_soloud` keeps decoded sounds in memory for low-latency ticks on Android. The sounds
/// are original, synthesized by `scripts/generate-gacha-sounds.mjs`.
class SoLoudReelSoundPlayer implements ReelSoundPlayer {
  AudioSource? _tick;
  final _reveals = <Rarity, AudioSource>{};
  Future<void>? _loading;

  @override
  Future<void> init() => _loading ??= _load().catchError((Object error) {
        _loading = null; // Haptic-only for now; retry on the next spin.
        debugPrint('Reel sounds unavailable: $error');
      });

  Future<void> _load() async {
    final soloud = SoLoud.instance;
    if (!soloud.isInitialized) await soloud.init(bufferSize: 512);
    _tick = await soloud.loadAsset('assets/sounds/tick.wav');
    for (final rarity in Rarity.values) {
      _reveals[rarity] = await soloud.loadAsset('assets/sounds/reveal-${rarity.apiValue}.wav');
    }
  }

  @override
  void tick() {
    HapticFeedback.selectionClick();
    _play(_tick, volume: 0.6);
  }

  @override
  void reveal(Rarity rarity) {
    HapticFeedback.heavyImpact();
    _play(_reveals[rarity]);
  }

  void _play(AudioSource? source, {double volume = 0.8}) {
    if (source == null) return;
    try {
      SoLoud.instance.play(source, volume: volume);
    } catch (error) {
      debugPrint('Reel sound failed: $error');
    }
  }
}
