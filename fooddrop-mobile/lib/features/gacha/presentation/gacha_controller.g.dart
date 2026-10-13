// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Only the state machine and the response live here; the reel offset stays in the AnimationController.

@ProviderFor(GachaController)
final gachaControllerProvider = GachaControllerProvider._();

/// Only the state machine and the response live here; the reel offset stays in the AnimationController.
final class GachaControllerProvider
    extends $NotifierProvider<GachaController, GachaState> {
  /// Only the state machine and the response live here; the reel offset stays in the AnimationController.
  GachaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gachaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gachaControllerHash();

  @$internal
  @override
  GachaController create() => GachaController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GachaState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GachaState>(value),
    );
  }
}

String _$gachaControllerHash() => r'bedd259c699012baccc5c07ac1ce23003977aae2';

/// Only the state machine and the response live here; the reel offset stays in the AnimationController.

abstract class _$GachaController extends $Notifier<GachaState> {
  GachaState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GachaState, GachaState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GachaState, GachaState>,
              GachaState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
