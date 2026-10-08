//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_input_ingredients_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeInputIngredientsInner {
  /// Returns a new [RecipeInputIngredientsInner] instance.
  RecipeInputIngredientsInner({

    required  this.ingredientId,

     this.quantity,

     this.unit,

     this.note,
  });

  @JsonKey(
    
    name: r'ingredientId',
    required: true,
    includeIfNull: false,
  )


  final String ingredientId;



  @JsonKey(
    
    name: r'quantity',
    required: false,
    includeIfNull: false,
  )


  final String? quantity;



  @JsonKey(
    
    name: r'unit',
    required: false,
    includeIfNull: false,
  )


  final String? unit;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeInputIngredientsInner &&
      other.ingredientId == ingredientId &&
      other.quantity == quantity &&
      other.unit == unit &&
      other.note == note;

    @override
    int get hashCode =>
        ingredientId.hashCode +
        (quantity == null ? 0 : quantity.hashCode) +
        (unit == null ? 0 : unit.hashCode) +
        (note == null ? 0 : note.hashCode);

  factory RecipeInputIngredientsInner.fromJson(Map<String, dynamic> json) => _$RecipeInputIngredientsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeInputIngredientsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

