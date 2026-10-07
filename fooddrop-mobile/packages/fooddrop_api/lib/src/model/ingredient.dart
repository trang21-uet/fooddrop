//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Ingredient {
  /// Returns a new [Ingredient] instance.
  Ingredient({

    required  this.id,

    required  this.name,

    required  this.aliases,

    required  this.aisle,

    required  this.defaultUnit,

    required  this.densityGPerMl,

    required  this.isFermented,
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
    
    name: r'aliases',
    required: true,
    includeIfNull: false,
  )


  final List<String> aliases;



  @JsonKey(
    
    name: r'aisle',
    required: true,
    includeIfNull: false,
  )


  final IngredientAisleEnum aisle;



  @JsonKey(
    
    name: r'defaultUnit',
    required: true,
    includeIfNull: false,
  )


  final IngredientDefaultUnitEnum defaultUnit;



  @JsonKey(
    
    name: r'densityGPerMl',
    required: true,
    includeIfNull: true,
  )


  final num? densityGPerMl;



  @JsonKey(
    
    name: r'isFermented',
    required: true,
    includeIfNull: false,
  )


  final bool isFermented;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Ingredient &&
      other.id == id &&
      other.name == name &&
      other.aliases == aliases &&
      other.aisle == aisle &&
      other.defaultUnit == defaultUnit &&
      other.densityGPerMl == densityGPerMl &&
      other.isFermented == isFermented;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        aliases.hashCode +
        aisle.hashCode +
        defaultUnit.hashCode +
        (densityGPerMl == null ? 0 : densityGPerMl.hashCode) +
        isFermented.hashCode;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum IngredientAisleEnum {
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

const IngredientAisleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum IngredientDefaultUnitEnum {
@JsonValue(r'g')
g(r'g'),
@JsonValue(r'ml')
ml(r'ml'),
@JsonValue(r'piece')
piece(r'piece');

const IngredientDefaultUnitEnum(this.value);

final String value;

@override
String toString() => value;
}


