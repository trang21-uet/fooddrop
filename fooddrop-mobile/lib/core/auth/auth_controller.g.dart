// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the signed-in session (null when signed out). Launch is offline-friendly: the stored
/// session is trusted, and a 401 from any request signs the user out via [expireSession].

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Holds the signed-in session (null when signed out). Launch is offline-friendly: the stored
/// session is trusted, and a 401 from any request signs the user out via [expireSession].
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthSession?> {
  /// Holds the signed-in session (null when signed out). Launch is offline-friendly: the stored
  /// session is trusted, and a 401 from any request signs the user out via [expireSession].
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'200049d5f4bf893398b3ca66994b8a5d70b35991';

/// Holds the signed-in session (null when signed out). Launch is offline-friendly: the stored
/// session is trusted, and a 401 from any request signs the user out via [expireSession].

abstract class _$AuthController extends $AsyncNotifier<AuthSession?> {
  FutureOr<AuthSession?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthSession?>, AuthSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSession?>, AuthSession?>,
              AsyncValue<AuthSession?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
