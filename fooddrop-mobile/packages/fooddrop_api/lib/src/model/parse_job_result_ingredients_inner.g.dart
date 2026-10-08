// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_job_result_ingredients_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParseJobResultIngredientsInnerCWProxy {
  ParseJobResultIngredientsInner name(String name);

  ParseJobResultIngredientsInner quantity(num? quantity);

  ParseJobResultIngredientsInner unit(String? unit);

  ParseJobResultIngredientsInner note(String? note);

  ParseJobResultIngredientsInner matchedName(String? matchedName);

  ParseJobResultIngredientsInner ingredientId(String? ingredientId);

  ParseJobResultIngredientsInner isNew(bool isNew);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultIngredientsInner call({
    String name,
    num? quantity,
    String? unit,
    String? note,
    String? matchedName,
    String? ingredientId,
    bool isNew,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParseJobResultIngredientsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParseJobResultIngredientsInner.copyWith.fieldName(...)`
class _$ParseJobResultIngredientsInnerCWProxyImpl
    implements _$ParseJobResultIngredientsInnerCWProxy {
  const _$ParseJobResultIngredientsInnerCWProxyImpl(this._value);

  final ParseJobResultIngredientsInner _value;

  @override
  ParseJobResultIngredientsInner name(String name) => this(name: name);

  @override
  ParseJobResultIngredientsInner quantity(num? quantity) =>
      this(quantity: quantity);

  @override
  ParseJobResultIngredientsInner unit(String? unit) => this(unit: unit);

  @override
  ParseJobResultIngredientsInner note(String? note) => this(note: note);

  @override
  ParseJobResultIngredientsInner matchedName(String? matchedName) =>
      this(matchedName: matchedName);

  @override
  ParseJobResultIngredientsInner ingredientId(String? ingredientId) =>
      this(ingredientId: ingredientId);

  @override
  ParseJobResultIngredientsInner isNew(bool isNew) => this(isNew: isNew);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ParseJobResultIngredientsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ParseJobResultIngredientsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ParseJobResultIngredientsInner call({
    Object? name = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? matchedName = const $CopyWithPlaceholder(),
    Object? ingredientId = const $CopyWithPlaceholder(),
    Object? isNew = const $CopyWithPlaceholder(),
  }) {
    return ParseJobResultIngredientsInner(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as num?,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as String?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      matchedName: matchedName == const $CopyWithPlaceholder()
          ? _value.matchedName
          // ignore: cast_nullable_to_non_nullable
          : matchedName as String?,
      ingredientId: ingredientId == const $CopyWithPlaceholder()
          ? _value.ingredientId
          // ignore: cast_nullable_to_non_nullable
          : ingredientId as String?,
      isNew: isNew == const $CopyWithPlaceholder()
          ? _value.isNew
          // ignore: cast_nullable_to_non_nullable
          : isNew as bool,
    );
  }
}

extension $ParseJobResultIngredientsInnerCopyWith
    on ParseJobResultIngredientsInner {
  /// Returns a callable class that can be used as follows: `instanceOfParseJobResultIngredientsInner.copyWith(...)` or like so:`instanceOfParseJobResultIngredientsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParseJobResultIngredientsInnerCWProxy get copyWith =>
      _$ParseJobResultIngredientsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParseJobResultIngredientsInner _$ParseJobResultIngredientsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ParseJobResultIngredientsInner', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'name',
      'quantity',
      'unit',
      'note',
      'matchedName',
      'ingredientId',
      'isNew',
    ],
  );
  final val = ParseJobResultIngredientsInner(
    name: $checkedConvert('name', (v) => v as String),
    quantity: $checkedConvert('quantity', (v) => v as num?),
    unit: $checkedConvert('unit', (v) => v as String?),
    note: $checkedConvert('note', (v) => v as String?),
    matchedName: $checkedConvert('matchedName', (v) => v as String?),
    ingredientId: $checkedConvert('ingredientId', (v) => v as String?),
    isNew: $checkedConvert('isNew', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$ParseJobResultIngredientsInnerToJson(
  ParseJobResultIngredientsInner instance,
) => <String, dynamic>{
  'name': instance.name,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'note': instance.note,
  'matchedName': instance.matchedName,
  'ingredientId': instance.ingredientId,
  'isNew': instance.isNew,
};
