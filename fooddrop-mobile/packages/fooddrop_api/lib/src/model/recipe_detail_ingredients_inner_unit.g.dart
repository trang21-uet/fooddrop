// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_ingredients_inner_unit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailIngredientsInnerUnitCWProxy {
  RecipeDetailIngredientsInnerUnit code(String code);

  RecipeDetailIngredientsInnerUnit nameVi(String nameVi);

  RecipeDetailIngredientsInnerUnit nameEn(String nameEn);

  RecipeDetailIngredientsInnerUnit kind(
    RecipeDetailIngredientsInnerUnitKindEnum kind,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInnerUnit(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInnerUnit(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInnerUnit call({
    String code,
    String nameVi,
    String nameEn,
    RecipeDetailIngredientsInnerUnitKindEnum kind,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailIngredientsInnerUnit.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailIngredientsInnerUnit.copyWith.fieldName(...)`
class _$RecipeDetailIngredientsInnerUnitCWProxyImpl
    implements _$RecipeDetailIngredientsInnerUnitCWProxy {
  const _$RecipeDetailIngredientsInnerUnitCWProxyImpl(this._value);

  final RecipeDetailIngredientsInnerUnit _value;

  @override
  RecipeDetailIngredientsInnerUnit code(String code) => this(code: code);

  @override
  RecipeDetailIngredientsInnerUnit nameVi(String nameVi) =>
      this(nameVi: nameVi);

  @override
  RecipeDetailIngredientsInnerUnit nameEn(String nameEn) =>
      this(nameEn: nameEn);

  @override
  RecipeDetailIngredientsInnerUnit kind(
    RecipeDetailIngredientsInnerUnitKindEnum kind,
  ) => this(kind: kind);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInnerUnit(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInnerUnit(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInnerUnit call({
    Object? code = const $CopyWithPlaceholder(),
    Object? nameVi = const $CopyWithPlaceholder(),
    Object? nameEn = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailIngredientsInnerUnit(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      nameVi: nameVi == const $CopyWithPlaceholder()
          ? _value.nameVi
          // ignore: cast_nullable_to_non_nullable
          : nameVi as String,
      nameEn: nameEn == const $CopyWithPlaceholder()
          ? _value.nameEn
          // ignore: cast_nullable_to_non_nullable
          : nameEn as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as RecipeDetailIngredientsInnerUnitKindEnum,
    );
  }
}

extension $RecipeDetailIngredientsInnerUnitCopyWith
    on RecipeDetailIngredientsInnerUnit {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailIngredientsInnerUnit.copyWith(...)` or like so:`instanceOfRecipeDetailIngredientsInnerUnit.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailIngredientsInnerUnitCWProxy get copyWith =>
      _$RecipeDetailIngredientsInnerUnitCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailIngredientsInnerUnit _$RecipeDetailIngredientsInnerUnitFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeDetailIngredientsInnerUnit', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['code', 'nameVi', 'nameEn', 'kind']);
  final val = RecipeDetailIngredientsInnerUnit(
    code: $checkedConvert('code', (v) => v as String),
    nameVi: $checkedConvert('nameVi', (v) => v as String),
    nameEn: $checkedConvert('nameEn', (v) => v as String),
    kind: $checkedConvert(
      'kind',
      (v) => $enumDecode(_$RecipeDetailIngredientsInnerUnitKindEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailIngredientsInnerUnitToJson(
  RecipeDetailIngredientsInnerUnit instance,
) => <String, dynamic>{
  'code': instance.code,
  'nameVi': instance.nameVi,
  'nameEn': instance.nameEn,
  'kind': _$RecipeDetailIngredientsInnerUnitKindEnumEnumMap[instance.kind]!,
};

const _$RecipeDetailIngredientsInnerUnitKindEnumEnumMap = {
  RecipeDetailIngredientsInnerUnitKindEnum.mass: 'mass',
  RecipeDetailIngredientsInnerUnitKindEnum.volume: 'volume',
  RecipeDetailIngredientsInnerUnitKindEnum.count: 'count',
  RecipeDetailIngredientsInnerUnitKindEnum.other: 'other',
};
