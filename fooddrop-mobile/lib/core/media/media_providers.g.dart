// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaUploader)
final mediaUploaderProvider = MediaUploaderProvider._();

final class MediaUploaderProvider
    extends $FunctionalProvider<MediaUploader, MediaUploader, MediaUploader>
    with $Provider<MediaUploader> {
  MediaUploaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaUploaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaUploaderHash();

  @$internal
  @override
  $ProviderElement<MediaUploader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaUploader create(Ref ref) {
    return mediaUploader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaUploader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaUploader>(value),
    );
  }
}

String _$mediaUploaderHash() => r'93d69ff397a1d5529e72fbb7b172eb4bfcc1c9d3';
