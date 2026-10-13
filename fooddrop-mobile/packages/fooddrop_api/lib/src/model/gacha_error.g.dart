// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_error.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaErrorCWProxy {
  GachaError statusCode(int statusCode);

  GachaError code(GachaErrorCodeEnum code);

  GachaError message(String message);

  GachaError retryAfterSeconds(int? retryAfterSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaError(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaError call({
    int statusCode,
    GachaErrorCodeEnum code,
    String message,
    int? retryAfterSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaError.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaError.copyWith.fieldName(...)`
class _$GachaErrorCWProxyImpl implements _$GachaErrorCWProxy {
  const _$GachaErrorCWProxyImpl(this._value);

  final GachaError _value;

  @override
  GachaError statusCode(int statusCode) => this(statusCode: statusCode);

  @override
  GachaError code(GachaErrorCodeEnum code) => this(code: code);

  @override
  GachaError message(String message) => this(message: message);

  @override
  GachaError retryAfterSeconds(int? retryAfterSeconds) =>
      this(retryAfterSeconds: retryAfterSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaError(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaError call({
    Object? statusCode = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? retryAfterSeconds = const $CopyWithPlaceholder(),
  }) {
    return GachaError(
      statusCode: statusCode == const $CopyWithPlaceholder()
          ? _value.statusCode
          // ignore: cast_nullable_to_non_nullable
          : statusCode as int,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as GachaErrorCodeEnum,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      retryAfterSeconds: retryAfterSeconds == const $CopyWithPlaceholder()
          ? _value.retryAfterSeconds
          // ignore: cast_nullable_to_non_nullable
          : retryAfterSeconds as int?,
    );
  }
}

extension $GachaErrorCopyWith on GachaError {
  /// Returns a callable class that can be used as follows: `instanceOfGachaError.copyWith(...)` or like so:`instanceOfGachaError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaErrorCWProxy get copyWith => _$GachaErrorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaError _$GachaErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GachaError', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['statusCode', 'code', 'message']);
      final val = GachaError(
        statusCode: $checkedConvert('statusCode', (v) => (v as num).toInt()),
        code: $checkedConvert(
          'code',
          (v) => $enumDecode(_$GachaErrorCodeEnumEnumMap, v),
        ),
        message: $checkedConvert('message', (v) => v as String),
        retryAfterSeconds: $checkedConvert(
          'retryAfterSeconds',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GachaErrorToJson(GachaError instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'code': _$GachaErrorCodeEnumEnumMap[instance.code]!,
      'message': instance.message,
      'retryAfterSeconds': ?instance.retryAfterSeconds,
    };

const _$GachaErrorCodeEnumEnumMap = {
  GachaErrorCodeEnum.gachaRateLimit: 'gacha_rate_limit',
  GachaErrorCodeEnum.gachaEmptyPool: 'gacha_empty_pool',
};
