// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_ingredients_inner_base.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailIngredientsInnerBaseCWProxy {
  RecipeDetailIngredientsInnerBase quantity(num quantity);

  RecipeDetailIngredientsInnerBase unit(
    RecipeDetailIngredientsInnerBaseUnitEnum unit,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInnerBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInnerBase(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInnerBase call({
    num quantity,
    RecipeDetailIngredientsInnerBaseUnitEnum unit,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailIngredientsInnerBase.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailIngredientsInnerBase.copyWith.fieldName(...)`
class _$RecipeDetailIngredientsInnerBaseCWProxyImpl
    implements _$RecipeDetailIngredientsInnerBaseCWProxy {
  const _$RecipeDetailIngredientsInnerBaseCWProxyImpl(this._value);

  final RecipeDetailIngredientsInnerBase _value;

  @override
  RecipeDetailIngredientsInnerBase quantity(num quantity) =>
      this(quantity: quantity);

  @override
  RecipeDetailIngredientsInnerBase unit(
    RecipeDetailIngredientsInnerBaseUnitEnum unit,
  ) => this(unit: unit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInnerBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInnerBase(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInnerBase call({
    Object? quantity = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailIngredientsInnerBase(
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as num,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as RecipeDetailIngredientsInnerBaseUnitEnum,
    );
  }
}

extension $RecipeDetailIngredientsInnerBaseCopyWith
    on RecipeDetailIngredientsInnerBase {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailIngredientsInnerBase.copyWith(...)` or like so:`instanceOfRecipeDetailIngredientsInnerBase.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailIngredientsInnerBaseCWProxy get copyWith =>
      _$RecipeDetailIngredientsInnerBaseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailIngredientsInnerBase _$RecipeDetailIngredientsInnerBaseFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('RecipeDetailIngredientsInnerBase', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['quantity', 'unit']);
      final val = RecipeDetailIngredientsInnerBase(
        quantity: $checkedConvert('quantity', (v) => v as num),
        unit: $checkedConvert(
          'unit',
          (v) =>
              $enumDecode(_$RecipeDetailIngredientsInnerBaseUnitEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RecipeDetailIngredientsInnerBaseToJson(
  RecipeDetailIngredientsInnerBase instance,
) => <String, dynamic>{
  'quantity': instance.quantity,
  'unit': _$RecipeDetailIngredientsInnerBaseUnitEnumEnumMap[instance.unit]!,
};

const _$RecipeDetailIngredientsInnerBaseUnitEnumEnumMap = {
  RecipeDetailIngredientsInnerBaseUnitEnum.g: 'g',
  RecipeDetailIngredientsInnerBaseUnitEnum.ml: 'ml',
  RecipeDetailIngredientsInnerBaseUnitEnum.piece: 'piece',
};
