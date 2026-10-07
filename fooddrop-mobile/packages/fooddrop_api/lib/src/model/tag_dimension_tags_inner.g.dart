// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dimension_tags_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TagDimensionTagsInnerCWProxy {
  TagDimensionTagsInner id(int id);

  TagDimensionTagsInner slug(String slug);

  TagDimensionTagsInner label(String label);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TagDimensionTagsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TagDimensionTagsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  TagDimensionTagsInner call({int id, String slug, String label});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTagDimensionTagsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTagDimensionTagsInner.copyWith.fieldName(...)`
class _$TagDimensionTagsInnerCWProxyImpl
    implements _$TagDimensionTagsInnerCWProxy {
  const _$TagDimensionTagsInnerCWProxyImpl(this._value);

  final TagDimensionTagsInner _value;

  @override
  TagDimensionTagsInner id(int id) => this(id: id);

  @override
  TagDimensionTagsInner slug(String slug) => this(slug: slug);

  @override
  TagDimensionTagsInner label(String label) => this(label: label);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TagDimensionTagsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TagDimensionTagsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  TagDimensionTagsInner call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
  }) {
    return TagDimensionTagsInner(
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
    );
  }
}

extension $TagDimensionTagsInnerCopyWith on TagDimensionTagsInner {
  /// Returns a callable class that can be used as follows: `instanceOfTagDimensionTagsInner.copyWith(...)` or like so:`instanceOfTagDimensionTagsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TagDimensionTagsInnerCWProxy get copyWith =>
      _$TagDimensionTagsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagDimensionTagsInner _$TagDimensionTagsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TagDimensionTagsInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'slug', 'label']);
  final val = TagDimensionTagsInner(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    slug: $checkedConvert('slug', (v) => v as String),
    label: $checkedConvert('label', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$TagDimensionTagsInnerToJson(
  TagDimensionTagsInner instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'label': instance.label,
};
