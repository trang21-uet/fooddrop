// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dimension.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TagDimensionCWProxy {
  TagDimension id(int id);

  TagDimension slug(String slug);

  TagDimension label(String label);

  TagDimension tags(List<TagDimensionTagsInner> tags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TagDimension(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TagDimension(...).copyWith(id: 12, name: "My name")
  /// ````
  TagDimension call({
    int id,
    String slug,
    String label,
    List<TagDimensionTagsInner> tags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTagDimension.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTagDimension.copyWith.fieldName(...)`
class _$TagDimensionCWProxyImpl implements _$TagDimensionCWProxy {
  const _$TagDimensionCWProxyImpl(this._value);

  final TagDimension _value;

  @override
  TagDimension id(int id) => this(id: id);

  @override
  TagDimension slug(String slug) => this(slug: slug);

  @override
  TagDimension label(String label) => this(label: label);

  @override
  TagDimension tags(List<TagDimensionTagsInner> tags) => this(tags: tags);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TagDimension(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TagDimension(...).copyWith(id: 12, name: "My name")
  /// ````
  TagDimension call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
  }) {
    return TagDimension(
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
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<TagDimensionTagsInner>,
    );
  }
}

extension $TagDimensionCopyWith on TagDimension {
  /// Returns a callable class that can be used as follows: `instanceOfTagDimension.copyWith(...)` or like so:`instanceOfTagDimension.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TagDimensionCWProxy get copyWith => _$TagDimensionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagDimension _$TagDimensionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TagDimension', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'slug', 'label', 'tags']);
      final val = TagDimension(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        slug: $checkedConvert('slug', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>)
              .map(
                (e) =>
                    TagDimensionTagsInner.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TagDimensionToJson(TagDimension instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'label': instance.label,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
    };
