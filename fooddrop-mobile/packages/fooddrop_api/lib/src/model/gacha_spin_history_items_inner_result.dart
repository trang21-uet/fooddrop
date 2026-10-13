//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_spin_history_items_inner_result.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaSpinHistoryItemsInnerResult {
  /// Returns a new [GachaSpinHistoryItemsInnerResult] instance.
  GachaSpinHistoryItemsInnerResult({

    required  this.id,

    required  this.title,

    required  this.imageUrl,

    required  this.rarity,

    required  this.totalMinutes,

    required  this.difficulty,

    required  this.baseServings,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'imageUrl',
    required: true,
    includeIfNull: true,
  )


  final String? imageUrl;



  @JsonKey(
    
    name: r'rarity',
    required: true,
    includeIfNull: false,
  )


  final GachaSpinHistoryItemsInnerResultRarityEnum rarity;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'totalMinutes',
    required: true,
    includeIfNull: false,
  )


  final int totalMinutes;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'difficulty',
    required: true,
    includeIfNull: false,
  )


  final int difficulty;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'baseServings',
    required: true,
    includeIfNull: false,
  )


  final int baseServings;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaSpinHistoryItemsInnerResult &&
      other.id == id &&
      other.title == title &&
      other.imageUrl == imageUrl &&
      other.rarity == rarity &&
      other.totalMinutes == totalMinutes &&
      other.difficulty == difficulty &&
      other.baseServings == baseServings;

    @override
    int get hashCode =>
        id.hashCode +
        title.hashCode +
        (imageUrl == null ? 0 : imageUrl.hashCode) +
        rarity.hashCode +
        totalMinutes.hashCode +
        difficulty.hashCode +
        baseServings.hashCode;

  factory GachaSpinHistoryItemsInnerResult.fromJson(Map<String, dynamic> json) => _$GachaSpinHistoryItemsInnerResultFromJson(json);

  Map<String, dynamic> toJson() => _$GachaSpinHistoryItemsInnerResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GachaSpinHistoryItemsInnerResultRarityEnum {
@JsonValue(r'white')
white(r'white'),
@JsonValue(r'blue')
blue(r'blue'),
@JsonValue(r'purple')
purple(r'purple'),
@JsonValue(r'pink')
pink(r'pink'),
@JsonValue(r'red')
red(r'red');

const GachaSpinHistoryItemsInnerResultRarityEnum(this.value);

final String value;

@override
String toString() => value;
}


