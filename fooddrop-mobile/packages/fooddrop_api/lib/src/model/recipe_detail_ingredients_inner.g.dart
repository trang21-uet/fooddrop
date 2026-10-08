// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_ingredients_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailIngredientsInnerCWProxy {
  RecipeDetailIngredientsInner ingredient(
    RecipeDetailIngredientsInnerIngredient ingredient,
  );

  RecipeDetailIngredientsInner quantity(num? quantity);

  RecipeDetailIngredientsInner unit(RecipeDetailIngredientsInnerUnit? unit);

  RecipeDetailIngredientsInner note(String? note);

  RecipeDetailIngredientsInner base_(RecipeDetailIngredientsInnerBase base_);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInner call({
    RecipeDetailIngredientsInnerIngredient ingredient,
    num? quantity,
    RecipeDetailIngredientsInnerUnit? unit,
    String? note,
    RecipeDetailIngredientsInnerBase base_,
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
  RecipeDetailIngredientsInner quantity(num? quantity) =>
      this(quantity: quantity);

  @override
  RecipeDetailIngredientsInner unit(RecipeDetailIngredientsInnerUnit? unit) =>
      this(unit: unit);

  @override
  RecipeDetailIngredientsInner note(String? note) => this(note: note);

  @override
  RecipeDetailIngredientsInner base_(RecipeDetailIngredientsInnerBase base_) =>
      this(base_: base_);

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
    Object? base_ = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailIngredientsInner(
      ingredient: ingredient == const $CopyWithPlaceholder()
          ? _value.ingredient
          // ignore: cast_nullable_to_non_nullable
          : ingredient as RecipeDetailIngredientsInnerIngredient,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as num?,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as RecipeDetailIngredientsInnerUnit?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      base_: base_ == const $CopyWithPlaceholder()
          ? _value.base_
          // ignore: cast_nullable_to_non_nullable
          : base_ as RecipeDetailIngredientsInnerBase,
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
    requiredKeys: const ['ingredient', 'quantity', 'unit', 'note', 'base'],
  );
  final val = RecipeDetailIngredientsInner(
    ingredient: $checkedConvert(
      'ingredient',
      (v) => RecipeDetailIngredientsInnerIngredient.fromJson(
        v as Map<String, dynamic>,
      ),
    ),
    quantity: $checkedConvert('quantity', (v) => v as num?),
    unit: $checkedConvert(
      'unit',
      (v) => v == null
          ? null
          : RecipeDetailIngredientsInnerUnit.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
    note: $checkedConvert('note', (v) => v as String?),
    base_: $checkedConvert(
      'base',
      (v) =>
          RecipeDetailIngredientsInnerBase.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
}, fieldKeyMap: const {'base_': 'base'});

Map<String, dynamic> _$RecipeDetailIngredientsInnerToJson(
  RecipeDetailIngredientsInner instance,
) => <String, dynamic>{
  'ingredient': instance.ingredient.toJson(),
  'quantity': instance.quantity,
  'unit': instance.unit?.toJson(),
  'note': instance.note,
  'base': instance.base_.toJson(),
};
