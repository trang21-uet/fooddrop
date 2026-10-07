//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_steps_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailStepsInner {
  /// Returns a new [RecipeDetailStepsInner] instance.
  RecipeDetailStepsInner({

    required  this.order,

    required  this.text,

     this.timerSeconds,

     this.timerLabel,
  });

          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'order',
    required: true,
    includeIfNull: false,
  )


  final int order;



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



  @JsonKey(
    
    name: r'timerLabel',
    required: false,
    includeIfNull: false,
  )


  final String? timerLabel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailStepsInner &&
      other.order == order &&
      other.text == text &&
      other.timerSeconds == timerSeconds &&
      other.timerLabel == timerLabel;

    @override
    int get hashCode =>
        order.hashCode +
        text.hashCode +
        timerSeconds.hashCode +
        timerLabel.hashCode;

  factory RecipeDetailStepsInner.fromJson(Map<String, dynamic> json) => _$RecipeDetailStepsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailStepsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

