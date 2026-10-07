// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs a sync on sign-in and whenever asked (pull-to-refresh, app resume, after a local edit).

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Runs a sync on sign-in and whenever asked (pull-to-refresh, app resume, after a local edit).
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncState> {
  /// Runs a sync on sign-in and whenever asked (pull-to-refresh, app resume, after a local edit).
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncControllerHash() => r'090beca289ade2a788a33c0216bad4faa1f00822';

/// Runs a sync on sign-in and whenever asked (pull-to-refresh, app resume, after a local edit).

abstract class _$SyncController extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
