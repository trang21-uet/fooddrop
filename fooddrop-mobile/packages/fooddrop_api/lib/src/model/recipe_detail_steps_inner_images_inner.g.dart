// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_steps_inner_images_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailStepsInnerImagesInnerCWProxy {
  RecipeDetailStepsInnerImagesInner key(String key);

  RecipeDetailStepsInnerImagesInner url(String? url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailStepsInnerImagesInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailStepsInnerImagesInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailStepsInnerImagesInner call({String key, String? url});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailStepsInnerImagesInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailStepsInnerImagesInner.copyWith.fieldName(...)`
class _$RecipeDetailStepsInnerImagesInnerCWProxyImpl
    implements _$RecipeDetailStepsInnerImagesInnerCWProxy {
  const _$RecipeDetailStepsInnerImagesInnerCWProxyImpl(this._value);

  final RecipeDetailStepsInnerImagesInner _value;

  @override
  RecipeDetailStepsInnerImagesInner key(String key) => this(key: key);

  @override
  RecipeDetailStepsInnerImagesInner url(String? url) => this(url: url);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailStepsInnerImagesInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailStepsInnerImagesInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailStepsInnerImagesInner call({
    Object? key = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailStepsInnerImagesInner(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $RecipeDetailStepsInnerImagesInnerCopyWith
    on RecipeDetailStepsInnerImagesInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailStepsInnerImagesInner.copyWith(...)` or like so:`instanceOfRecipeDetailStepsInnerImagesInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailStepsInnerImagesInnerCWProxy get copyWith =>
      _$RecipeDetailStepsInnerImagesInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailStepsInnerImagesInner _$RecipeDetailStepsInnerImagesInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeDetailStepsInnerImagesInner', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['key', 'url']);
  final val = RecipeDetailStepsInnerImagesInner(
    key: $checkedConvert('key', (v) => v as String),
    url: $checkedConvert('url', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailStepsInnerImagesInnerToJson(
  RecipeDetailStepsInnerImagesInner instance,
) => <String, dynamic>{'key': instance.key, 'url': instance.url};
