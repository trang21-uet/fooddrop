//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/gacha_spin_history_items_inner_result.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_spin_history_items_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaSpinHistoryItemsInner {
  /// Returns a new [GachaSpinHistoryItemsInner] instance.
  GachaSpinHistoryItemsInner({

    required  this.id,

    required  this.caseType,

    required  this.createdAt,

    required  this.result,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'caseType',
    required: true,
    includeIfNull: false,
  )


  final GachaSpinHistoryItemsInnerCaseTypeEnum caseType;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'result',
    required: true,
    includeIfNull: true,
  )


  final GachaSpinHistoryItemsInnerResult? result;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaSpinHistoryItemsInner &&
      other.id == id &&
      other.caseType == caseType &&
      other.createdAt == createdAt &&
      other.result == result;

    @override
    int get hashCode =>
        id.hashCode +
        caseType.hashCode +
        createdAt.hashCode +
        (result == null ? 0 : result.hashCode);

  factory GachaSpinHistoryItemsInner.fromJson(Map<String, dynamic> json) => _$GachaSpinHistoryItemsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$GachaSpinHistoryItemsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GachaSpinHistoryItemsInnerCaseTypeEnum {
@JsonValue(r'cook')
cook(r'cook');

const GachaSpinHistoryItemsInnerCaseTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


