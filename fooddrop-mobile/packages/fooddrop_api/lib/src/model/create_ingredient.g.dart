// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ingredient.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateIngredientCWProxy {
  CreateIngredient name(String name);

  CreateIngredient aliases(List<String>? aliases);

  CreateIngredient aisle(CreateIngredientAisleEnum? aisle);

  CreateIngredient defaultUnit(CreateIngredientDefaultUnitEnum? defaultUnit);

  CreateIngredient densityGPerMl(num? densityGPerMl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateIngredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateIngredient(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateIngredient call({
    String name,
    List<String>? aliases,
    CreateIngredientAisleEnum? aisle,
    CreateIngredientDefaultUnitEnum? defaultUnit,
    num? densityGPerMl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateIngredient.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateIngredient.copyWith.fieldName(...)`
class _$CreateIngredientCWProxyImpl implements _$CreateIngredientCWProxy {
  const _$CreateIngredientCWProxyImpl(this._value);

  final CreateIngredient _value;

  @override
  CreateIngredient name(String name) => this(name: name);

  @override
  CreateIngredient aliases(List<String>? aliases) => this(aliases: aliases);

  @override
  CreateIngredient aisle(CreateIngredientAisleEnum? aisle) =>
      this(aisle: aisle);

  @override
  CreateIngredient defaultUnit(CreateIngredientDefaultUnitEnum? defaultUnit) =>
      this(defaultUnit: defaultUnit);

  @override
  CreateIngredient densityGPerMl(num? densityGPerMl) =>
      this(densityGPerMl: densityGPerMl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateIngredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateIngredient(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateIngredient call({
    Object? name = const $CopyWithPlaceholder(),
    Object? aliases = const $CopyWithPlaceholder(),
    Object? aisle = const $CopyWithPlaceholder(),
    Object? defaultUnit = const $CopyWithPlaceholder(),
    Object? densityGPerMl = const $CopyWithPlaceholder(),
  }) {
    return CreateIngredient(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      aliases: aliases == const $CopyWithPlaceholder()
          ? _value.aliases
          // ignore: cast_nullable_to_non_nullable
          : aliases as List<String>?,
      aisle: aisle == const $CopyWithPlaceholder()
          ? _value.aisle
          // ignore: cast_nullable_to_non_nullable
          : aisle as CreateIngredientAisleEnum?,
      defaultUnit: defaultUnit == const $CopyWithPlaceholder()
          ? _value.defaultUnit
          // ignore: cast_nullable_to_non_nullable
          : defaultUnit as CreateIngredientDefaultUnitEnum?,
      densityGPerMl: densityGPerMl == const $CopyWithPlaceholder()
          ? _value.densityGPerMl
          // ignore: cast_nullable_to_non_nullable
          : densityGPerMl as num?,
    );
  }
}

extension $CreateIngredientCopyWith on CreateIngredient {
  /// Returns a callable class that can be used as follows: `instanceOfCreateIngredient.copyWith(...)` or like so:`instanceOfCreateIngredient.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateIngredientCWProxy get copyWith => _$CreateIngredientCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateIngredient _$CreateIngredientFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateIngredient', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name']);
      final val = CreateIngredient(
        name: $checkedConvert('name', (v) => v as String),
        aliases: $checkedConvert(
          'aliases',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        aisle: $checkedConvert(
          'aisle',
          (v) => $enumDecodeNullable(_$CreateIngredientAisleEnumEnumMap, v),
        ),
        defaultUnit: $checkedConvert(
          'defaultUnit',
          (v) =>
              $enumDecodeNullable(_$CreateIngredientDefaultUnitEnumEnumMap, v),
        ),
        densityGPerMl: $checkedConvert('densityGPerMl', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$CreateIngredientToJson(CreateIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'aliases': ?instance.aliases,
      'aisle': ?_$CreateIngredientAisleEnumEnumMap[instance.aisle],
      'defaultUnit':
          ?_$CreateIngredientDefaultUnitEnumEnumMap[instance.defaultUnit],
      'densityGPerMl': ?instance.densityGPerMl,
    };

const _$CreateIngredientAisleEnumEnumMap = {
  CreateIngredientAisleEnum.produce: 'produce',
  CreateIngredientAisleEnum.meat: 'meat',
  CreateIngredientAisleEnum.seafood: 'seafood',
  CreateIngredientAisleEnum.dairy: 'dairy',
  CreateIngredientAisleEnum.pantry: 'pantry',
  CreateIngredientAisleEnum.spices: 'spices',
  CreateIngredientAisleEnum.frozen: 'frozen',
  CreateIngredientAisleEnum.other: 'other',
};

const _$CreateIngredientDefaultUnitEnumEnumMap = {
  CreateIngredientDefaultUnitEnum.g: 'g',
  CreateIngredientDefaultUnitEnum.ml: 'ml',
  CreateIngredientDefaultUnitEnum.piece: 'piece',
};
