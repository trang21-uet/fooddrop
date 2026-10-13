//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_error.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaError {
  /// Returns a new [GachaError] instance.
  GachaError({

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


  final GachaErrorCodeEnum code;



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
    bool operator ==(Object other) => identical(this, other) || other is GachaError &&
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

  factory GachaError.fromJson(Map<String, dynamic> json) => _$GachaErrorFromJson(json);

  Map<String, dynamic> toJson() => _$GachaErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GachaErrorCodeEnum {
@JsonValue(r'gacha_rate_limit')
gachaRateLimit(r'gacha_rate_limit'),
@JsonValue(r'gacha_empty_pool')
gachaEmptyPool(r'gacha_empty_pool');

const GachaErrorCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


