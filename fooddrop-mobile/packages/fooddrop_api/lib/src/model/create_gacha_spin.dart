//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_gacha_spin.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGachaSpin {
  /// Returns a new [CreateGachaSpin] instance.
  CreateGachaSpin({

    required  this.caseType,

    required  this.caseId,
  });

  @JsonKey(
    
    name: r'caseType',
    required: true,
    includeIfNull: false,
  )


  final CreateGachaSpinCaseTypeEnum caseType;



  @JsonKey(
    
    name: r'caseId',
    required: true,
    includeIfNull: false,
  )


  final String caseId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateGachaSpin &&
      other.caseType == caseType &&
      other.caseId == caseId;

    @override
    int get hashCode =>
        caseType.hashCode +
        caseId.hashCode;

  factory CreateGachaSpin.fromJson(Map<String, dynamic> json) => _$CreateGachaSpinFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGachaSpinToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CreateGachaSpinCaseTypeEnum {
@JsonValue(r'cook')
cook(r'cook');

const CreateGachaSpinCaseTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


