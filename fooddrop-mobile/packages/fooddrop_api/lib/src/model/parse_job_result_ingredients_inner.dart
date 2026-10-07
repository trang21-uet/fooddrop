//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parse_job_result_ingredients_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ParseJobResultIngredientsInner {
  /// Returns a new [ParseJobResultIngredientsInner] instance.
  ParseJobResultIngredientsInner({

    required  this.name,

    required  this.quantity,

    required  this.unit,

    required  this.note,

    required  this.matchedName,

    required  this.ingredientId,

    required  this.isNew,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



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


  final ParseJobResultIngredientsInnerUnitEnum unit;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



  @JsonKey(
    
    name: r'matchedName',
    required: true,
    includeIfNull: true,
  )


  final String? matchedName;



  @JsonKey(
    
    name: r'ingredientId',
    required: true,
    includeIfNull: true,
  )


  final String? ingredientId;



  @JsonKey(
    
    name: r'isNew',
    required: true,
    includeIfNull: false,
  )


  final bool isNew;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ParseJobResultIngredientsInner &&
      other.name == name &&
      other.quantity == quantity &&
      other.unit == unit &&
      other.note == note &&
      other.matchedName == matchedName &&
      other.ingredientId == ingredientId &&
      other.isNew == isNew;

    @override
    int get hashCode =>
        name.hashCode +
        quantity.hashCode +
        unit.hashCode +
        (note == null ? 0 : note.hashCode) +
        (matchedName == null ? 0 : matchedName.hashCode) +
        (ingredientId == null ? 0 : ingredientId.hashCode) +
        isNew.hashCode;

  factory ParseJobResultIngredientsInner.fromJson(Map<String, dynamic> json) => _$ParseJobResultIngredientsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$ParseJobResultIngredientsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ParseJobResultIngredientsInnerUnitEnum {
@JsonValue(r'g')
g(r'g'),
@JsonValue(r'ml')
ml(r'ml'),
@JsonValue(r'piece')
piece(r'piece');

const ParseJobResultIngredientsInnerUnitEnum(this.value);

final String value;

@override
String toString() => value;
}


