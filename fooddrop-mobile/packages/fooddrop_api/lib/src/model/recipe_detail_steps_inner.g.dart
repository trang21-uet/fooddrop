// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_steps_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailStepsInnerCWProxy {
  RecipeDetailStepsInner order(int order);

  RecipeDetailStepsInner name(String? name);

  RecipeDetailStepsInner text(String text);

  RecipeDetailStepsInner note(String? note);

  RecipeDetailStepsInner images(List<RecipeDetailStepsInnerImagesInner> images);

  RecipeDetailStepsInner timerSeconds(int? timerSeconds);

  RecipeDetailStepsInner timerLabel(String? timerLabel);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailStepsInner call({
    int order,
    String? name,
    String text,
    String? note,
    List<RecipeDetailStepsInnerImagesInner> images,
    int? timerSeconds,
    String? timerLabel,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeDetailStepsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeDetailStepsInner.copyWith.fieldName(...)`
class _$RecipeDetailStepsInnerCWProxyImpl
    implements _$RecipeDetailStepsInnerCWProxy {
  const _$RecipeDetailStepsInnerCWProxyImpl(this._value);

  final RecipeDetailStepsInner _value;

  @override
  RecipeDetailStepsInner order(int order) => this(order: order);

  @override
  RecipeDetailStepsInner name(String? name) => this(name: name);

  @override
  RecipeDetailStepsInner text(String text) => this(text: text);

  @override
  RecipeDetailStepsInner note(String? note) => this(note: note);

  @override
  RecipeDetailStepsInner images(
    List<RecipeDetailStepsInnerImagesInner> images,
  ) => this(images: images);

  @override
  RecipeDetailStepsInner timerSeconds(int? timerSeconds) =>
      this(timerSeconds: timerSeconds);

  @override
  RecipeDetailStepsInner timerLabel(String? timerLabel) =>
      this(timerLabel: timerLabel);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeDetailStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeDetailStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeDetailStepsInner call({
    Object? order = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? images = const $CopyWithPlaceholder(),
    Object? timerSeconds = const $CopyWithPlaceholder(),
    Object? timerLabel = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailStepsInner(
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      images: images == const $CopyWithPlaceholder()
          ? _value.images
          // ignore: cast_nullable_to_non_nullable
          : images as List<RecipeDetailStepsInnerImagesInner>,
      timerSeconds: timerSeconds == const $CopyWithPlaceholder()
          ? _value.timerSeconds
          // ignore: cast_nullable_to_non_nullable
          : timerSeconds as int?,
      timerLabel: timerLabel == const $CopyWithPlaceholder()
          ? _value.timerLabel
          // ignore: cast_nullable_to_non_nullable
          : timerLabel as String?,
    );
  }
}

extension $RecipeDetailStepsInnerCopyWith on RecipeDetailStepsInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeDetailStepsInner.copyWith(...)` or like so:`instanceOfRecipeDetailStepsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeDetailStepsInnerCWProxy get copyWith =>
      _$RecipeDetailStepsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDetailStepsInner _$RecipeDetailStepsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeDetailStepsInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['order', 'text', 'images']);
  final val = RecipeDetailStepsInner(
    order: $checkedConvert('order', (v) => (v as num).toInt()),
    name: $checkedConvert('name', (v) => v as String?),
    text: $checkedConvert('text', (v) => v as String),
    note: $checkedConvert('note', (v) => v as String?),
    images: $checkedConvert(
      'images',
      (v) => (v as List<dynamic>)
          .map(
            (e) => RecipeDetailStepsInnerImagesInner.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
    timerSeconds: $checkedConvert('timerSeconds', (v) => (v as num?)?.toInt()),
    timerLabel: $checkedConvert('timerLabel', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailStepsInnerToJson(
  RecipeDetailStepsInner instance,
) => <String, dynamic>{
  'order': instance.order,
  'name': ?instance.name,
  'text': instance.text,
  'note': ?instance.note,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'timerSeconds': ?instance.timerSeconds,
  'timerLabel': ?instance.timerLabel,
};
