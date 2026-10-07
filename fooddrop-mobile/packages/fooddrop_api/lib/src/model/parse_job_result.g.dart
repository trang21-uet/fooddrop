// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_job_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseJobResultCWProxy {
  ParseJobResult source_(ParseJobResultSource_Enum source_);

  ParseJobResult title(String title);

  ParseJobResult description(String? description);

  ParseJobResult imageUrl(String? imageUrl);

  ParseJobResult sourceUrl(String? sourceUrl);

  ParseJobResult baseServings(int baseServings);

  ParseJobResult totalMinutes(int? totalMinutes);

  ParseJobResult difficulty(int difficulty);

  ParseJobResult ingredients(List<ParseJobResultIngredientsInner> ingredients);

  ParseJobResult steps(List<ParseJobResultStepsInner> steps);

  ParseJobResult suggestedTagIds(List<int> suggestedTagIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResult(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResult call({
    ParseJobResultSource_Enum source_,
    String title,
    String? description,
    String? imageUrl,
    String? sourceUrl,
    int baseServings,
    int? totalMinutes,
    int difficulty,
    List<ParseJobResultIngredientsInner> ingredients,
    List<ParseJobResultStepsInner> steps,
    List<int> suggestedTagIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseJobResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseJobResult.copyWith.fieldName(...)`
class _$ParseJobResultCWProxyImpl implements _$ParseJobResultCWProxy {
  const _$ParseJobResultCWProxyImpl(this._value);

  final ParseJobResult _value;

  @override
  ParseJobResult source_(ParseJobResultSource_Enum source_) =>
      this(source_: source_);

  @override
  ParseJobResult title(String title) => this(title: title);

  @override
  ParseJobResult description(String? description) =>
      this(description: description);

  @override
  ParseJobResult imageUrl(String? imageUrl) => this(imageUrl: imageUrl);

  @override
  ParseJobResult sourceUrl(String? sourceUrl) => this(sourceUrl: sourceUrl);

  @override
  ParseJobResult baseServings(int baseServings) =>
      this(baseServings: baseServings);

  @override
  ParseJobResult totalMinutes(int? totalMinutes) =>
      this(totalMinutes: totalMinutes);

  @override
  ParseJobResult difficulty(int difficulty) => this(difficulty: difficulty);

  @override
  ParseJobResult ingredients(
    List<ParseJobResultIngredientsInner> ingredients,
  ) => this(ingredients: ingredients);

  @override
  ParseJobResult steps(List<ParseJobResultStepsInner> steps) =>
      this(steps: steps);

  @override
  ParseJobResult suggestedTagIds(List<int> suggestedTagIds) =>
      this(suggestedTagIds: suggestedTagIds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResult(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResult call({
    Object? source_ = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? sourceUrl = const $CopyWithPlaceholder(),
    Object? baseServings = const $CopyWithPlaceholder(),
    Object? totalMinutes = const $CopyWithPlaceholder(),
    Object? difficulty = const $CopyWithPlaceholder(),
    Object? ingredients = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? suggestedTagIds = const $CopyWithPlaceholder(),
  }) {
    return ParseJobResult(
      source_: source_ == const $CopyWithPlaceholder()
          ? _value.source_
          // ignore: cast_nullable_to_non_nullable
          : source_ as ParseJobResultSource_Enum,
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
          : baseServings as int,
      totalMinutes: totalMinutes == const $CopyWithPlaceholder()
          ? _value.totalMinutes
          // ignore: cast_nullable_to_non_nullable
          : totalMinutes as int?,
      difficulty: difficulty == const $CopyWithPlaceholder()
          ? _value.difficulty
          // ignore: cast_nullable_to_non_nullable
          : difficulty as int,
      ingredients: ingredients == const $CopyWithPlaceholder()
          ? _value.ingredients
          // ignore: cast_nullable_to_non_nullable
          : ingredients as List<ParseJobResultIngredientsInner>,
      steps: steps == const $CopyWithPlaceholder()
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as List<ParseJobResultStepsInner>,
      suggestedTagIds: suggestedTagIds == const $CopyWithPlaceholder()
          ? _value.suggestedTagIds
          // ignore: cast_nullable_to_non_nullable
          : suggestedTagIds as List<int>,
    );
  }
}

extension $ParseJobResultCopyWith on ParseJobResult {
  /// Returns a callable class that can be used as follows: `instanceOfParseJobResult.copyWith(...)` or like so:`instanceOfParseJobResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParseJobResultCWProxy get copyWith => _$ParseJobResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseJobResult _$ParseJobResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ParseJobResult', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'source',
      'title',
      'description',
      'imageUrl',
      'sourceUrl',
      'baseServings',
      'totalMinutes',
      'difficulty',
      'ingredients',
      'steps',
      'suggestedTagIds',
    ],
  );
  final val = ParseJobResult(
    source_: $checkedConvert(
      'source',
      (v) => $enumDecode(_$ParseJobResultSource_EnumEnumMap, v),
    ),
    title: $checkedConvert('title', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    sourceUrl: $checkedConvert('sourceUrl', (v) => v as String?),
    baseServings: $checkedConvert('baseServings', (v) => (v as num).toInt()),
    totalMinutes: $checkedConvert('totalMinutes', (v) => (v as num?)?.toInt()),
    difficulty: $checkedConvert('difficulty', (v) => (v as num).toInt()),
    ingredients: $checkedConvert(
      'ingredients',
      (v) => (v as List<dynamic>)
          .map(
            (e) => ParseJobResultIngredientsInner.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
    steps: $checkedConvert(
      'steps',
      (v) => (v as List<dynamic>)
          .map(
            (e) => ParseJobResultStepsInner.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    suggestedTagIds: $checkedConvert(
      'suggestedTagIds',
      (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    ),
  );
  return val;
}, fieldKeyMap: const {'source_': 'source'});

Map<String, dynamic> _$ParseJobResultToJson(ParseJobResult instance) =>
    <String, dynamic>{
      'source': _$ParseJobResultSource_EnumEnumMap[instance.source_]!,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'sourceUrl': instance.sourceUrl,
      'baseServings': instance.baseServings,
      'totalMinutes': instance.totalMinutes,
      'difficulty': instance.difficulty,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'suggestedTagIds': instance.suggestedTagIds,
    };

const _$ParseJobResultSource_EnumEnumMap = {
  ParseJobResultSource_Enum.jsonLd: 'json-ld',
  ParseJobResultSource_Enum.llmText: 'llm-text',
  ParseJobResultSource_Enum.llmVision: 'llm-vision',
};
