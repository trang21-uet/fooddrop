//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/recipe_detail_steps_inner_images_inner.dart';
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

     this.name,

    required  this.text,

    required  this.images,

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
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



  @JsonKey(
    
    name: r'images',
    required: true,
    includeIfNull: false,
  )


  final List<RecipeDetailStepsInnerImagesInner> images;



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
      other.name == name &&
      other.text == text &&
      other.images == images &&
      other.timerSeconds == timerSeconds &&
      other.timerLabel == timerLabel;

    @override
    int get hashCode =>
        order.hashCode +
        name.hashCode +
        text.hashCode +
        images.hashCode +
        timerSeconds.hashCode +
        timerLabel.hashCode;

  factory RecipeDetailStepsInner.fromJson(Map<String, dynamic> json) => _$RecipeDetailStepsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailStepsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

