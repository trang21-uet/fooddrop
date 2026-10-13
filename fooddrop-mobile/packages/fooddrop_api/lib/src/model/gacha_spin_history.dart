//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/gacha_spin_history_items_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gacha_spin_history.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GachaSpinHistory {
  /// Returns a new [GachaSpinHistory] instance.
  GachaSpinHistory({

    required  this.items,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<GachaSpinHistoryItemsInner> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GachaSpinHistory &&
      other.items == items;

    @override
    int get hashCode =>
        items.hashCode;

  factory GachaSpinHistory.fromJson(Map<String, dynamic> json) => _$GachaSpinHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$GachaSpinHistoryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

