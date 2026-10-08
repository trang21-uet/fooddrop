// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UnitCWProxy {
  Unit code(String code);

  Unit nameVi(String nameVi);

  Unit nameEn(String nameEn);

  Unit kind(UnitKindEnum kind);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Unit(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Unit(...).copyWith(id: 12, name: "My name")
  /// ````
  Unit call({String code, String nameVi, String nameEn, UnitKindEnum kind});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUnit.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUnit.copyWith.fieldName(...)`
class _$UnitCWProxyImpl implements _$UnitCWProxy {
  const _$UnitCWProxyImpl(this._value);

  final Unit _value;

  @override
  Unit code(String code) => this(code: code);

  @override
  Unit nameVi(String nameVi) => this(nameVi: nameVi);

  @override
  Unit nameEn(String nameEn) => this(nameEn: nameEn);

  @override
  Unit kind(UnitKindEnum kind) => this(kind: kind);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Unit(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Unit(...).copyWith(id: 12, name: "My name")
  /// ````
  Unit call({
    Object? code = const $CopyWithPlaceholder(),
    Object? nameVi = const $CopyWithPlaceholder(),
    Object? nameEn = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
  }) {
    return Unit(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      nameVi: nameVi == const $CopyWithPlaceholder()
          ? _value.nameVi
          // ignore: cast_nullable_to_non_nullable
          : nameVi as String,
      nameEn: nameEn == const $CopyWithPlaceholder()
          ? _value.nameEn
          // ignore: cast_nullable_to_non_nullable
          : nameEn as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as UnitKindEnum,
    );
  }
}

extension $UnitCopyWith on Unit {
  /// Returns a callable class that can be used as follows: `instanceOfUnit.copyWith(...)` or like so:`instanceOfUnit.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UnitCWProxy get copyWith => _$UnitCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unit _$UnitFromJson(Map<String, dynamic> json) => $checkedCreate('Unit', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['code', 'nameVi', 'nameEn', 'kind']);
  final val = Unit(
    code: $checkedConvert('code', (v) => v as String),
    nameVi: $checkedConvert('nameVi', (v) => v as String),
    nameEn: $checkedConvert('nameEn', (v) => v as String),
    kind: $checkedConvert('kind', (v) => $enumDecode(_$UnitKindEnumEnumMap, v)),
  );
  return val;
});

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
  'code': instance.code,
  'nameVi': instance.nameVi,
  'nameEn': instance.nameEn,
  'kind': _$UnitKindEnumEnumMap[instance.kind]!,
};

const _$UnitKindEnumEnumMap = {
  UnitKindEnum.mass: 'mass',
  UnitKindEnum.volume: 'volume',
  UnitKindEnum.count: 'count',
  UnitKindEnum.other: 'other',
};
