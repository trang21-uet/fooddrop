// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_parse_job.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateParseJobCWProxy {
  CreateParseJob url(String? url);

  CreateParseJob imageKey(String? imageKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateParseJob(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateParseJob(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateParseJob call({String? url, String? imageKey});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateParseJob.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateParseJob.copyWith.fieldName(...)`
class _$CreateParseJobCWProxyImpl implements _$CreateParseJobCWProxy {
  const _$CreateParseJobCWProxyImpl(this._value);

  final CreateParseJob _value;

  @override
  CreateParseJob url(String? url) => this(url: url);

  @override
  CreateParseJob imageKey(String? imageKey) => this(imageKey: imageKey);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateParseJob(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateParseJob(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateParseJob call({
    Object? url = const $CopyWithPlaceholder(),
    Object? imageKey = const $CopyWithPlaceholder(),
  }) {
    return CreateParseJob(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      imageKey: imageKey == const $CopyWithPlaceholder()
          ? _value.imageKey
          // ignore: cast_nullable_to_non_nullable
          : imageKey as String?,
    );
  }
}

extension $CreateParseJobCopyWith on CreateParseJob {
  /// Returns a callable class that can be used as follows: `instanceOfCreateParseJob.copyWith(...)` or like so:`instanceOfCreateParseJob.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateParseJobCWProxy get copyWith => _$CreateParseJobCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateParseJob _$CreateParseJobFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateParseJob', json, ($checkedConvert) {
      final val = CreateParseJob(
        url: $checkedConvert('url', (v) => v as String?),
        imageKey: $checkedConvert('imageKey', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreateParseJobToJson(CreateParseJob instance) =>
    <String, dynamic>{'url': ?instance.url, 'imageKey': ?instance.imageKey};
