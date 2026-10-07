// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailCWProxy {
  RecipeDetail id(String id);

  RecipeDetail title(String title);

  RecipeDetail description(String? description);

  RecipeDetail imageUrl(String? imageUrl);

  RecipeDetail baseServings(int baseServings);

  RecipeDetail totalMinutes(int totalMinutes);

  RecipeDetail difficulty(int difficulty);

  RecipeDetail rarity(RecipeDetailRarityEnum rarity);

  RecipeDetail tags(List<RecipeDetailTagsInner> tags);

  RecipeDetail createdAt(DateTime createdAt);

  RecipeDetail sourceUrl(String? sourceUrl);

  RecipeDetail updatedAt(DateTime updatedAt);

  RecipeDetail steps(List<RecipeDetailStepsInner> steps);

  RecipeDetail ingredients(List<RecipeDetailIngredientsInner> ingredients);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetail call({
    String id,
    String title,
    String? description,
    String? imageUrl,
    int baseServings,
    int totalMinutes,
    int difficulty,
    RecipeDetailRarityEnum rarity,
    List<RecipeDetailTagsInner> tags,
    DateTime createdAt,
    String? sourceUrl,
    DateTime updatedAt,
    List<RecipeDetailStepsInner> steps,
    List<RecipeDetailIngredientsInner> ingredients,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetail.copyWith.fieldName(...)`
class _$RecipeDetailCWProxyImpl implements _$RecipeDetailCWProxy {
  const _$RecipeDetailCWProxyImpl(this._value);

  final RecipeDetail _value;

  @override
  RecipeDetail id(String id) => this(id: id);

  @override
  RecipeDetail title(String title) => this(title: title);

  @override
  RecipeDetail description(String? description) =>
      this(description: description);

  @override
  RecipeDetail imageUrl(String? imageUrl) => this(imageUrl: imageUrl);

  @override
  RecipeDetail baseServings(int baseServings) =>
      this(baseServings: baseServings);

  @override
  RecipeDetail totalMinutes(int totalMinutes) =>
      this(totalMinutes: totalMinutes);

  @override
  RecipeDetail difficulty(int difficulty) => this(difficulty: difficulty);

  @override
  RecipeDetail rarity(RecipeDetailRarityEnum rarity) => this(rarity: rarity);

  @override
  RecipeDetail tags(List<RecipeDetailTagsInner> tags) => this(tags: tags);

  @override
  RecipeDetail createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  RecipeDetail sourceUrl(String? sourceUrl) => this(sourceUrl: sourceUrl);

  @override
  RecipeDetail updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  RecipeDetail steps(List<RecipeDetailStepsInner> steps) => this(steps: steps);

  @override
  RecipeDetail ingredients(List<RecipeDetailIngredientsInner> ingredients) =>
      this(ingredients: ingredients);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetail call({
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
    Object? sourceUrl = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? ingredients = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetail(
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
          : rarity as RecipeDetailRarityEnum,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<RecipeDetailTagsInner>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      sourceUrl: sourceUrl == const $CopyWithPlaceholder()
          ? _value.sourceUrl
          // ignore: cast_nullable_to_non_nullable
          : sourceUrl as String?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      steps: steps == const $CopyWithPlaceholder()
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as List<RecipeDetailStepsInner>,
      ingredients: ingredients == const $CopyWithPlaceholder()
          ? _value.ingredients
          // ignore: cast_nullable_to_non_nullable
          : ingredients as List<RecipeDetailIngredientsInner>,
    );
  }
}

extension $RecipeDetailCopyWith on RecipeDetail {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetail.copyWith(...)` or like so:`instanceOfRecipeDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailCWProxy get copyWith => _$RecipeDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetail _$RecipeDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeDetail', json, ($checkedConvert) {
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
      'sourceUrl',
      'updatedAt',
      'steps',
      'ingredients',
    ],
  );
  final val = RecipeDetail(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    baseServings: $checkedConvert('baseServings', (v) => (v as num).toInt()),
    totalMinutes: $checkedConvert('totalMinutes', (v) => (v as num).toInt()),
    difficulty: $checkedConvert('difficulty', (v) => (v as num).toInt()),
    rarity: $checkedConvert(
      'rarity',
      (v) => $enumDecode(_$RecipeDetailRarityEnumEnumMap, v),
    ),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>)
          .map((e) => RecipeDetailTagsInner.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    sourceUrl: $checkedConvert('sourceUrl', (v) => v as String?),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    steps: $checkedConvert(
      'steps',
      (v) => (v as List<dynamic>)
          .map(
            (e) => RecipeDetailStepsInner.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    ingredients: $checkedConvert(
      'ingredients',
      (v) => (v as List<dynamic>)
          .map(
            (e) => RecipeDetailIngredientsInner.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailToJson(RecipeDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'baseServings': instance.baseServings,
      'totalMinutes': instance.totalMinutes,
      'difficulty': instance.difficulty,
      'rarity': _$RecipeDetailRarityEnumEnumMap[instance.rarity]!,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'sourceUrl': instance.sourceUrl,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
    };

const _$RecipeDetailRarityEnumEnumMap = {
  RecipeDetailRarityEnum.white: 'white',
  RecipeDetailRarityEnum.blue: 'blue',
  RecipeDetailRarityEnum.purple: 'purple',
  RecipeDetailRarityEnum.pink: 'pink',
  RecipeDetailRarityEnum.red: 'red',
};
