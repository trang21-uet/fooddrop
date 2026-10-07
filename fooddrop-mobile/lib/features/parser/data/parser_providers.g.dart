// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parser_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(parserRemote)
final parserRemoteProvider = ParserRemoteProvider._();

final class ParserRemoteProvider
    extends $FunctionalProvider<ParserRemote, ParserRemote, ParserRemote>
    with $Provider<ParserRemote> {
  ParserRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parserRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parserRemoteHash();

  @$internal
  @override
  $ProviderElement<ParserRemote> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ParserRemote create(Ref ref) {
    return parserRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParserRemote value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParserRemote>(value),
    );
  }
}

String _$parserRemoteHash() => r'a416c94c3120ec24321c87bb18d2d93f9577e874';

@ProviderFor(photoPicker)
final photoPickerProvider = PhotoPickerProvider._();

final class PhotoPickerProvider
    extends $FunctionalProvider<PhotoPicker, PhotoPicker, PhotoPicker>
    with $Provider<PhotoPicker> {
  PhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoPickerHash();

  @$internal
  @override
  $ProviderElement<PhotoPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoPicker create(Ref ref) {
    return photoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoPicker>(value),
    );
  }
}

String _$photoPickerHash() => r'79278d0db68c20894ac0a8918cf4dc7df16de084';

/// How often a running job is polled; tests override it to avoid real waiting.

@ProviderFor(importPollInterval)
final importPollIntervalProvider = ImportPollIntervalProvider._();

/// How often a running job is polled; tests override it to avoid real waiting.

final class ImportPollIntervalProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// How often a running job is polled; tests override it to avoid real waiting.
  ImportPollIntervalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importPollIntervalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importPollIntervalHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return importPollInterval(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$importPollIntervalHash() =>
    r'6d2256b936ad7864ec2a43e45f28d27e43a8a5dd';

/// Draft handed from the import screen to the "new recipe" form. The form clears it once shown,
/// so a later plain "new recipe" never starts from a stale import.

@ProviderFor(ImportedDraft)
final importedDraftProvider = ImportedDraftProvider._();

/// Draft handed from the import screen to the "new recipe" form. The form clears it once shown,
/// so a later plain "new recipe" never starts from a stale import.
final class ImportedDraftProvider
    extends $NotifierProvider<ImportedDraft, RecipeDraft?> {
  /// Draft handed from the import screen to the "new recipe" form. The form clears it once shown,
  /// so a later plain "new recipe" never starts from a stale import.
  ImportedDraftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importedDraftProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importedDraftHash();

  @$internal
  @override
  ImportedDraft create() => ImportedDraft();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeDraft? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeDraft?>(value),
    );
  }
}

String _$importedDraftHash() => r'2729c728f000c76daefe418973720066bb53291c';

/// Draft handed from the import screen to the "new recipe" form. The form clears it once shown,
/// so a later plain "new recipe" never starts from a stale import.

abstract class _$ImportedDraft extends $Notifier<RecipeDraft?> {
  RecipeDraft? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecipeDraft?, RecipeDraft?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecipeDraft?, RecipeDraft?>,
              RecipeDraft?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
