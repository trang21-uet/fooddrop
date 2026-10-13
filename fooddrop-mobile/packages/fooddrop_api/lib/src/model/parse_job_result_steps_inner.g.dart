// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_job_result_steps_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseJobResultStepsInnerCWProxy {
  ParseJobResultStepsInner name(String? name);

  ParseJobResultStepsInner text(String text);

  ParseJobResultStepsInner note(String? note);

  ParseJobResultStepsInner images(
    List<ParseJobResultStepsInnerImagesInner> images,
  );

  ParseJobResultStepsInner timerSeconds(int? timerSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultStepsInner call({
    String? name,
    String text,
    String? note,
    List<ParseJobResultStepsInnerImagesInner> images,
    int? timerSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseJobResultStepsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseJobResultStepsInner.copyWith.fieldName(...)`
class _$ParseJobResultStepsInnerCWProxyImpl
    implements _$ParseJobResultStepsInnerCWProxy {
  const _$ParseJobResultStepsInnerCWProxyImpl(this._value);

  final ParseJobResultStepsInner _value;

  @override
  ParseJobResultStepsInner name(String? name) => this(name: name);

  @override
  ParseJobResultStepsInner text(String text) => this(text: text);

  @override
  ParseJobResultStepsInner note(String? note) => this(note: note);

  @override
  ParseJobResultStepsInner images(
    List<ParseJobResultStepsInnerImagesInner> images,
  ) => this(images: images);

  @override
  ParseJobResultStepsInner timerSeconds(int? timerSeconds) =>
      this(timerSeconds: timerSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultStepsInner call({
    Object? name = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? images = const $CopyWithPlaceholder(),
    Object? timerSeconds = const $CopyWithPlaceholder(),
  }) {
    return ParseJobResultStepsInner(
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
          : images as List<ParseJobResultStepsInnerImagesInner>,
      timerSeconds: timerSeconds == const $CopyWithPlaceholder()
          ? _value.timerSeconds
          // ignore: cast_nullable_to_non_nullable
          : timerSeconds as int?,
    );
  }
}

extension $ParseJobResultStepsInnerCopyWith on ParseJobResultStepsInner {
  /// Returns a callable class that can be used as follows: `instanceOfParseJobResultStepsInner.copyWith(...)` or like so:`instanceOfParseJobResultStepsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParseJobResultStepsInnerCWProxy get copyWith =>
      _$ParseJobResultStepsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseJobResultStepsInner _$ParseJobResultStepsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ParseJobResultStepsInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'text', 'note', 'images']);
  final val = ParseJobResultStepsInner(
    name: $checkedConvert('name', (v) => v as String?),
    text: $checkedConvert('text', (v) => v as String),
    note: $checkedConvert('note', (v) => v as String?),
    images: $checkedConvert(
      'images',
      (v) => (v as List<dynamic>)
          .map(
            (e) => ParseJobResultStepsInnerImagesInner.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
    timerSeconds: $checkedConvert('timerSeconds', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$ParseJobResultStepsInnerToJson(
  ParseJobResultStepsInner instance,
) => <String, dynamic>{
  'name': instance.name,
  'text': instance.text,
  'note': instance.note,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'timerSeconds': ?instance.timerSeconds,
};
