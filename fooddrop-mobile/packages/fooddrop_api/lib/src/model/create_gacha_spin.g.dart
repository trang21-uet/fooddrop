// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_gacha_spin.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateGachaSpinCWProxy {
  CreateGachaSpin caseType(CreateGachaSpinCaseTypeEnum caseType);

  CreateGachaSpin caseId(String caseId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateGachaSpin(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateGachaSpin(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateGachaSpin call({CreateGachaSpinCaseTypeEnum caseType, String caseId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateGachaSpin.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateGachaSpin.copyWith.fieldName(...)`
class _$CreateGachaSpinCWProxyImpl implements _$CreateGachaSpinCWProxy {
  const _$CreateGachaSpinCWProxyImpl(this._value);

  final CreateGachaSpin _value;

  @override
  CreateGachaSpin caseType(CreateGachaSpinCaseTypeEnum caseType) =>
      this(caseType: caseType);

  @override
  CreateGachaSpin caseId(String caseId) => this(caseId: caseId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateGachaSpin(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateGachaSpin(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateGachaSpin call({
    Object? caseType = const $CopyWithPlaceholder(),
    Object? caseId = const $CopyWithPlaceholder(),
  }) {
    return CreateGachaSpin(
      caseType: caseType == const $CopyWithPlaceholder()
          ? _value.caseType
          // ignore: cast_nullable_to_non_nullable
          : caseType as CreateGachaSpinCaseTypeEnum,
      caseId: caseId == const $CopyWithPlaceholder()
          ? _value.caseId
          // ignore: cast_nullable_to_non_nullable
          : caseId as String,
    );
  }
}

extension $CreateGachaSpinCopyWith on CreateGachaSpin {
  /// Returns a callable class that can be used as follows: `instanceOfCreateGachaSpin.copyWith(...)` or like so:`instanceOfCreateGachaSpin.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateGachaSpinCWProxy get copyWith => _$CreateGachaSpinCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGachaSpin _$CreateGachaSpinFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateGachaSpin', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['caseType', 'caseId']);
      final val = CreateGachaSpin(
        caseType: $checkedConvert(
          'caseType',
          (v) => $enumDecode(_$CreateGachaSpinCaseTypeEnumEnumMap, v),
        ),
        caseId: $checkedConvert('caseId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CreateGachaSpinToJson(CreateGachaSpin instance) =>
    <String, dynamic>{
      'caseType': _$CreateGachaSpinCaseTypeEnumEnumMap[instance.caseType]!,
      'caseId': instance.caseId,
    };

const _$CreateGachaSpinCaseTypeEnumEnumMap = {
  CreateGachaSpinCaseTypeEnum.cook: 'cook',
};
