//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/gacha_spin_result.dart';
import 'package:fooddrop_api/src/model/gacha_cases_items_inner_rarity_counts.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_cases_items_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaCasesItemsInner {
  /// Returns a new [GachaCasesItemsInner] instance.
  GachaCasesItemsInner({

    required  this.id,

    required  this.recipeCount,

    required  this.rarityCounts,

    required  this.preview,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final GachaCasesItemsInnerIdEnum id;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'recipeCount',
    required: true,
    includeIfNull: false,
  )


  final int recipeCount;



  @JsonKey(
    
    name: r'rarityCounts',
    required: true,
    includeIfNull: false,
  )


  final GachaCasesItemsInnerRarityCounts rarityCounts;



  @JsonKey(
    
    name: r'preview',
    required: true,
    includeIfNull: false,
  )


  final List<GachaSpinResult> preview;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaCasesItemsInner &&
      other.id == id &&
      other.recipeCount == recipeCount &&
      other.rarityCounts == rarityCounts &&
      other.preview == preview;

    @override
    int get hashCode =>
        id.hashCode +
        recipeCount.hashCode +
        rarityCounts.hashCode +
        preview.hashCode;

  factory GachaCasesItemsInner.fromJson(Map<String, dynamic> json) => _$GachaCasesItemsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$GachaCasesItemsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GachaCasesItemsInnerIdEnum {
@JsonValue(r'all')
all(r'all'),
@JsonValue(r'breakfast')
breakfast(r'breakfast'),
@JsonValue(r'lunch')
lunch(r'lunch'),
@JsonValue(r'dinner')
dinner(r'dinner'),
@JsonValue(r'quick')
quick(r'quick'),
@JsonValue(r'epic')
epic(r'epic');

const GachaCasesItemsInnerIdEnum(this.value);

final String value;

@override
String toString() => value;
}


