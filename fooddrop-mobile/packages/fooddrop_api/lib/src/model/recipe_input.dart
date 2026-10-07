//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/recipe_input_steps_inner.dart';
import 'package:fooddrop_api/src/model/recipe_input_ingredients_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_input.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeInput {
  /// Returns a new [RecipeInput] instance.
  RecipeInput({

    required  this.title,

     this.description,

     this.imageUrl,

     this.sourceUrl,

     this.baseServings = 2,

    required  this.totalMinutes,

    required  this.difficulty,

    required  this.steps,

     this.ingredients,

     this.tagIds,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'imageUrl',
    required: false,
    includeIfNull: false,
  )


  final String? imageUrl;



  @JsonKey(
    
    name: r'sourceUrl',
    required: false,
    includeIfNull: false,
  )


  final String? sourceUrl;



          // minimum: 1
          // maximum: 100
  @JsonKey(
    defaultValue: 2,
    name: r'baseServings',
    required: false,
    includeIfNull: false,
  )


  final int? baseServings;



          // minimum: 1
          // maximum: 10080
  @JsonKey(
    
    name: r'totalMinutes',
    required: true,
    includeIfNull: false,
  )


  final int totalMinutes;



          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'difficulty',
    required: true,
    includeIfNull: false,
  )


  final int difficulty;



  @JsonKey(
    
    name: r'steps',
    required: true,
    includeIfNull: false,
  )


  final List<RecipeInputStepsInner> steps;



  @JsonKey(
    
    name: r'ingredients',
    required: false,
    includeIfNull: false,
  )


  final List<RecipeInputIngredientsInner>? ingredients;



  @JsonKey(
    
    name: r'tagIds',
    required: false,
    includeIfNull: false,
  )


  final List<int>? tagIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeInput &&
      other.title == title &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.sourceUrl == sourceUrl &&
      other.baseServings == baseServings &&
      other.totalMinutes == totalMinutes &&
      other.difficulty == difficulty &&
      other.steps == steps &&
      other.ingredients == ingredients &&
      other.tagIds == tagIds;

    @override
    int get hashCode =>
        title.hashCode +
        (description == null ? 0 : description.hashCode) +
        (imageUrl == null ? 0 : imageUrl.hashCode) +
        (sourceUrl == null ? 0 : sourceUrl.hashCode) +
        baseServings.hashCode +
        totalMinutes.hashCode +
        difficulty.hashCode +
        steps.hashCode +
        ingredients.hashCode +
        tagIds.hashCode;

  factory RecipeInput.fromJson(Map<String, dynamic> json) => _$RecipeInputFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeInputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

