//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parse_rate_limit_error.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ParseRateLimitError {
  /// Returns a new [ParseRateLimitError] instance.
  ParseRateLimitError({

    required  this.statusCode,

    required  this.code,

    required  this.message,

     this.retryAfterSeconds,
  });

          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'statusCode',
    required: true,
    includeIfNull: false,
  )


  final int statusCode;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final ParseRateLimitErrorCodeEnum code;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;



          // minimum: 0
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'retryAfterSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? retryAfterSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ParseRateLimitError &&
      other.statusCode == statusCode &&
      other.code == code &&
      other.message == message &&
      other.retryAfterSeconds == retryAfterSeconds;

    @override
    int get hashCode =>
        statusCode.hashCode +
        code.hashCode +
        message.hashCode +
        retryAfterSeconds.hashCode;

  factory ParseRateLimitError.fromJson(Map<String, dynamic> json) => _$ParseRateLimitErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ParseRateLimitErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ParseRateLimitErrorCodeEnum {
@JsonValue(r'parse_cooldown')
parseCooldown(r'parse_cooldown'),
@JsonValue(r'parse_daily_quota')
parseDailyQuota(r'parse_daily_quota');

const ParseRateLimitErrorCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


