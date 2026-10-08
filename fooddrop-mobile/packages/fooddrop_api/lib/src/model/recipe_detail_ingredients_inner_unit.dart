//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_ingredients_inner_unit.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailIngredientsInnerUnit {
  /// Returns a new [RecipeDetailIngredientsInnerUnit] instance.
  RecipeDetailIngredientsInnerUnit({

    required  this.code,

    required  this.nameVi,

    required  this.nameEn,

    required  this.kind,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'nameVi',
    required: true,
    includeIfNull: false,
  )


  final String nameVi;



  @JsonKey(
    
    name: r'nameEn',
    required: true,
    includeIfNull: false,
  )


  final String nameEn;



  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final RecipeDetailIngredientsInnerUnitKindEnum kind;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailIngredientsInnerUnit &&
      other.code == code &&
      other.nameVi == nameVi &&
      other.nameEn == nameEn &&
      other.kind == kind;

    @override
    int get hashCode =>
        code.hashCode +
        nameVi.hashCode +
        nameEn.hashCode +
        kind.hashCode;

  factory RecipeDetailIngredientsInnerUnit.fromJson(Map<String, dynamic> json) => _$RecipeDetailIngredientsInnerUnitFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailIngredientsInnerUnitToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RecipeDetailIngredientsInnerUnitKindEnum {
@JsonValue(r'mass')
mass(r'mass'),
@JsonValue(r'volume')
volume(r'volume'),
@JsonValue(r'count')
count(r'count'),
@JsonValue(r'other')
other(r'other');

const RecipeDetailIngredientsInnerUnitKindEnum(this.value);

final String value;

@override
String toString() => value;
}


