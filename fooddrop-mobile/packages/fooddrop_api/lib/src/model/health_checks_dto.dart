//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_checks_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthChecksDto {
  /// Returns a new [HealthChecksDto] instance.
  HealthChecksDto({

    required  this.postgres,

    required  this.redis,
  });

  @JsonKey(
    
    name: r'postgres',
    required: true,
    includeIfNull: false,
  )


  final HealthChecksDtoPostgresEnum postgres;



  @JsonKey(
    
    name: r'redis',
    required: true,
    includeIfNull: false,
  )


  final HealthChecksDtoRedisEnum redis;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HealthChecksDto &&
      other.postgres == postgres &&
      other.redis == redis;

    @override
    int get hashCode =>
        postgres.hashCode +
        redis.hashCode;

  factory HealthChecksDto.fromJson(Map<String, dynamic> json) => _$HealthChecksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HealthChecksDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HealthChecksDtoPostgresEnum {
@JsonValue(r'up')
up(r'up'),
@JsonValue(r'down')
down(r'down');

const HealthChecksDtoPostgresEnum(this.value);

final String value;

@override
String toString() => value;
}


enum HealthChecksDtoRedisEnum {
@JsonValue(r'up')
up(r'up'),
@JsonValue(r'down')
down(r'down');

const HealthChecksDtoRedisEnum(this.value);

final String value;

@override
String toString() => value;
}


