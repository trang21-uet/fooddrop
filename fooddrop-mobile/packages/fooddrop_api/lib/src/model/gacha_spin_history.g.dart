// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_spin_history.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaSpinHistoryCWProxy {
  GachaSpinHistory items(List<GachaSpinHistoryItemsInner> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinHistory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinHistory(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinHistory call({List<GachaSpinHistoryItemsInner> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaSpinHistory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaSpinHistory.copyWith.fieldName(...)`
class _$GachaSpinHistoryCWProxyImpl implements _$GachaSpinHistoryCWProxy {
  const _$GachaSpinHistoryCWProxyImpl(this._value);

  final GachaSpinHistory _value;

  @override
  GachaSpinHistory items(List<GachaSpinHistoryItemsInner> items) =>
      this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinHistory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinHistory(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinHistory call({Object? items = const $CopyWithPlaceholder()}) {
    return GachaSpinHistory(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<GachaSpinHistoryItemsInner>,
    );
  }
}

extension $GachaSpinHistoryCopyWith on GachaSpinHistory {
  /// Returns a callable class that can be used as follows: `instanceOfGachaSpinHistory.copyWith(...)` or like so:`instanceOfGachaSpinHistory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaSpinHistoryCWProxy get copyWith => _$GachaSpinHistoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaSpinHistory _$GachaSpinHistoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GachaSpinHistory', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = GachaSpinHistory(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map(
                (e) => GachaSpinHistoryItemsInner.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GachaSpinHistoryToJson(GachaSpinHistory instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
