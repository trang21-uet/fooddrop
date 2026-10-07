// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_list_items_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeListItemsInnerCWProxy {
  RecipeListItemsInner id(String id);

  RecipeListItemsInner title(String title);

  RecipeListItemsInner description(String? description);

  RecipeListItemsInner imageUrl(String? imageUrl);

  RecipeListItemsInner baseServings(int baseServings);

  RecipeListItemsInner totalMinutes(int totalMinutes);

  RecipeListItemsInner difficulty(int difficulty);

  RecipeListItemsInner rarity(RecipeListItemsInnerRarityEnum rarity);

  RecipeListItemsInner tags(List<RecipeDetailTagsInner> tags);

  RecipeListItemsInner createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeListItemsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeListItemsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeListItemsInner call({
    String id,
    String title,
    String? description,
    String? imageUrl,
    int baseServings,
    int totalMinutes,
    int difficulty,
    RecipeListItemsInnerRarityEnum rarity,
    List<RecipeDetailTagsInner> tags,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeListItemsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeListItemsInner.copyWith.fieldName(...)`
class _$RecipeListItemsInnerCWProxyImpl
    implements _$RecipeListItemsInnerCWProxy {
  const _$RecipeListItemsInnerCWProxyImpl(this._value);

  final RecipeListItemsInner _value;

  @override
  RecipeListItemsInner id(String id) => this(id: id);

  @override
  RecipeListItemsInner title(String title) => this(title: title);

  @override
  RecipeListItemsInner description(String? description) =>
      this(description: description);

  @override
  RecipeListItemsInner imageUrl(String? imageUrl) => this(imageUrl: imageUrl);

  @override
  RecipeListItemsInner baseServings(int baseServings) =>
      this(baseServings: baseServings);

  @override
  RecipeListItemsInner totalMinutes(int totalMinutes) =>
      this(totalMinutes: totalMinutes);

  @override
  RecipeListItemsInner difficulty(int difficulty) =>
      this(difficulty: difficulty);

  @override
  RecipeListItemsInner rarity(RecipeListItemsInnerRarityEnum rarity) =>
      this(rarity: rarity);

  @override
  RecipeListItemsInner tags(List<RecipeDetailTagsInner> tags) =>
      this(tags: tags);

  @override
  RecipeListItemsInner createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeListItemsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeListItemsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeListItemsInner call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? baseServings = const $CopyWithPlaceholder(),
    Object? totalMinutes = const $CopyWithPlaceholder(),
    Object? difficulty = const $CopyWithPlaceholder(),
    Object? rarity = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return RecipeListItemsInner(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      imageUrl: imageUrl == const $CopyWithPlaceholder()
          ? _value.imageUrl
          // ignore: cast_nullable_to_non_nullable
          : imageUrl as String?,
      baseServings: baseServings == const $CopyWithPlaceholder()
          ? _value.baseServings
          // ignore: cast_nullable_to_non_nullable
          : baseServings as int,
      totalMinutes: totalMinutes == const $CopyWithPlaceholder()
          ? _value.totalMinutes
          // ignore: cast_nullable_to_non_nullable
          : totalMinutes as int,
      difficulty: difficulty == const $CopyWithPlaceholder()
          ? _value.difficulty
          // ignore: cast_nullable_to_non_nullable
          : difficulty as int,
      rarity: rarity == const $CopyWithPlaceholder()
          ? _value.rarity
          // ignore: cast_nullable_to_non_nullable
          : rarity as RecipeListItemsInnerRarityEnum,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<RecipeDetailTagsInner>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $RecipeListItemsInnerCopyWith on RecipeListItemsInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeListItemsInner.copyWith(...)` or like so:`instanceOfRecipeListItemsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeListItemsInnerCWProxy get copyWith =>
      _$RecipeListItemsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeListItemsInner _$RecipeListItemsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeListItemsInner', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'title',
      'description',
      'imageUrl',
      'baseServings',
      'totalMinutes',
      'difficulty',
      'rarity',
      'tags',
      'createdAt',
    ],
  );
  final val = RecipeListItemsInner(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    baseServings: $checkedConvert('baseServings', (v) => (v as num).toInt()),
    totalMinutes: $checkedConvert('totalMinutes', (v) => (v as num).toInt()),
    difficulty: $checkedConvert('difficulty', (v) => (v as num).toInt()),
    rarity: $checkedConvert(
      'rarity',
      (v) => $enumDecode(_$RecipeListItemsInnerRarityEnumEnumMap, v),
    ),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>)
          .map((e) => RecipeDetailTagsInner.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$RecipeListItemsInnerToJson(
  RecipeListItemsInner instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'baseServings': instance.baseServings,
  'totalMinutes': instance.totalMinutes,
  'difficulty': instance.difficulty,
  'rarity': _$RecipeListItemsInnerRarityEnumEnumMap[instance.rarity]!,
  'tags': instance.tags.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$RecipeListItemsInnerRarityEnumEnumMap = {
  RecipeListItemsInnerRarityEnum.white: 'white',
  RecipeListItemsInnerRarityEnum.blue: 'blue',
  RecipeListItemsInnerRarityEnum.purple: 'purple',
  RecipeListItemsInnerRarityEnum.pink: 'pink',
  RecipeListItemsInnerRarityEnum.red: 'red',
};
