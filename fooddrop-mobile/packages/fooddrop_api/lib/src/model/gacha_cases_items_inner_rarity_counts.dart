//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_cases_items_inner_rarity_counts.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaCasesItemsInnerRarityCounts {
  /// Returns a new [GachaCasesItemsInnerRarityCounts] instance.
  GachaCasesItemsInnerRarityCounts({

    required  this.white,

    required  this.blue,

    required  this.purple,

    required  this.pink,

    required  this.red,
  });

          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'white',
    required: true,
    includeIfNull: false,
  )


  final int white;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'blue',
    required: true,
    includeIfNull: false,
  )


  final int blue;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'purple',
    required: true,
    includeIfNull: false,
  )


  final int purple;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'pink',
    required: true,
    includeIfNull: false,
  )


  final int pink;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'red',
    required: true,
    includeIfNull: false,
  )


  final int red;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaCasesItemsInnerRarityCounts &&
      other.white == white &&
      other.blue == blue &&
      other.purple == purple &&
      other.pink == pink &&
      other.red == red;

    @override
    int get hashCode =>
        white.hashCode +
        blue.hashCode +
        purple.hashCode +
        pink.hashCode +
        red.hashCode;

  factory GachaCasesItemsInnerRarityCounts.fromJson(Map<String, dynamic> json) => _$GachaCasesItemsInnerRarityCountsFromJson(json);

  Map<String, dynamic> toJson() => _$GachaCasesItemsInnerRarityCountsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

