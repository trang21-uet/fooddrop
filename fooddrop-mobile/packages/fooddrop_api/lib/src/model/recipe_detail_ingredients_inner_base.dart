//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_ingredients_inner_base.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailIngredientsInnerBase {
  /// Returns a new [RecipeDetailIngredientsInnerBase] instance.
  RecipeDetailIngredientsInnerBase({

    required  this.quantity,

    required  this.unit,
  });

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


  final RecipeDetailIngredientsInnerBaseUnitEnum unit;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailIngredientsInnerBase &&
      other.quantity == quantity &&
      other.unit == unit;

    @override
    int get hashCode =>
        quantity.hashCode +
        unit.hashCode;

  factory RecipeDetailIngredientsInnerBase.fromJson(Map<String, dynamic> json) => _$RecipeDetailIngredientsInnerBaseFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailIngredientsInnerBaseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RecipeDetailIngredientsInnerBaseUnitEnum {
@JsonValue(r'g')
g(r'g'),
@JsonValue(r'ml')
ml(r'ml'),
@JsonValue(r'piece')
piece(r'piece');

const RecipeDetailIngredientsInnerBaseUnitEnum(this.value);

final String value;

@override
String toString() => value;
}


