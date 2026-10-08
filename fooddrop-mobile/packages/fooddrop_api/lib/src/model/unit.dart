//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unit.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Unit {
  /// Returns a new [Unit] instance.
  Unit({

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


  final UnitKindEnum kind;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Unit &&
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

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UnitKindEnum {
@JsonValue(r'mass')
mass(r'mass'),
@JsonValue(r'volume')
volume(r'volume'),
@JsonValue(r'count')
count(r'count'),
@JsonValue(r'other')
other(r'other');

const UnitKindEnum(this.value);

final String value;

@override
String toString() => value;
}


