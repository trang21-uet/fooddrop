import 'dart:async';

import 'package:flutter/painting.dart';

import '../domain/gacha_spin.dart';
import '../presentation/reel_card.dart';

/// Starts downloading every reel photo into Flutter's image cache and waits (at most [timeout])
/// for the slow cards, so the reel never starts or stops on blank cards.
class ReelImagePreloader {
  const ReelImagePreloader({this.timeout = const Duration(milliseconds: 1500)});

  final Duration timeout;

  Future<void> preload(GachaSpin spin) async {
    final loads = <String, Future<void>>{
      for (final card in spin.reel)
        if (card.imageUrl != null && Uri.tryParse(card.imageUrl!)?.scheme.startsWith('http') == true)
          card.imageUrl!: _load(card.imageUrl!),
    };
    final slow = [for (final url in spin.slowCardImageUrls) ?loads[url]];
    if (slow.isEmpty) return;
    await Future.wait(slow).timeout(timeout, onTimeout: () => const []);
  }

  /// Same provider `Image.network(cacheWidth: reelCardCacheWidth)` builds, so the card finds it cached.
  static Future<void> _load(String url) {
    final done = Completer<void>();
    final stream = ResizeImage.resizeIfNeeded(reelCardCacheWidth, null, NetworkImage(url)).resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    void finish() {
      if (!done.isCompleted) done.complete();
      stream.removeListener(listener);
    }

    listener = ImageStreamListener((_, _) => finish(), onError: (_, _) => finish());
    stream.addListener(listener);
    return done.future;
  }
}
