// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_input_ingredients_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeInputIngredientsInnerCWProxy {
  RecipeInputIngredientsInner ingredientId(String ingredientId);

  RecipeInputIngredientsInner quantity(String? quantity);

  RecipeInputIngredientsInner unit(String? unit);

  RecipeInputIngredientsInner note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeInputIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeInputIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeInputIngredientsInner call({
    String ingredientId,
    String? quantity,
    String? unit,
    String? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeInputIngredientsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeInputIngredientsInner.copyWith.fieldName(...)`
class _$RecipeInputIngredientsInnerCWProxyImpl
    implements _$RecipeInputIngredientsInnerCWProxy {
  const _$RecipeInputIngredientsInnerCWProxyImpl(this._value);

  final RecipeInputIngredientsInner _value;

  @override
  RecipeInputIngredientsInner ingredientId(String ingredientId) =>
      this(ingredientId: ingredientId);

  @override
  RecipeInputIngredientsInner quantity(String? quantity) =>
      this(quantity: quantity);

  @override
  RecipeInputIngredientsInner unit(String? unit) => this(unit: unit);

  @override
  RecipeInputIngredientsInner note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeInputIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeInputIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeInputIngredientsInner call({
    Object? ingredientId = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return RecipeInputIngredientsInner(
      ingredientId: ingredientId == const $CopyWithPlaceholder()
          ? _value.ingredientId
          // ignore: cast_nullable_to_non_nullable
          : ingredientId as String,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as String?,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as String?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $RecipeInputIngredientsInnerCopyWith on RecipeInputIngredientsInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeInputIngredientsInner.copyWith(...)` or like so:`instanceOfRecipeInputIngredientsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeInputIngredientsInnerCWProxy get copyWith =>
      _$RecipeInputIngredientsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeInputIngredientsInner _$RecipeInputIngredientsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeInputIngredientsInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['ingredientId']);
  final val = RecipeInputIngredientsInner(
    ingredientId: $checkedConvert('ingredientId', (v) => v as String),
    quantity: $checkedConvert('quantity', (v) => v as String?),
    unit: $checkedConvert('unit', (v) => v as String?),
    note: $checkedConvert('note', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RecipeInputIngredientsInnerToJson(
  RecipeInputIngredientsInner instance,
) => <String, dynamic>{
  'ingredientId': instance.ingredientId,
  'quantity': ?instance.quantity,
  'unit': ?instance.unit,
  'note': ?instance.note,
};
