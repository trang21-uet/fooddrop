//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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

    required  this.text,

     this.timerSeconds,
  });

  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



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
      other.text == text &&
      other.timerSeconds == timerSeconds;

    @override
    int get hashCode =>
        text.hashCode +
        timerSeconds.hashCode;

  factory ParseJobResultStepsInner.fromJson(Map<String, dynamic> json) => _$ParseJobResultStepsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$ParseJobResultStepsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

