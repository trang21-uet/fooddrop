// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_cases_items_inner_rarity_counts.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaCasesItemsInnerRarityCountsCWProxy {
  GachaCasesItemsInnerRarityCounts white(int white);

  GachaCasesItemsInnerRarityCounts blue(int blue);

  GachaCasesItemsInnerRarityCounts purple(int purple);

  GachaCasesItemsInnerRarityCounts pink(int pink);

  GachaCasesItemsInnerRarityCounts red(int red);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaCasesItemsInnerRarityCounts(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaCasesItemsInnerRarityCounts(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaCasesItemsInnerRarityCounts call({
    int white,
    int blue,
    int purple,
    int pink,
    int red,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaCasesItemsInnerRarityCounts.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaCasesItemsInnerRarityCounts.copyWith.fieldName(...)`
class _$GachaCasesItemsInnerRarityCountsCWProxyImpl
    implements _$GachaCasesItemsInnerRarityCountsCWProxy {
  const _$GachaCasesItemsInnerRarityCountsCWProxyImpl(this._value);

  final GachaCasesItemsInnerRarityCounts _value;

  @override
  GachaCasesItemsInnerRarityCounts white(int white) => this(white: white);

  @override
  GachaCasesItemsInnerRarityCounts blue(int blue) => this(blue: blue);

  @override
  GachaCasesItemsInnerRarityCounts purple(int purple) => this(purple: purple);

  @override
  GachaCasesItemsInnerRarityCounts pink(int pink) => this(pink: pink);

  @override
  GachaCasesItemsInnerRarityCounts red(int red) => this(red: red);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaCasesItemsInnerRarityCounts(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaCasesItemsInnerRarityCounts(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaCasesItemsInnerRarityCounts call({
    Object? white = const $CopyWithPlaceholder(),
    Object? blue = const $CopyWithPlaceholder(),
    Object? purple = const $CopyWithPlaceholder(),
    Object? pink = const $CopyWithPlaceholder(),
    Object? red = const $CopyWithPlaceholder(),
  }) {
    return GachaCasesItemsInnerRarityCounts(
      white: white == const $CopyWithPlaceholder()
          ? _value.white
          // ignore: cast_nullable_to_non_nullable
          : white as int,
      blue: blue == const $CopyWithPlaceholder()
          ? _value.blue
          // ignore: cast_nullable_to_non_nullable
          : blue as int,
      purple: purple == const $CopyWithPlaceholder()
          ? _value.purple
          // ignore: cast_nullable_to_non_nullable
          : purple as int,
      pink: pink == const $CopyWithPlaceholder()
          ? _value.pink
          // ignore: cast_nullable_to_non_nullable
          : pink as int,
      red: red == const $CopyWithPlaceholder()
          ? _value.red
          // ignore: cast_nullable_to_non_nullable
          : red as int,
    );
  }
}

extension $GachaCasesItemsInnerRarityCountsCopyWith
    on GachaCasesItemsInnerRarityCounts {
  /// Returns a callable class that can be used as follows: `instanceOfGachaCasesItemsInnerRarityCounts.copyWith(...)` or like so:`instanceOfGachaCasesItemsInnerRarityCounts.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaCasesItemsInnerRarityCountsCWProxy get copyWith =>
      _$GachaCasesItemsInnerRarityCountsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaCasesItemsInnerRarityCounts _$GachaCasesItemsInnerRarityCountsFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('GachaCasesItemsInnerRarityCounts', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['white', 'blue', 'purple', 'pink', 'red'],
      );
      final val = GachaCasesItemsInnerRarityCounts(
        white: $checkedConvert('white', (v) => (v as num).toInt()),
        blue: $checkedConvert('blue', (v) => (v as num).toInt()),
        purple: $checkedConvert('purple', (v) => (v as num).toInt()),
        pink: $checkedConvert('pink', (v) => (v as num).toInt()),
        red: $checkedConvert('red', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$GachaCasesItemsInnerRarityCountsToJson(
  GachaCasesItemsInnerRarityCounts instance,
) => <String, dynamic>{
  'white': instance.white,
  'blue': instance.blue,
  'purple': instance.purple,
  'pink': instance.pink,
  'red': instance.red,
};
