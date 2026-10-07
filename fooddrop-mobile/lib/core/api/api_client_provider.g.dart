// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<FooddropApi, FooddropApi, FooddropApi>
    with $Provider<FooddropApi> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<FooddropApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FooddropApi create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FooddropApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FooddropApi>(value),
    );
  }
}

String _$apiClientHash() => r'b1d48ddc07af95169ae9fe2978bcd14cd40115ce';
