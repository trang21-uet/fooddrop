import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../timers/data/timer_providers.dart' show nowMsProvider;

part 'parse_cooldown.g.dart';

/// Mirrors the backend's per-user import cooldown so the screen can disable its buttons and count down
/// instead of hitting a 429. The backend owns the length (`cooldownSeconds` on the created job,
/// `retryAfterSeconds` on a 429).
///
/// Epoch ms when the next import is allowed, or null when none is waiting. Held in memory only: after a
/// restart the server's 429 (with its remaining seconds) restores the countdown on the first attempt.
@Riverpod(keepAlive: true)
class ParseCooldown extends _$ParseCooldown {
  @override
  int? build() => null;

  /// [duration] always comes from the server, so both sides agree; zero (cooldown off) ends it right away.
  void start(Duration duration) =>
      state = ref.read(nowMsProvider)() + duration.inMilliseconds;
}

int parseCooldownSecondsLeft(int? endsAtMs, int nowMs) =>
    endsAtMs == null ? 0 : math.max(0, ((endsAtMs - nowMs) / 1000).ceil());
