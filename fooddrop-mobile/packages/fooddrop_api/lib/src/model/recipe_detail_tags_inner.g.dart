// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_tags_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailTagsInnerCWProxy {
  RecipeDetailTagsInner id(int id);

  RecipeDetailTagsInner slug(String slug);

  RecipeDetailTagsInner label(String label);

  RecipeDetailTagsInner dimension(String dimension);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailTagsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailTagsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailTagsInner call({
    int id,
    String slug,
    String label,
    String dimension,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailTagsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailTagsInner.copyWith.fieldName(...)`
class _$RecipeDetailTagsInnerCWProxyImpl
    implements _$RecipeDetailTagsInnerCWProxy {
  const _$RecipeDetailTagsInnerCWProxyImpl(this._value);

  final RecipeDetailTagsInner _value;

  @override
  RecipeDetailTagsInner id(int id) => this(id: id);

  @override
  RecipeDetailTagsInner slug(String slug) => this(slug: slug);

  @override
  RecipeDetailTagsInner label(String label) => this(label: label);

  @override
  RecipeDetailTagsInner dimension(String dimension) =>
      this(dimension: dimension);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailTagsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailTagsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailTagsInner call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? dimension = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailTagsInner(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      slug: slug == const $CopyWithPlaceholder()
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      dimension: dimension == const $CopyWithPlaceholder()
          ? _value.dimension
          // ignore: cast_nullable_to_non_nullable
          : dimension as String,
    );
  }
}

extension $RecipeDetailTagsInnerCopyWith on RecipeDetailTagsInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailTagsInner.copyWith(...)` or like so:`instanceOfRecipeDetailTagsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailTagsInnerCWProxy get copyWith =>
      _$RecipeDetailTagsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailTagsInner _$RecipeDetailTagsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeDetailTagsInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'slug', 'label', 'dimension']);
  final val = RecipeDetailTagsInner(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    slug: $checkedConvert('slug', (v) => v as String),
    label: $checkedConvert('label', (v) => v as String),
    dimension: $checkedConvert('dimension', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailTagsInnerToJson(
  RecipeDetailTagsInner instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'label': instance.label,
  'dimension': instance.dimension,
};
