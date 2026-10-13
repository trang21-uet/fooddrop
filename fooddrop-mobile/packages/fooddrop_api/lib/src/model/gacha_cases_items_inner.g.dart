// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_cases_items_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaCasesItemsInnerCWProxy {
  GachaCasesItemsInner id(GachaCasesItemsInnerIdEnum id);

  GachaCasesItemsInner recipeCount(int recipeCount);

  GachaCasesItemsInner rarityCounts(
    GachaCasesItemsInnerRarityCounts rarityCounts,
  );

  GachaCasesItemsInner preview(List<GachaSpinResult> preview);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaCasesItemsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaCasesItemsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaCasesItemsInner call({
    GachaCasesItemsInnerIdEnum id,
    int recipeCount,
    GachaCasesItemsInnerRarityCounts rarityCounts,
    List<GachaSpinResult> preview,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaCasesItemsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaCasesItemsInner.copyWith.fieldName(...)`
class _$GachaCasesItemsInnerCWProxyImpl
    implements _$GachaCasesItemsInnerCWProxy {
  const _$GachaCasesItemsInnerCWProxyImpl(this._value);

  final GachaCasesItemsInner _value;

  @override
  GachaCasesItemsInner id(GachaCasesItemsInnerIdEnum id) => this(id: id);

  @override
  GachaCasesItemsInner recipeCount(int recipeCount) =>
      this(recipeCount: recipeCount);

  @override
  GachaCasesItemsInner rarityCounts(
    GachaCasesItemsInnerRarityCounts rarityCounts,
  ) => this(rarityCounts: rarityCounts);

  @override
  GachaCasesItemsInner preview(List<GachaSpinResult> preview) =>
      this(preview: preview);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaCasesItemsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaCasesItemsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaCasesItemsInner call({
    Object? id = const $CopyWithPlaceholder(),
    Object? recipeCount = const $CopyWithPlaceholder(),
    Object? rarityCounts = const $CopyWithPlaceholder(),
    Object? preview = const $CopyWithPlaceholder(),
  }) {
    return GachaCasesItemsInner(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as GachaCasesItemsInnerIdEnum,
      recipeCount: recipeCount == const $CopyWithPlaceholder()
          ? _value.recipeCount
          // ignore: cast_nullable_to_non_nullable
          : recipeCount as int,
      rarityCounts: rarityCounts == const $CopyWithPlaceholder()
          ? _value.rarityCounts
          // ignore: cast_nullable_to_non_nullable
          : rarityCounts as GachaCasesItemsInnerRarityCounts,
      preview: preview == const $CopyWithPlaceholder()
          ? _value.preview
          // ignore: cast_nullable_to_non_nullable
          : preview as List<GachaSpinResult>,
    );
  }
}

extension $GachaCasesItemsInnerCopyWith on GachaCasesItemsInner {
  /// Returns a callable class that can be used as follows: `instanceOfGachaCasesItemsInner.copyWith(...)` or like so:`instanceOfGachaCasesItemsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaCasesItemsInnerCWProxy get copyWith =>
      _$GachaCasesItemsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaCasesItemsInner _$GachaCasesItemsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GachaCasesItemsInner', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'recipeCount', 'rarityCounts', 'preview'],
  );
  final val = GachaCasesItemsInner(
    id: $checkedConvert(
      'id',
      (v) => $enumDecode(_$GachaCasesItemsInnerIdEnumEnumMap, v),
    ),
    recipeCount: $checkedConvert('recipeCount', (v) => (v as num).toInt()),
    rarityCounts: $checkedConvert(
      'rarityCounts',
      (v) =>
          GachaCasesItemsInnerRarityCounts.fromJson(v as Map<String, dynamic>),
    ),
    preview: $checkedConvert(
      'preview',
      (v) => (v as List<dynamic>)
          .map((e) => GachaSpinResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$GachaCasesItemsInnerToJson(
  GachaCasesItemsInner instance,
) => <String, dynamic>{
  'id': _$GachaCasesItemsInnerIdEnumEnumMap[instance.id]!,
  'recipeCount': instance.recipeCount,
  'rarityCounts': instance.rarityCounts.toJson(),
  'preview': instance.preview.map((e) => e.toJson()).toList(),
};

const _$GachaCasesItemsInnerIdEnumEnumMap = {
  GachaCasesItemsInnerIdEnum.all: 'all',
  GachaCasesItemsInnerIdEnum.breakfast: 'breakfast',
  GachaCasesItemsInnerIdEnum.lunch: 'lunch',
  GachaCasesItemsInnerIdEnum.dinner: 'dinner',
  GachaCasesItemsInnerIdEnum.quick: 'quick',
  GachaCasesItemsInnerIdEnum.epic: 'epic',
};
