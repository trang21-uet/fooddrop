// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_steps_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeDetailStepsInnerCWProxy {
  RecipeDetailStepsInner order(int order);

  RecipeDetailStepsInner text(String text);

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
    String text,
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
  RecipeDetailStepsInner text(String text) => this(text: text);

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
    Object? text = const $CopyWithPlaceholder(),
    Object? timerSeconds = const $CopyWithPlaceholder(),
    Object? timerLabel = const $CopyWithPlaceholder(),
  }) {
    return RecipeDetailStepsInner(
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
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
  $checkKeys(json, requiredKeys: const ['order', 'text']);
  final val = RecipeDetailStepsInner(
    order: $checkedConvert('order', (v) => (v as num).toInt()),
    text: $checkedConvert('text', (v) => v as String),
    timerSeconds: $checkedConvert('timerSeconds', (v) => (v as num?)?.toInt()),
    timerLabel: $checkedConvert('timerLabel', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RecipeDetailStepsInnerToJson(
  RecipeDetailStepsInner instance,
) => <String, dynamic>{
  'order': instance.order,
  'text': instance.text,
  'timerSeconds': ?instance.timerSeconds,
  'timerLabel': ?instance.timerLabel,
};
