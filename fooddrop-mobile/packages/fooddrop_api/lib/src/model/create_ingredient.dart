//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_ingredient.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateIngredient {
  /// Returns a new [CreateIngredient] instance.
  CreateIngredient({

    required  this.name,

     this.aliases,

     this.aisle,

     this.defaultUnit,

     this.densityGPerMl,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'aliases',
    required: false,
    includeIfNull: false,
  )


  final List<String>? aliases;



  @JsonKey(
    
    name: r'aisle',
    required: false,
    includeIfNull: false,
  )


  final CreateIngredientAisleEnum? aisle;



  @JsonKey(
    
    name: r'defaultUnit',
    required: false,
    includeIfNull: false,
  )


  final CreateIngredientDefaultUnitEnum? defaultUnit;



          // minimum: 0
          // maximum: 25
  @JsonKey(
    
    name: r'densityGPerMl',
    required: false,
    includeIfNull: false,
  )


  final num? densityGPerMl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateIngredient &&
      other.name == name &&
      other.aliases == aliases &&
      other.aisle == aisle &&
      other.defaultUnit == defaultUnit &&
      other.densityGPerMl == densityGPerMl;

    @override
    int get hashCode =>
        name.hashCode +
        aliases.hashCode +
        aisle.hashCode +
        defaultUnit.hashCode +
        (densityGPerMl == null ? 0 : densityGPerMl.hashCode);

  factory CreateIngredient.fromJson(Map<String, dynamic> json) => _$CreateIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$CreateIngredientToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CreateIngredientAisleEnum {
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

const CreateIngredientAisleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum CreateIngredientDefaultUnitEnum {
@JsonValue(r'g')
g(r'g'),
@JsonValue(r'ml')
ml(r'ml'),
@JsonValue(r'piece')
piece(r'piece');

const CreateIngredientDefaultUnitEnum(this.value);

final String value;

@override
String toString() => value;
}


