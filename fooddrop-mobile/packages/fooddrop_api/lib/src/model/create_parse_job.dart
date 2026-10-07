//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_parse_job.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateParseJob {
  /// Returns a new [CreateParseJob] instance.
  CreateParseJob({

     this.url,

     this.imageKey,
  });

  @JsonKey(
    
    name: r'url',
    required: false,
    includeIfNull: false,
  )


  final String? url;



  @JsonKey(
    
    name: r'imageKey',
    required: false,
    includeIfNull: false,
  )


  final String? imageKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateParseJob &&
      other.url == url &&
      other.imageKey == imageKey;

    @override
    int get hashCode =>
        url.hashCode +
        imageKey.hashCode;

  factory CreateParseJob.fromJson(Map<String, dynamic> json) => _$CreateParseJobFromJson(json);

  Map<String, dynamic> toJson() => _$CreateParseJobToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

