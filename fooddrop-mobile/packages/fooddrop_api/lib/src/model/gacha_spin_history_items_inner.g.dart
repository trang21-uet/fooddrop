// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_spin_history_items_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaSpinHistoryItemsInnerCWProxy {
  GachaSpinHistoryItemsInner id(String id);

  GachaSpinHistoryItemsInner caseType(
    GachaSpinHistoryItemsInnerCaseTypeEnum caseType,
  );

  GachaSpinHistoryItemsInner createdAt(DateTime createdAt);

  GachaSpinHistoryItemsInner result(GachaSpinHistoryItemsInnerResult? result);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinHistoryItemsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinHistoryItemsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinHistoryItemsInner call({
    String id,
    GachaSpinHistoryItemsInnerCaseTypeEnum caseType,
    DateTime createdAt,
    GachaSpinHistoryItemsInnerResult? result,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaSpinHistoryItemsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaSpinHistoryItemsInner.copyWith.fieldName(...)`
class _$GachaSpinHistoryItemsInnerCWProxyImpl
    implements _$GachaSpinHistoryItemsInnerCWProxy {
  const _$GachaSpinHistoryItemsInnerCWProxyImpl(this._value);

  final GachaSpinHistoryItemsInner _value;

  @override
  GachaSpinHistoryItemsInner id(String id) => this(id: id);

  @override
  GachaSpinHistoryItemsInner caseType(
    GachaSpinHistoryItemsInnerCaseTypeEnum caseType,
  ) => this(caseType: caseType);

  @override
  GachaSpinHistoryItemsInner createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  GachaSpinHistoryItemsInner result(GachaSpinHistoryItemsInnerResult? result) =>
      this(result: result);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinHistoryItemsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinHistoryItemsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinHistoryItemsInner call({
    Object? id = const $CopyWithPlaceholder(),
    Object? caseType = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
  }) {
    return GachaSpinHistoryItemsInner(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      caseType: caseType == const $CopyWithPlaceholder()
          ? _value.caseType
          // ignore: cast_nullable_to_non_nullable
          : caseType as GachaSpinHistoryItemsInnerCaseTypeEnum,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      result: result == const $CopyWithPlaceholder()
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as GachaSpinHistoryItemsInnerResult?,
    );
  }
}

extension $GachaSpinHistoryItemsInnerCopyWith on GachaSpinHistoryItemsInner {
  /// Returns a callable class that can be used as follows: `instanceOfGachaSpinHistoryItemsInner.copyWith(...)` or like so:`instanceOfGachaSpinHistoryItemsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaSpinHistoryItemsInnerCWProxy get copyWith =>
      _$GachaSpinHistoryItemsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaSpinHistoryItemsInner _$GachaSpinHistoryItemsInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GachaSpinHistoryItemsInner', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'caseType', 'createdAt', 'result'],
  );
  final val = GachaSpinHistoryItemsInner(
    id: $checkedConvert('id', (v) => v as String),
    caseType: $checkedConvert(
      'caseType',
      (v) => $enumDecode(_$GachaSpinHistoryItemsInnerCaseTypeEnumEnumMap, v),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    result: $checkedConvert(
      'result',
      (v) => v == null
          ? null
          : GachaSpinHistoryItemsInnerResult.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
  );
  return val;
});

Map<String, dynamic> _$GachaSpinHistoryItemsInnerToJson(
  GachaSpinHistoryItemsInner instance,
) => <String, dynamic>{
  'id': instance.id,
  'caseType':
      _$GachaSpinHistoryItemsInnerCaseTypeEnumEnumMap[instance.caseType]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'result': instance.result?.toJson(),
};

const _$GachaSpinHistoryItemsInnerCaseTypeEnumEnumMap = {
  GachaSpinHistoryItemsInnerCaseTypeEnum.cook: 'cook',
};
