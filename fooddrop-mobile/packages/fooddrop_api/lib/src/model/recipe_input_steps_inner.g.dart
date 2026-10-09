// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_input_steps_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeInputStepsInnerCWProxy {
  RecipeInputStepsInner name(String? name);

  RecipeInputStepsInner text(String text);

  RecipeInputStepsInner note(String? note);

  RecipeInputStepsInner images(List<String>? images);

  RecipeInputStepsInner timerSeconds(int? timerSeconds);

  RecipeInputStepsInner timerLabel(String? timerLabel);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeInputStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeInputStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeInputStepsInner call({
    String? name,
    String text,
    String? note,
    List<String>? images,
    int? timerSeconds,
    String? timerLabel,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipeInputStepsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipeInputStepsInner.copyWith.fieldName(...)`
class _$RecipeInputStepsInnerCWProxyImpl
    implements _$RecipeInputStepsInnerCWProxy {
  const _$RecipeInputStepsInnerCWProxyImpl(this._value);

  final RecipeInputStepsInner _value;

  @override
  RecipeInputStepsInner name(String? name) => this(name: name);

  @override
  RecipeInputStepsInner text(String text) => this(text: text);

  @override
  RecipeInputStepsInner note(String? note) => this(note: note);

  @override
  RecipeInputStepsInner images(List<String>? images) => this(images: images);

  @override
  RecipeInputStepsInner timerSeconds(int? timerSeconds) =>
      this(timerSeconds: timerSeconds);

  @override
  RecipeInputStepsInner timerLabel(String? timerLabel) =>
      this(timerLabel: timerLabel);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecipeInputStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecipeInputStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  RecipeInputStepsInner call({
    Object? name = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? images = const $CopyWithPlaceholder(),
    Object? timerSeconds = const $CopyWithPlaceholder(),
    Object? timerLabel = const $CopyWithPlaceholder(),
  }) {
    return RecipeInputStepsInner(
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
          : images as List<String>?,
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

extension $RecipeInputStepsInnerCopyWith on RecipeInputStepsInner {
  /// Returns a callable class that can be used as follows: `instanceOfRecipeInputStepsInner.copyWith(...)` or like so:`instanceOfRecipeInputStepsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeInputStepsInnerCWProxy get copyWith =>
      _$RecipeInputStepsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeInputStepsInner _$RecipeInputStepsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecipeInputStepsInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['text']);
  final val = RecipeInputStepsInner(
    name: $checkedConvert('name', (v) => v as String?),
    text: $checkedConvert('text', (v) => v as String),
    note: $checkedConvert('note', (v) => v as String?),
    images: $checkedConvert(
      'images',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
    ),
    timerSeconds: $checkedConvert('timerSeconds', (v) => (v as num?)?.toInt()),
    timerLabel: $checkedConvert('timerLabel', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RecipeInputStepsInnerToJson(
  RecipeInputStepsInner instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'text': instance.text,
  'note': ?instance.note,
  'images': ?instance.images,
  'timerSeconds': ?instance.timerSeconds,
  'timerLabel': ?instance.timerLabel,
};
