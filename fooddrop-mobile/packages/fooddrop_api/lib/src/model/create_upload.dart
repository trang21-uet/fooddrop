//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_upload.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateUpload {
  /// Returns a new [CreateUpload] instance.
  CreateUpload({

     this.purpose,

    required  this.contentType,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'purpose',
    required: false,
    includeIfNull: false,
  )


  final CreateUploadPurposeEnum? purpose;



  @JsonKey(
    
    name: r'contentType',
    required: true,
    includeIfNull: false,
  )


  final CreateUploadContentTypeEnum contentType;



          // minimum: 1
          // maximum: 5242880
  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final int sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateUpload &&
      other.purpose == purpose &&
      other.contentType == contentType &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        purpose.hashCode +
        contentType.hashCode +
        sizeBytes.hashCode;

  factory CreateUpload.fromJson(Map<String, dynamic> json) => _$CreateUploadFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUploadToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CreateUploadPurposeEnum {
@JsonValue(r'parser')
parser(r'parser'),
@JsonValue(r'recipe-step')
recipeStep(r'recipe-step');

const CreateUploadPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum CreateUploadContentTypeEnum {
@JsonValue(r'image/jpeg')
imageSlashJpeg(r'image/jpeg'),
@JsonValue(r'image/png')
imageSlashPng(r'image/png'),
@JsonValue(r'image/webp')
imageSlashWebp(r'image/webp');

const CreateUploadContentTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


