// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IngredientCWProxy {
  Ingredient id(String id);

  Ingredient name(String name);

  Ingredient aliases(List<String> aliases);

  Ingredient aisle(IngredientAisleEnum aisle);

  Ingredient defaultUnit(IngredientDefaultUnitEnum defaultUnit);

  Ingredient densityGPerMl(num? densityGPerMl);

  Ingredient isFermented(bool isFermented);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ingredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ingredient(...).copyWith(id: 12, name: "My name")
  /// ````
  Ingredient call({
    String id,
    String name,
    List<String> aliases,
    IngredientAisleEnum aisle,
    IngredientDefaultUnitEnum defaultUnit,
    num? densityGPerMl,
    bool isFermented,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIngredient.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIngredient.copyWith.fieldName(...)`
class _$IngredientCWProxyImpl implements _$IngredientCWProxy {
  const _$IngredientCWProxyImpl(this._value);

  final Ingredient _value;

  @override
  Ingredient id(String id) => this(id: id);

  @override
  Ingredient name(String name) => this(name: name);

  @override
  Ingredient aliases(List<String> aliases) => this(aliases: aliases);

  @override
  Ingredient aisle(IngredientAisleEnum aisle) => this(aisle: aisle);

  @override
  Ingredient defaultUnit(IngredientDefaultUnitEnum defaultUnit) =>
      this(defaultUnit: defaultUnit);

  @override
  Ingredient densityGPerMl(num? densityGPerMl) =>
      this(densityGPerMl: densityGPerMl);

  @override
  Ingredient isFermented(bool isFermented) => this(isFermented: isFermented);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ingredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ingredient(...).copyWith(id: 12, name: "My name")
  /// ````
  Ingredient call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? aliases = const $CopyWithPlaceholder(),
    Object? aisle = const $CopyWithPlaceholder(),
    Object? defaultUnit = const $CopyWithPlaceholder(),
    Object? densityGPerMl = const $CopyWithPlaceholder(),
    Object? isFermented = const $CopyWithPlaceholder(),
  }) {
    return Ingredient(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      aliases: aliases == const $CopyWithPlaceholder()
          ? _value.aliases
          // ignore: cast_nullable_to_non_nullable
          : aliases as List<String>,
      aisle: aisle == const $CopyWithPlaceholder()
          ? _value.aisle
          // ignore: cast_nullable_to_non_nullable
          : aisle as IngredientAisleEnum,
      defaultUnit: defaultUnit == const $CopyWithPlaceholder()
          ? _value.defaultUnit
          // ignore: cast_nullable_to_non_nullable
          : defaultUnit as IngredientDefaultUnitEnum,
      densityGPerMl: densityGPerMl == const $CopyWithPlaceholder()
          ? _value.densityGPerMl
          // ignore: cast_nullable_to_non_nullable
          : densityGPerMl as num?,
      isFermented: isFermented == const $CopyWithPlaceholder()
          ? _value.isFermented
          // ignore: cast_nullable_to_non_nullable
          : isFermented as bool,
    );
  }
}

extension $IngredientCopyWith on Ingredient {
  /// Returns a callable class that can be used as follows: `instanceOfIngredient.copyWith(...)` or like so:`instanceOfIngredient.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IngredientCWProxy get copyWith => _$IngredientCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Ingredient', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'aliases',
          'aisle',
          'defaultUnit',
          'densityGPerMl',
          'isFermented',
        ],
      );
      final val = Ingredient(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        aliases: $checkedConvert(
          'aliases',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        aisle: $checkedConvert(
          'aisle',
          (v) => $enumDecode(_$IngredientAisleEnumEnumMap, v),
        ),
        defaultUnit: $checkedConvert(
          'defaultUnit',
          (v) => $enumDecode(_$IngredientDefaultUnitEnumEnumMap, v),
        ),
        densityGPerMl: $checkedConvert('densityGPerMl', (v) => v as num?),
        isFermented: $checkedConvert('isFermented', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'aliases': instance.aliases,
      'aisle': _$IngredientAisleEnumEnumMap[instance.aisle]!,
      'defaultUnit': _$IngredientDefaultUnitEnumEnumMap[instance.defaultUnit]!,
      'densityGPerMl': instance.densityGPerMl,
      'isFermented': instance.isFermented,
    };

const _$IngredientAisleEnumEnumMap = {
  IngredientAisleEnum.produce: 'produce',
  IngredientAisleEnum.meat: 'meat',
  IngredientAisleEnum.seafood: 'seafood',
  IngredientAisleEnum.dairy: 'dairy',
  IngredientAisleEnum.pantry: 'pantry',
  IngredientAisleEnum.spices: 'spices',
  IngredientAisleEnum.frozen: 'frozen',
  IngredientAisleEnum.other: 'other',
};

const _$IngredientDefaultUnitEnumEnumMap = {
  IngredientDefaultUnitEnum.g: 'g',
  IngredientDefaultUnitEnum.ml: 'ml',
  IngredientDefaultUnitEnum.piece: 'piece',
};
