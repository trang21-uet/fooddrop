// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_checks_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HealthChecksDtoCWProxy {
  HealthChecksDto postgres(HealthChecksDtoPostgresEnum postgres);

  HealthChecksDto redis(HealthChecksDtoRedisEnum redis);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthChecksDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthChecksDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthChecksDto call({
    HealthChecksDtoPostgresEnum postgres,
    HealthChecksDtoRedisEnum redis,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHealthChecksDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHealthChecksDto.copyWith.fieldName(...)`
class _$HealthChecksDtoCWProxyImpl implements _$HealthChecksDtoCWProxy {
  const _$HealthChecksDtoCWProxyImpl(this._value);

  final HealthChecksDto _value;

  @override
  HealthChecksDto postgres(HealthChecksDtoPostgresEnum postgres) =>
      this(postgres: postgres);

  @override
  HealthChecksDto redis(HealthChecksDtoRedisEnum redis) => this(redis: redis);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthChecksDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthChecksDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthChecksDto call({
    Object? postgres = const $CopyWithPlaceholder(),
    Object? redis = const $CopyWithPlaceholder(),
  }) {
    return HealthChecksDto(
      postgres: postgres == const $CopyWithPlaceholder()
          ? _value.postgres
          // ignore: cast_nullable_to_non_nullable
          : postgres as HealthChecksDtoPostgresEnum,
      redis: redis == const $CopyWithPlaceholder()
          ? _value.redis
          // ignore: cast_nullable_to_non_nullable
          : redis as HealthChecksDtoRedisEnum,
    );
  }
}

extension $HealthChecksDtoCopyWith on HealthChecksDto {
  /// Returns a callable class that can be used as follows: `instanceOfHealthChecksDto.copyWith(...)` or like so:`instanceOfHealthChecksDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HealthChecksDtoCWProxy get copyWith => _$HealthChecksDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthChecksDto _$HealthChecksDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HealthChecksDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['postgres', 'redis']);
      final val = HealthChecksDto(
        postgres: $checkedConvert(
          'postgres',
          (v) => $enumDecode(_$HealthChecksDtoPostgresEnumEnumMap, v),
        ),
        redis: $checkedConvert(
          'redis',
          (v) => $enumDecode(_$HealthChecksDtoRedisEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HealthChecksDtoToJson(HealthChecksDto instance) =>
    <String, dynamic>{
      'postgres': _$HealthChecksDtoPostgresEnumEnumMap[instance.postgres]!,
      'redis': _$HealthChecksDtoRedisEnumEnumMap[instance.redis]!,
    };

const _$HealthChecksDtoPostgresEnumEnumMap = {
  HealthChecksDtoPostgresEnum.up: 'up',
  HealthChecksDtoPostgresEnum.down: 'down',
};

const _$HealthChecksDtoRedisEnumEnumMap = {
  HealthChecksDtoRedisEnum.up: 'up',
  HealthChecksDtoRedisEnum.down: 'down',
};
