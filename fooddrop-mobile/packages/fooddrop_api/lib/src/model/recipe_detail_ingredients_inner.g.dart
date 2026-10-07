// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_ingredients_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailIngredientsInnerCWProxy {
  RecipeDetailIngredientsInner ingredient(
    RecipeDetailIngredientsInnerIngredient ingredient,
  );

  RecipeDetailIngredientsInner quantity(num quantity);

  RecipeDetailIngredientsInner unit(RecipeDetailIngredientsInnerUnitEnum unit);

  RecipeDetailIngredientsInner note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInner call({
    RecipeDetailIngredientsInnerIngredient ingredient,
    num quantity,
    RecipeDetailIngredientsInnerUnitEnum unit,
    String? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailIngredientsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailIngredientsInner.copyWith.fieldName(...)`
class _$RecipeDetailIngredientsInnerCWProxyImpl
    implements _$RecipeDetailIngredientsInnerCWProxy {
  const _$RecipeDetailIngredientsInnerCWProxyImpl(this._value);

  final RecipeDetailIngredientsInner _value;

  @override
  RecipeDetailIngredientsInner ingredient(
    RecipeDetailIngredientsInnerIngredient ingredient,
  ) => this(ingredient: ingredient);

  @override
  RecipeDetailIngredientsInner quantity(num quantity) =>
      this(quantity: quantity);

  @override
  RecipeDetailIngredientsInner unit(
    RecipeDetailIngredientsInnerUnitEnum unit,
  ) => this(unit: unit);

  @override
  RecipeDetailIngredientsInner note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInner call({
    Object? ingredient = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailIngredientsInner(
      ingredient: ingredient == const $CopyWithPlaceholder()
          ? _value.ingredient
          // ignore: cast_nullable_to_non_nullable
          : ingredient as RecipeDetailIngredientsInnerIngredient,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as num,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as RecipeDetailIngredientsInnerUnitEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $RecipeDetailIngredientsInnerCopyWith
    on RecipeDetailIngredientsInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailIngredientsInner.copyWith(...)` or like so:`instanceOfRecipeDetailIngredientsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailIngredientsInnerCWProxy get copyWith =>
      _$RecipeDetailIngredientsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailIngredientsInner _$RecipeDetailIngredientsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeDetailIngredientsInner', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['ingredient', 'quantity', 'unit', 'note'],
  );
  final val = RecipeDetailIngredientsInner(
    ingredient: $checkedConvert(
      'ingredient',
      (v) => RecipeDetailIngredientsInnerIngredient.fromJson(
        v as Map<String, dynamic>,
      ),
    ),
    quantity: $checkedConvert('quantity', (v) => v as num),
    unit: $checkedConvert(
      'unit',
      (v) => $enumDecode(_$RecipeDetailIngredientsInnerUnitEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailIngredientsInnerToJson(
  RecipeDetailIngredientsInner instance,
) => <String, dynamic>{
  'ingredient': instance.ingredient.toJson(),
  'quantity': instance.quantity,
  'unit': _$RecipeDetailIngredientsInnerUnitEnumEnumMap[instance.unit]!,
  'note': instance.note,
};

const _$RecipeDetailIngredientsInnerUnitEnumEnumMap = {
  RecipeDetailIngredientsInnerUnitEnum.g: 'g',
  RecipeDetailIngredientsInnerUnitEnum.ml: 'ml',
  RecipeDetailIngredientsInnerUnitEnum.piece: 'piece',
};
