//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_ingredients_inner_ingredient.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailIngredientsInnerIngredient {
  /// Returns a new [RecipeDetailIngredientsInnerIngredient] instance.
  RecipeDetailIngredientsInnerIngredient({

    required  this.id,

    required  this.name,

    required  this.aisle,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'aisle',
    required: true,
    includeIfNull: false,
  )


  final RecipeDetailIngredientsInnerIngredientAisleEnum aisle;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailIngredientsInnerIngredient &&
      other.id == id &&
      other.name == name &&
      other.aisle == aisle;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        aisle.hashCode;

  factory RecipeDetailIngredientsInnerIngredient.fromJson(Map<String, dynamic> json) => _$RecipeDetailIngredientsInnerIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailIngredientsInnerIngredientToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RecipeDetailIngredientsInnerIngredientAisleEnum {
@JsonValue(r'produce')
produce(r'produce'),
@JsonValue(r'meat')
meat(r'meat'),
@JsonValue(r'seafood')
seafood(r'seafood'),
@JsonValue(r'dairy')
dairy(r'dairy'),
@JsonValue(r'pantry')
pantry(r'pantry'),
@JsonValue(r'spices')
spices(r'spices'),
@JsonValue(r'frozen')
frozen(r'frozen'),
@JsonValue(r'other')
other(r'other');

const RecipeDetailIngredientsInnerIngredientAisleEnum(this.value);

final String value;

@override
String toString() => value;
}


