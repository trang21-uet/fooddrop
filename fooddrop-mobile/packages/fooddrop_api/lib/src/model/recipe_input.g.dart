// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeInputCWProxy {
  RecipeInput title(String title);

  RecipeInput description(String? description);

  RecipeInput imageUrl(String? imageUrl);

  RecipeInput sourceUrl(String? sourceUrl);

  RecipeInput baseServings(int? baseServings);

  RecipeInput totalMinutes(int totalMinutes);

  RecipeInput difficulty(int difficulty);

  RecipeInput steps(List<RecipeInputStepsInner> steps);

  RecipeInput ingredients(List<RecipeInputIngredientsInner>? ingredients);

  RecipeInput tagIds(List<int>? tagIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeInput(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeInput call({
    String title,
    String? description,
    String? imageUrl,
    String? sourceUrl,
    int? baseServings,
    int totalMinutes,
    int difficulty,
    List<RecipeInputStepsInner> steps,
    List<RecipeInputIngredientsInner>? ingredients,
    List<int>? tagIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeInput.copyWith.fieldName(...)`
class _$RecipeInputCWProxyImpl implements _$RecipeInputCWProxy {
  const _$RecipeInputCWProxyImpl(this._value);

  final RecipeInput _value;

  @override
  RecipeInput title(String title) => this(title: title);

  @override
  RecipeInput description(String? description) =>
      this(description: description);

  @override
  RecipeInput imageUrl(String? imageUrl) => this(imageUrl: imageUrl);

  @override
  RecipeInput sourceUrl(String? sourceUrl) => this(sourceUrl: sourceUrl);

  @override
  RecipeInput baseServings(int? baseServings) =>
      this(baseServings: baseServings);

  @override
  RecipeInput totalMinutes(int totalMinutes) =>
      this(totalMinutes: totalMinutes);

  @override
  RecipeInput difficulty(int difficulty) => this(difficulty: difficulty);

  @override
  RecipeInput steps(List<RecipeInputStepsInner> steps) => this(steps: steps);

  @override
  RecipeInput ingredients(List<RecipeInputIngredientsInner>? ingredients) =>
      this(ingredients: ingredients);

  @override
  RecipeInput tagIds(List<int>? tagIds) => this(tagIds: tagIds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeInput(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeInput call({
    Object? title = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? sourceUrl = const $CopyWithPlaceholder(),
    Object? baseServings = const $CopyWithPlaceholder(),
    Object? totalMinutes = const $CopyWithPlaceholder(),
    Object? difficulty = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? ingredients = const $CopyWithPlaceholder(),
    Object? tagIds = const $CopyWithPlaceholder(),
  }) {
    return RecipeInput(
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
      sourceUrl: sourceUrl == const $CopyWithPlaceholder()
          ? _value.sourceUrl
          // ignore: cast_nullable_to_non_nullable
          : sourceUrl as String?,
      baseServings: baseServings == const $CopyWithPlaceholder()
          ? _value.baseServings
          // ignore: cast_nullable_to_non_nullable
          : baseServings as int?,
      totalMinutes: totalMinutes == const $CopyWithPlaceholder()
          ? _value.totalMinutes
          // ignore: cast_nullable_to_non_nullable
          : totalMinutes as int,
      difficulty: difficulty == const $CopyWithPlaceholder()
          ? _value.difficulty
          // ignore: cast_nullable_to_non_nullable
          : difficulty as int,
      steps: steps == const $CopyWithPlaceholder()
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as List<RecipeInputStepsInner>,
      ingredients: ingredients == const $CopyWithPlaceholder()
          ? _value.ingredients
          // ignore: cast_nullable_to_non_nullable
          : ingredients as List<RecipeInputIngredientsInner>?,
      tagIds: tagIds == const $CopyWithPlaceholder()
          ? _value.tagIds
          // ignore: cast_nullable_to_non_nullable
          : tagIds as List<int>?,
    );
  }
}

extension $RecipeInputCopyWith on RecipeInput {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeInput.copyWith(...)` or like so:`instanceOfRecipeInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeInputCWProxy get copyWith => _$RecipeInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeInput _$RecipeInputFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeInput', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['title', 'totalMinutes', 'difficulty', 'steps'],
  );
  final val = RecipeInput(
    title: $checkedConvert('title', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    sourceUrl: $checkedConvert('sourceUrl', (v) => v as String?),
    baseServings: $checkedConvert(
      'baseServings',
      (v) => (v as num?)?.toInt() ?? 2,
    ),
    totalMinutes: $checkedConvert('totalMinutes', (v) => (v as num).toInt()),
    difficulty: $checkedConvert('difficulty', (v) => (v as num).toInt()),
    steps: $checkedConvert(
      'steps',
      (v) => (v as List<dynamic>)
          .map((e) => RecipeInputStepsInner.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    ingredients: $checkedConvert(
      'ingredients',
      (v) => (v as List<dynamic>?)
          ?.map(
            (e) =>
                RecipeInputIngredientsInner.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    tagIds: $checkedConvert(
      'tagIds',
      (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$RecipeInputToJson(RecipeInput instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': ?instance.description,
      'imageUrl': ?instance.imageUrl,
      'sourceUrl': ?instance.sourceUrl,
      'baseServings': ?instance.baseServings,
      'totalMinutes': instance.totalMinutes,
      'difficulty': instance.difficulty,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'ingredients': ?instance.ingredients?.map((e) => e.toJson()).toList(),
      'tagIds': ?instance.tagIds,
    };
