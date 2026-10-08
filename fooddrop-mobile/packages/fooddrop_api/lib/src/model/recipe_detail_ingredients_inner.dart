//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_base.dart';
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_ingredient.dart';
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_unit.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_ingredients_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailIngredientsInner {
  /// Returns a new [RecipeDetailIngredientsInner] instance.
  RecipeDetailIngredientsInner({

    required  this.ingredient,

    required  this.quantity,

    required  this.unit,

    required  this.note,

    required  this.base_,
  });

  @JsonKey(
    
    name: r'ingredient',
    required: true,
    includeIfNull: false,
  )


  final RecipeDetailIngredientsInnerIngredient ingredient;



  @JsonKey(
    
    name: r'quantity',
    required: true,
    includeIfNull: true,
  )


  final num? quantity;



  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: true,
  )


  final RecipeDetailIngredientsInnerUnit? unit;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



  @JsonKey(
    
    name: r'base',
    required: true,
    includeIfNull: false,
  )


  final RecipeDetailIngredientsInnerBase base_;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailIngredientsInner &&
      other.ingredient == ingredient &&
      other.quantity == quantity &&
      other.unit == unit &&
      other.note == note &&
      other.base_ == base_;

    @override
    int get hashCode =>
        ingredient.hashCode +
        (quantity == null ? 0 : quantity.hashCode) +
        (unit == null ? 0 : unit.hashCode) +
        (note == null ? 0 : note.hashCode) +
        base_.hashCode;

  factory RecipeDetailIngredientsInner.fromJson(Map<String, dynamic> json) => _$RecipeDetailIngredientsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailIngredientsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

