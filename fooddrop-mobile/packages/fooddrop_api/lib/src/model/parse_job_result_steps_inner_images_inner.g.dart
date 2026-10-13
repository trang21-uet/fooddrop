// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_job_result_steps_inner_images_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseJobResultStepsInnerImagesInnerCWProxy {
  ParseJobResultStepsInnerImagesInner key(String key);

  ParseJobResultStepsInnerImagesInner url(String? url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultStepsInnerImagesInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultStepsInnerImagesInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultStepsInnerImagesInner call({String key, String? url});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseJobResultStepsInnerImagesInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseJobResultStepsInnerImagesInner.copyWith.fieldName(...)`
class _$ParseJobResultStepsInnerImagesInnerCWProxyImpl
    implements _$ParseJobResultStepsInnerImagesInnerCWProxy {
  const _$ParseJobResultStepsInnerImagesInnerCWProxyImpl(this._value);

  final ParseJobResultStepsInnerImagesInner _value;

  @override
  ParseJobResultStepsInnerImagesInner key(String key) => this(key: key);

  @override
  ParseJobResultStepsInnerImagesInner url(String? url) => this(url: url);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultStepsInnerImagesInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultStepsInnerImagesInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultStepsInnerImagesInner call({
    Object? key = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return ParseJobResultStepsInnerImagesInner(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $ParseJobResultStepsInnerImagesInnerCopyWith
    on ParseJobResultStepsInnerImagesInner {
  /// Returns a callable class that can be used as follows: `instanceOfParseJobResultStepsInnerImagesInner.copyWith(...)` or like so:`instanceOfParseJobResultStepsInnerImagesInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParseJobResultStepsInnerImagesInnerCWProxy get copyWith =>
      _$ParseJobResultStepsInnerImagesInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseJobResultStepsInnerImagesInner
_$ParseJobResultStepsInnerImagesInnerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ParseJobResultStepsInnerImagesInner', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['key', 'url']);
      final val = ParseJobResultStepsInnerImagesInner(
        key: $checkedConvert('key', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ParseJobResultStepsInnerImagesInnerToJson(
  ParseJobResultStepsInnerImagesInner instance,
) => <String, dynamic>{'key': instance.key, 'url': instance.url};
