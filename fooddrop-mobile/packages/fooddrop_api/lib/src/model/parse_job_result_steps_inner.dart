//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/parse_job_result_steps_inner_images_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parse_job_result_steps_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ParseJobResultStepsInner {
  /// Returns a new [ParseJobResultStepsInner] instance.
  ParseJobResultStepsInner({

    required  this.name,

    required  this.text,

    required  this.note,

    required  this.images,

     this.timerSeconds,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: true,
  )


  final String? name;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



  @JsonKey(
    
    name: r'images',
    required: true,
    includeIfNull: false,
  )


  final List<ParseJobResultStepsInnerImagesInner> images;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'timerSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? timerSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ParseJobResultStepsInner &&
      other.name == name &&
      other.text == text &&
      other.note == note &&
      other.images == images &&
      other.timerSeconds == timerSeconds;

    @override
    int get hashCode =>
        (name == null ? 0 : name.hashCode) +
        text.hashCode +
        (note == null ? 0 : note.hashCode) +
        images.hashCode +
        timerSeconds.hashCode;

  factory ParseJobResultStepsInner.fromJson(Map<String, dynamic> json) => _$ParseJobResultStepsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$ParseJobResultStepsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

