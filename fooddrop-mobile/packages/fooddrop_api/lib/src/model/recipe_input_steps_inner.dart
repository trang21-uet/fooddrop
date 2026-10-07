//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_input_steps_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeInputStepsInner {
  /// Returns a new [RecipeInputStepsInner] instance.
  RecipeInputStepsInner({

    required  this.text,

     this.timerSeconds,

     this.timerLabel,
  });

  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



          // minimum: 1
          // maximum: 86400
  @JsonKey(
    
    name: r'timerSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? timerSeconds;



  @JsonKey(
    
    name: r'timerLabel',
    required: false,
    includeIfNull: false,
  )


  final String? timerLabel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeInputStepsInner &&
      other.text == text &&
      other.timerSeconds == timerSeconds &&
      other.timerLabel == timerLabel;

    @override
    int get hashCode =>
        text.hashCode +
        timerSeconds.hashCode +
        timerLabel.hashCode;

  factory RecipeInputStepsInner.fromJson(Map<String, dynamic> json) => _$RecipeInputStepsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeInputStepsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

