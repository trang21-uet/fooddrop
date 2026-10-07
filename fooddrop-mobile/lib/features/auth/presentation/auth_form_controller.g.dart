// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Submit state for the login and register forms: field validation, busy flag and server errors.
/// Navigation happens by itself: the router redirects once the session exists.

@ProviderFor(AuthForm)
final authFormProvider = AuthFormProvider._();

/// Submit state for the login and register forms: field validation, busy flag and server errors.
/// Navigation happens by itself: the router redirects once the session exists.
final class AuthFormProvider
    extends $NotifierProvider<AuthForm, AuthFormState> {
  /// Submit state for the login and register forms: field validation, busy flag and server errors.
  /// Navigation happens by itself: the router redirects once the session exists.
  AuthFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authFormHash();

  @$internal
  @override
  AuthForm create() => AuthForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthFormState>(value),
    );
  }
}

String _$authFormHash() => r'6c5e640c6d5a7872b6b95f9787a8583c50381997';

/// Submit state for the login and register forms: field validation, busy flag and server errors.
/// Navigation happens by itself: the router redirects once the session exists.

abstract class _$AuthForm extends $Notifier<AuthFormState> {
  AuthFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthFormState, AuthFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthFormState, AuthFormState>,
              AuthFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
