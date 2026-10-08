// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_rate_limit_error.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseRateLimitErrorCWProxy {
  ParseRateLimitError statusCode(int statusCode);

  ParseRateLimitError code(ParseRateLimitErrorCodeEnum code);

  ParseRateLimitError message(String message);

  ParseRateLimitError retryAfterSeconds(int? retryAfterSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseRateLimitError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseRateLimitError(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseRateLimitError call({
    int statusCode,
    ParseRateLimitErrorCodeEnum code,
    String message,
    int? retryAfterSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseRateLimitError.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseRateLimitError.copyWith.fieldName(...)`
class _$ParseRateLimitErrorCWProxyImpl implements _$ParseRateLimitErrorCWProxy {
  const _$ParseRateLimitErrorCWProxyImpl(this._value);

  final ParseRateLimitError _value;

  @override
  ParseRateLimitError statusCode(int statusCode) =>
      this(statusCode: statusCode);

  @override
  ParseRateLimitError code(ParseRateLimitErrorCodeEnum code) =>
      this(code: code);

  @override
  ParseRateLimitError message(String message) => this(message: message);

  @override
  ParseRateLimitError retryAfterSeconds(int? retryAfterSeconds) =>
      this(retryAfterSeconds: retryAfterSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseRateLimitError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseRateLimitError(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseRateLimitError call({
    Object? statusCode = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? retryAfterSeconds = const $CopyWithPlaceholder(),
  }) {
    return ParseRateLimitError(
      statusCode: statusCode == const $CopyWithPlaceholder()
          ? _value.statusCode
          // ignore: cast_nullable_to_non_nullable
          : statusCode as int,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as ParseRateLimitErrorCodeEnum,
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

extension $ParseRateLimitErrorCopyWith on ParseRateLimitError {
  /// Returns a callable class that can be used as follows: `instanceOfParseRateLimitError.copyWith(...)` or like so:`instanceOfParseRateLimitError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParseRateLimitErrorCWProxy get copyWith =>
      _$ParseRateLimitErrorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseRateLimitError _$ParseRateLimitErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ParseRateLimitError', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['statusCode', 'code', 'message']);
      final val = ParseRateLimitError(
        statusCode: $checkedConvert('statusCode', (v) => (v as num).toInt()),
        code: $checkedConvert(
          'code',
          (v) => $enumDecode(_$ParseRateLimitErrorCodeEnumEnumMap, v),
        ),
        message: $checkedConvert('message', (v) => v as String),
        retryAfterSeconds: $checkedConvert(
          'retryAfterSeconds',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ParseRateLimitErrorToJson(
  ParseRateLimitError instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'code': _$ParseRateLimitErrorCodeEnumEnumMap[instance.code]!,
  'message': instance.message,
  'retryAfterSeconds': ?instance.retryAfterSeconds,
};

const _$ParseRateLimitErrorCodeEnumEnumMap = {
  ParseRateLimitErrorCodeEnum.parseCooldown: 'parse_cooldown',
  ParseRateLimitErrorCodeEnum.parseDailyQuota: 'parse_daily_quota',
};
