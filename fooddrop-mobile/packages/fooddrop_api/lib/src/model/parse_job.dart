//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/parse_job_result.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parse_job.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ParseJob {
  /// Returns a new [ParseJob] instance.
  ParseJob({

    required  this.id,

    required  this.status,

    required  this.sourceType,

    required  this.errorCode,

    required  this.result,

    required  this.createdAt,

    required  this.cooldownSeconds,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final ParseJobStatusEnum status;



  @JsonKey(
    
    name: r'sourceType',
    required: true,
    includeIfNull: false,
  )


  final ParseJobSourceTypeEnum sourceType;



  @JsonKey(
    
    name: r'errorCode',
    required: true,
    includeIfNull: true,
  )


  final ParseJobErrorCodeEnum? errorCode;



  @JsonKey(
    
    name: r'result',
    required: true,
    includeIfNull: true,
  )


  final ParseJobResult? result;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



          // minimum: 0
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'cooldownSeconds',
    required: true,
    includeIfNull: false,
  )


  final int cooldownSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ParseJob &&
      other.id == id &&
      other.status == status &&
      other.sourceType == sourceType &&
      other.errorCode == errorCode &&
      other.result == result &&
      other.createdAt == createdAt &&
      other.cooldownSeconds == cooldownSeconds;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        sourceType.hashCode +
        (errorCode == null ? 0 : errorCode.hashCode) +
        (result == null ? 0 : result.hashCode) +
        createdAt.hashCode +
        cooldownSeconds.hashCode;

  factory ParseJob.fromJson(Map<String, dynamic> json) => _$ParseJobFromJson(json);

  Map<String, dynamic> toJson() => _$ParseJobToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ParseJobStatusEnum {
@JsonValue(r'queued')
queued(r'queued'),
@JsonValue(r'running')
running(r'running'),
@JsonValue(r'succeeded')
succeeded(r'succeeded'),
@JsonValue(r'failed')
failed(r'failed');

const ParseJobStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ParseJobSourceTypeEnum {
@JsonValue(r'url')
url(r'url'),
@JsonValue(r'image')
image(r'image');

const ParseJobSourceTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ParseJobErrorCodeEnum {
@JsonValue(r'url_blocked')
urlBlocked(r'url_blocked'),
@JsonValue(r'fetch_failed')
fetchFailed(r'fetch_failed'),
@JsonValue(r'not_a_recipe')
notARecipe(r'not_a_recipe'),
@JsonValue(r'image_unreadable')
imageUnreadable(r'image_unreadable'),
@JsonValue(r'parser_unavailable')
parserUnavailable(r'parser_unavailable'),
@JsonValue(r'internal_error')
internalError(r'internal_error');

const ParseJobErrorCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


