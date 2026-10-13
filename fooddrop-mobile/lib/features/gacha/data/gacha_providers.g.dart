// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gachaRemote)
final gachaRemoteProvider = GachaRemoteProvider._();

final class GachaRemoteProvider
    extends $FunctionalProvider<GachaRemote, GachaRemote, GachaRemote>
    with $Provider<GachaRemote> {
  GachaRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gachaRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gachaRemoteHash();

  @$internal
  @override
  $ProviderElement<GachaRemote> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GachaRemote create(Ref ref) {
    return gachaRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GachaRemote value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GachaRemote>(value),
    );
  }
}

String _$gachaRemoteHash() => r'10f0d4a9634b06dd4f8f8d39183f678267004eb9';

/// Tests override this: flutter_soloud needs the native audio engine.

@ProviderFor(reelSoundPlayer)
final reelSoundPlayerProvider = ReelSoundPlayerProvider._();

/// Tests override this: flutter_soloud needs the native audio engine.

final class ReelSoundPlayerProvider
    extends
        $FunctionalProvider<ReelSoundPlayer, ReelSoundPlayer, ReelSoundPlayer>
    with $Provider<ReelSoundPlayer> {
  /// Tests override this: flutter_soloud needs the native audio engine.
  ReelSoundPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reelSoundPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reelSoundPlayerHash();

  @$internal
  @override
  $ProviderElement<ReelSoundPlayer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReelSoundPlayer create(Ref ref) {
    return reelSoundPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReelSoundPlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReelSoundPlayer>(value),
    );
  }
}

String _$reelSoundPlayerHash() => r'c7bfb29c6d8357f8bd1c8722bf4d7dba7371be0f';

@ProviderFor(reelImagePreloader)
final reelImagePreloaderProvider = ReelImagePreloaderProvider._();

final class ReelImagePreloaderProvider
    extends
        $FunctionalProvider<
          ReelImagePreloader,
          ReelImagePreloader,
          ReelImagePreloader
        >
    with $Provider<ReelImagePreloader> {
  ReelImagePreloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reelImagePreloaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reelImagePreloaderHash();

  @$internal
  @override
  $ProviderElement<ReelImagePreloader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReelImagePreloader create(Ref ref) {
    return reelImagePreloader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReelImagePreloader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReelImagePreloader>(value),
    );
  }
}

String _$reelImagePreloaderHash() =>
    r'ab824ded0d51694c6a0725fe2b7ca362179394a5';

/// How long the reel spins; tests override it to keep widget tests short.

@ProviderFor(spinDuration)
final spinDurationProvider = SpinDurationProvider._();

/// How long the reel spins; tests override it to keep widget tests short.

final class SpinDurationProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// How long the reel spins; tests override it to keep widget tests short.
  SpinDurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spinDurationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spinDurationHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return spinDuration(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$spinDurationHash() => r'a730b081ac41698cf260b98ea459f4c13ba5b20a';

/// The cases with what each holds; the picker and the reel page share it.

@ProviderFor(gachaCases)
final gachaCasesProvider = GachaCasesProvider._();

/// The cases with what each holds; the picker and the reel page share it.

final class GachaCasesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GachaCaseSummary>>,
          List<GachaCaseSummary>,
          FutureOr<List<GachaCaseSummary>>
        >
    with
        $FutureModifier<List<GachaCaseSummary>>,
        $FutureProvider<List<GachaCaseSummary>> {
  /// The cases with what each holds; the picker and the reel page share it.
  GachaCasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gachaCasesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gachaCasesHash();

  @$internal
  @override
  $FutureProviderElement<List<GachaCaseSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GachaCaseSummary>> create(Ref ref) {
    return gachaCases(ref);
  }
}

String _$gachaCasesHash() => r'a64af5f2d22cd9eaefadf6af00e881dbd9bed2b1';

/// Latest spins. Invalidated after the reel lands, never before, so it cannot spoil a result.

@ProviderFor(spinHistory)
final spinHistoryProvider = SpinHistoryProvider._();

/// Latest spins. Invalidated after the reel lands, never before, so it cannot spoil a result.

final class SpinHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SpinHistoryEntry>>,
          List<SpinHistoryEntry>,
          FutureOr<List<SpinHistoryEntry>>
        >
    with
        $FutureModifier<List<SpinHistoryEntry>>,
        $FutureProvider<List<SpinHistoryEntry>> {
  /// Latest spins. Invalidated after the reel lands, never before, so it cannot spoil a result.
  SpinHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spinHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spinHistoryHash();

  @$internal
  @override
  $FutureProviderElement<List<SpinHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpinHistoryEntry>> create(Ref ref) {
    return spinHistory(ref);
  }
}

String _$spinHistoryHash() => r'd4a42236e183f793d12780c8191761c80c8fce48';
