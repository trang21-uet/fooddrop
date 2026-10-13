// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_cases.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaCasesCWProxy {
  GachaCases items(List<GachaCasesItemsInner> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaCases(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaCases(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaCases call({List<GachaCasesItemsInner> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaCases.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaCases.copyWith.fieldName(...)`
class _$GachaCasesCWProxyImpl implements _$GachaCasesCWProxy {
  const _$GachaCasesCWProxyImpl(this._value);

  final GachaCases _value;

  @override
  GachaCases items(List<GachaCasesItemsInner> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaCases(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaCases(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaCases call({Object? items = const $CopyWithPlaceholder()}) {
    return GachaCases(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<GachaCasesItemsInner>,
    );
  }
}

extension $GachaCasesCopyWith on GachaCases {
  /// Returns a callable class that can be used as follows: `instanceOfGachaCases.copyWith(...)` or like so:`instanceOfGachaCases.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaCasesCWProxy get copyWith => _$GachaCasesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaCases _$GachaCasesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GachaCases', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = GachaCases(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map(
                (e) => GachaCasesItemsInner.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GachaCasesToJson(GachaCases instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
