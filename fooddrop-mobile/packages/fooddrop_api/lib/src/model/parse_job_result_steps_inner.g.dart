// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_job_result_steps_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseJobResultStepsInnerCWProxy {
  ParseJobResultStepsInner text(String text);

  ParseJobResultStepsInner timerSeconds(int? timerSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultStepsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultStepsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultStepsInner call({String text, int? timerSeconds});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseJobResultStepsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseJobResultStepsInner.copyWith.fieldName(...)`
class _$ParseJobResultStepsInnerCWProxyImpl
    implements _$ParseJobResultStepsInnerCWProxy {
  const _$ParseJobResultStepsInnerCWProxyImpl(this._value);

  final ParseJobResultStepsInner _value;

  @override
  ParseJobResultStepsInner text(String text) => this(text: text);

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
    Object? text = const $CopyWithPlaceholder(),
    Object? timerSeconds = const $CopyWithPlaceholder(),
  }) {
    return ParseJobResultStepsInner(
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
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
  $checkKeys(json, requiredKeys: const ['text']);
  final val = ParseJobResultStepsInner(
    text: $checkedConvert('text', (v) => v as String),
    timerSeconds: $checkedConvert('timerSeconds', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$ParseJobResultStepsInnerToJson(
  ParseJobResultStepsInner instance,
) => <String, dynamic>{
  'text': instance.text,
  'timerSeconds': ?instance.timerSeconds,
};
