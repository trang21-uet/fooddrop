//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/gacha_cases_items_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_cases.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaCases {
  /// Returns a new [GachaCases] instance.
  GachaCases({

    required  this.items,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<GachaCasesItemsInner> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaCases &&
      other.items == items;

    @override
    int get hashCode =>
        items.hashCode;

  factory GachaCases.fromJson(Map<String, dynamic> json) => _$GachaCasesFromJson(json);

  Map<String, dynamic> toJson() => _$GachaCasesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

