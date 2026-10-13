//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/gacha_spin_result.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_spin.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaSpin {
  /// Returns a new [GachaSpin] instance.
  GachaSpin({

    required  this.spinId,

    required  this.caseType,

    required  this.createdAt,

    required  this.result,

    required  this.reel,

    required  this.winningIndex,

    required  this.offsetJitter,

    required  this.poolSize,
  });

  @JsonKey(
    
    name: r'spinId',
    required: true,
    includeIfNull: false,
  )


  final String spinId;



  @JsonKey(
    
    name: r'caseType',
    required: true,
    includeIfNull: false,
  )


  final GachaSpinCaseTypeEnum caseType;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'result',
    required: true,
    includeIfNull: false,
  )


  final GachaSpinResult result;



  @JsonKey(
    
    name: r'reel',
    required: true,
    includeIfNull: false,
  )


  final List<GachaSpinResult> reel;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'winningIndex',
    required: true,
    includeIfNull: false,
  )


  final int winningIndex;



  @JsonKey(
    
    name: r'offsetJitter',
    required: true,
    includeIfNull: false,
  )


  final num offsetJitter;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'poolSize',
    required: true,
    includeIfNull: false,
  )


  final int poolSize;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaSpin &&
      other.spinId == spinId &&
      other.caseType == caseType &&
      other.createdAt == createdAt &&
      other.result == result &&
      other.reel == reel &&
      other.winningIndex == winningIndex &&
      other.offsetJitter == offsetJitter &&
      other.poolSize == poolSize;

    @override
    int get hashCode =>
        spinId.hashCode +
        caseType.hashCode +
        createdAt.hashCode +
        result.hashCode +
        reel.hashCode +
        winningIndex.hashCode +
        offsetJitter.hashCode +
        poolSize.hashCode;

  factory GachaSpin.fromJson(Map<String, dynamic> json) => _$GachaSpinFromJson(json);

  Map<String, dynamic> toJson() => _$GachaSpinToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GachaSpinCaseTypeEnum {
@JsonValue(r'cook')
cook(r'cook');

const GachaSpinCaseTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


