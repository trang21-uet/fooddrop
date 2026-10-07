// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_target.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadTargetCWProxy {
  UploadTarget key(String key);

  UploadTarget uploadUrl(String uploadUrl);

  UploadTarget headers(Map<String, String> headers);

  UploadTarget expiresInSeconds(int expiresInSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadTarget(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadTarget(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadTarget call({
    String key,
    String uploadUrl,
    Map<String, String> headers,
    int expiresInSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadTarget.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadTarget.copyWith.fieldName(...)`
class _$UploadTargetCWProxyImpl implements _$UploadTargetCWProxy {
  const _$UploadTargetCWProxyImpl(this._value);

  final UploadTarget _value;

  @override
  UploadTarget key(String key) => this(key: key);

  @override
  UploadTarget uploadUrl(String uploadUrl) => this(uploadUrl: uploadUrl);

  @override
  UploadTarget headers(Map<String, String> headers) => this(headers: headers);

  @override
  UploadTarget expiresInSeconds(int expiresInSeconds) =>
      this(expiresInSeconds: expiresInSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadTarget(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadTarget(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadTarget call({
    Object? key = const $CopyWithPlaceholder(),
    Object? uploadUrl = const $CopyWithPlaceholder(),
    Object? headers = const $CopyWithPlaceholder(),
    Object? expiresInSeconds = const $CopyWithPlaceholder(),
  }) {
    return UploadTarget(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      uploadUrl: uploadUrl == const $CopyWithPlaceholder()
          ? _value.uploadUrl
          // ignore: cast_nullable_to_non_nullable
          : uploadUrl as String,
      headers: headers == const $CopyWithPlaceholder()
          ? _value.headers
          // ignore: cast_nullable_to_non_nullable
          : headers as Map<String, String>,
      expiresInSeconds: expiresInSeconds == const $CopyWithPlaceholder()
          ? _value.expiresInSeconds
          // ignore: cast_nullable_to_non_nullable
          : expiresInSeconds as int,
    );
  }
}

extension $UploadTargetCopyWith on UploadTarget {
  /// Returns a callable class that can be used as follows: `instanceOfUploadTarget.copyWith(...)` or like so:`instanceOfUploadTarget.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadTargetCWProxy get copyWith => _$UploadTargetCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadTarget _$UploadTargetFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UploadTarget', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['key', 'uploadUrl', 'headers', 'expiresInSeconds'],
      );
      final val = UploadTarget(
        key: $checkedConvert('key', (v) => v as String),
        uploadUrl: $checkedConvert('uploadUrl', (v) => v as String),
        headers: $checkedConvert(
          'headers',
          (v) => Map<String, String>.from(v as Map),
        ),
        expiresInSeconds: $checkedConvert(
          'expiresInSeconds',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UploadTargetToJson(UploadTarget instance) =>
    <String, dynamic>{
      'key': instance.key,
      'uploadUrl': instance.uploadUrl,
      'headers': instance.headers,
      'expiresInSeconds': instance.expiresInSeconds,
    };
