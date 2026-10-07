//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_target.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadTarget {
  /// Returns a new [UploadTarget] instance.
  UploadTarget({

    required  this.key,

    required  this.uploadUrl,

    required  this.headers,

    required  this.expiresInSeconds,
  });

  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;



  @JsonKey(
    
    name: r'uploadUrl',
    required: true,
    includeIfNull: false,
  )


  final String uploadUrl;



  @JsonKey(
    
    name: r'headers',
    required: true,
    includeIfNull: false,
  )


  final Map<String, String> headers;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'expiresInSeconds',
    required: true,
    includeIfNull: false,
  )


  final int expiresInSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UploadTarget &&
      other.key == key &&
      other.uploadUrl == uploadUrl &&
      other.headers == headers &&
      other.expiresInSeconds == expiresInSeconds;

    @override
    int get hashCode =>
        key.hashCode +
        uploadUrl.hashCode +
        headers.hashCode +
        expiresInSeconds.hashCode;

  factory UploadTarget.fromJson(Map<String, dynamic> json) => _$UploadTargetFromJson(json);

  Map<String, dynamic> toJson() => _$UploadTargetToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

