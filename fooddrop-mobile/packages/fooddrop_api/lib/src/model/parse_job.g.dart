// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_job.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseJobCWProxy {
  ParseJob id(String id);

  ParseJob status(ParseJobStatusEnum status);

  ParseJob sourceType(ParseJobSourceTypeEnum sourceType);

  ParseJob errorCode(ParseJobErrorCodeEnum? errorCode);

  ParseJob result(ParseJobResult? result);

  ParseJob createdAt(DateTime createdAt);

  ParseJob cooldownSeconds(int cooldownSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJob(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJob(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJob call({
    String id,
    ParseJobStatusEnum status,
    ParseJobSourceTypeEnum sourceType,
    ParseJobErrorCodeEnum? errorCode,
    ParseJobResult? result,
    DateTime createdAt,
    int cooldownSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseJob.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseJob.copyWith.fieldName(...)`
class _$ParseJobCWProxyImpl implements _$ParseJobCWProxy {
  const _$ParseJobCWProxyImpl(this._value);

  final ParseJob _value;

  @override
  ParseJob id(String id) => this(id: id);

  @override
  ParseJob status(ParseJobStatusEnum status) => this(status: status);

  @override
  ParseJob sourceType(ParseJobSourceTypeEnum sourceType) =>
      this(sourceType: sourceType);

  @override
  ParseJob errorCode(ParseJobErrorCodeEnum? errorCode) =>
      this(errorCode: errorCode);

  @override
  ParseJob result(ParseJobResult? result) => this(result: result);

  @override
  ParseJob createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  ParseJob cooldownSeconds(int cooldownSeconds) =>
      this(cooldownSeconds: cooldownSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJob(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJob(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJob call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? sourceType = const $CopyWithPlaceholder(),
    Object? errorCode = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? cooldownSeconds = const $CopyWithPlaceholder(),
  }) {
    return ParseJob(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ParseJobStatusEnum,
      sourceType: sourceType == const $CopyWithPlaceholder()
          ? _value.sourceType
          // ignore: cast_nullable_to_non_nullable
          : sourceType as ParseJobSourceTypeEnum,
      errorCode: errorCode == const $CopyWithPlaceholder()
          ? _value.errorCode
          // ignore: cast_nullable_to_non_nullable
          : errorCode as ParseJobErrorCodeEnum?,
      result: result == const $CopyWithPlaceholder()
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as ParseJobResult?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      cooldownSeconds: cooldownSeconds == const $CopyWithPlaceholder()
          ? _value.cooldownSeconds
          // ignore: cast_nullable_to_non_nullable
          : cooldownSeconds as int,
    );
  }
}

extension $ParseJobCopyWith on ParseJob {
  /// Returns a callable class that can be used as follows: `instanceOfParseJob.copyWith(...)` or like so:`instanceOfParseJob.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParseJobCWProxy get copyWith => _$ParseJobCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseJob _$ParseJobFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ParseJob', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'status',
      'sourceType',
      'errorCode',
      'result',
      'createdAt',
      'cooldownSeconds',
    ],
  );
  final val = ParseJob(
    id: $checkedConvert('id', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$ParseJobStatusEnumEnumMap, v),
    ),
    sourceType: $checkedConvert(
      'sourceType',
      (v) => $enumDecode(_$ParseJobSourceTypeEnumEnumMap, v),
    ),
    errorCode: $checkedConvert(
      'errorCode',
      (v) => $enumDecodeNullable(_$ParseJobErrorCodeEnumEnumMap, v),
    ),
    result: $checkedConvert(
      'result',
      (v) =>
          v == null ? null : ParseJobResult.fromJson(v as Map<String, dynamic>),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    cooldownSeconds: $checkedConvert(
      'cooldownSeconds',
      (v) => (v as num).toInt(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ParseJobToJson(ParseJob instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$ParseJobStatusEnumEnumMap[instance.status]!,
  'sourceType': _$ParseJobSourceTypeEnumEnumMap[instance.sourceType]!,
  'errorCode': _$ParseJobErrorCodeEnumEnumMap[instance.errorCode],
  'result': instance.result?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'cooldownSeconds': instance.cooldownSeconds,
};

const _$ParseJobStatusEnumEnumMap = {
  ParseJobStatusEnum.queued: 'queued',
  ParseJobStatusEnum.running: 'running',
  ParseJobStatusEnum.succeeded: 'succeeded',
  ParseJobStatusEnum.failed: 'failed',
};

const _$ParseJobSourceTypeEnumEnumMap = {
  ParseJobSourceTypeEnum.url: 'url',
  ParseJobSourceTypeEnum.image: 'image',
};

const _$ParseJobErrorCodeEnumEnumMap = {
  ParseJobErrorCodeEnum.urlBlocked: 'url_blocked',
  ParseJobErrorCodeEnum.fetchFailed: 'fetch_failed',
  ParseJobErrorCodeEnum.notARecipe: 'not_a_recipe',
  ParseJobErrorCodeEnum.imageUnreadable: 'image_unreadable',
  ParseJobErrorCodeEnum.parserUnavailable: 'parser_unavailable',
  ParseJobErrorCodeEnum.internalError: 'internal_error',
};
