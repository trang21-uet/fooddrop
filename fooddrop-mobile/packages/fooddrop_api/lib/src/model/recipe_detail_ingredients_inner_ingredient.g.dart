// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_ingredients_inner_ingredient.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailIngredientsInnerIngredientCWProxy {
  RecipeDetailIngredientsInnerIngredient id(String id);

  RecipeDetailIngredientsInnerIngredient name(String name);

  RecipeDetailIngredientsInnerIngredient aisle(
    RecipeDetailIngredientsInnerIngredientAisleEnum aisle,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInnerIngredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInnerIngredient(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInnerIngredient call({
    String id,
    String name,
    RecipeDetailIngredientsInnerIngredientAisleEnum aisle,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailIngredientsInnerIngredient.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailIngredientsInnerIngredient.copyWith.fieldName(...)`
class _$RecipeDetailIngredientsInnerIngredientCWProxyImpl
    implements _$RecipeDetailIngredientsInnerIngredientCWProxy {
  const _$RecipeDetailIngredientsInnerIngredientCWProxyImpl(this._value);

  final RecipeDetailIngredientsInnerIngredient _value;

  @override
  RecipeDetailIngredientsInnerIngredient id(String id) => this(id: id);

  @override
  RecipeDetailIngredientsInnerIngredient name(String name) => this(name: name);

  @override
  RecipeDetailIngredientsInnerIngredient aisle(
    RecipeDetailIngredientsInnerIngredientAisleEnum aisle,
  ) => this(aisle: aisle);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailIngredientsInnerIngredient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailIngredientsInnerIngredient(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailIngredientsInnerIngredient call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? aisle = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailIngredientsInnerIngredient(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      aisle: aisle == const $CopyWithPlaceholder()
          ? _value.aisle
          // ignore: cast_nullable_to_non_nullable
          : aisle as RecipeDetailIngredientsInnerIngredientAisleEnum,
    );
  }
}

extension $RecipeDetailIngredientsInnerIngredientCopyWith
    on RecipeDetailIngredientsInnerIngredient {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailIngredientsInnerIngredient.copyWith(...)` or like so:`instanceOfRecipeDetailIngredientsInnerIngredient.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailIngredientsInnerIngredientCWProxy get copyWith =>
      _$RecipeDetailIngredientsInnerIngredientCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailIngredientsInnerIngredient
_$RecipeDetailIngredientsInnerIngredientFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RecipeDetailIngredientsInnerIngredient', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'aisle']);
      final val = RecipeDetailIngredientsInnerIngredient(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        aisle: $checkedConvert(
          'aisle',
          (v) => $enumDecode(
            _$RecipeDetailIngredientsInnerIngredientAisleEnumEnumMap,
            v,
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RecipeDetailIngredientsInnerIngredientToJson(
  RecipeDetailIngredientsInnerIngredient instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'aisle':
      _$RecipeDetailIngredientsInnerIngredientAisleEnumEnumMap[instance.aisle]!,
};

const _$RecipeDetailIngredientsInnerIngredientAisleEnumEnumMap = {
  RecipeDetailIngredientsInnerIngredientAisleEnum.produce: 'produce',
  RecipeDetailIngredientsInnerIngredientAisleEnum.meat: 'meat',
  RecipeDetailIngredientsInnerIngredientAisleEnum.seafood: 'seafood',
  RecipeDetailIngredientsInnerIngredientAisleEnum.dairy: 'dairy',
  RecipeDetailIngredientsInnerIngredientAisleEnum.pantry: 'pantry',
  RecipeDetailIngredientsInnerIngredientAisleEnum.spices: 'spices',
  RecipeDetailIngredientsInnerIngredientAisleEnum.frozen: 'frozen',
  RecipeDetailIngredientsInnerIngredientAisleEnum.other: 'other',
};
