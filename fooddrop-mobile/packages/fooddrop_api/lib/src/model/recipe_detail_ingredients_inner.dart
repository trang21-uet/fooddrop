//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_ingredient.dart';
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
    includeIfNull: false,
  )


  final num quantity;



  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: false,
  )


  final RecipeDetailIngredientsInnerUnitEnum unit;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailIngredientsInner &&
      other.ingredient == ingredient &&
      other.quantity == quantity &&
      other.unit == unit &&
      other.note == note;

    @override
    int get hashCode =>
        ingredient.hashCode +
        quantity.hashCode +
        unit.hashCode +
        (note == null ? 0 : note.hashCode);

  factory RecipeDetailIngredientsInner.fromJson(Map<String, dynamic> json) => _$RecipeDetailIngredientsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailIngredientsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RecipeDetailIngredientsInnerUnitEnum {
@JsonValue(r'g')
g(r'g'),
@JsonValue(r'ml')
ml(r'ml'),
@JsonValue(r'piece')
piece(r'piece');

const RecipeDetailIngredientsInnerUnitEnum(this.value);

final String value;

@override
String toString() => value;
}


