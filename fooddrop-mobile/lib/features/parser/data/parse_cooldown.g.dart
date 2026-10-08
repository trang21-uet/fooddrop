// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_cooldown.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mirrors the backend's per-user import cooldown so the screen can disable its buttons and count down
/// instead of hitting a 429. The backend owns the length (`cooldownSeconds` on the created job,
/// `retryAfterSeconds` on a 429).
///
/// Epoch ms when the next import is allowed, or null when none is waiting. Held in memory only: after a
/// restart the server's 429 (with its remaining seconds) restores the countdown on the first attempt.

@ProviderFor(ParseCooldown)
final parseCooldownProvider = ParseCooldownProvider._();

/// Mirrors the backend's per-user import cooldown so the screen can disable its buttons and count down
/// instead of hitting a 429. The backend owns the length (`cooldownSeconds` on the created job,
/// `retryAfterSeconds` on a 429).
///
/// Epoch ms when the next import is allowed, or null when none is waiting. Held in memory only: after a
/// restart the server's 429 (with its remaining seconds) restores the countdown on the first attempt.
final class ParseCooldownProvider
    extends $NotifierProvider<ParseCooldown, int?> {
  /// Mirrors the backend's per-user import cooldown so the screen can disable its buttons and count down
  /// instead of hitting a 429. The backend owns the length (`cooldownSeconds` on the created job,
  /// `retryAfterSeconds` on a 429).
  ///
  /// Epoch ms when the next import is allowed, or null when none is waiting. Held in memory only: after a
  /// restart the server's 429 (with its remaining seconds) restores the countdown on the first attempt.
  ParseCooldownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parseCooldownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parseCooldownHash();

  @$internal
  @override
  ParseCooldown create() => ParseCooldown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$parseCooldownHash() => r'170d97ef475c96d3f3313c463019a007ed7d45ce';

/// Mirrors the backend's per-user import cooldown so the screen can disable its buttons and count down
/// instead of hitting a 429. The backend owns the length (`cooldownSeconds` on the created job,
/// `retryAfterSeconds` on a 429).
///
/// Epoch ms when the next import is allowed, or null when none is waiting. Held in memory only: after a
/// restart the server's 429 (with its remaining seconds) restores the countdown on the first attempt.

abstract class _$ParseCooldown extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
