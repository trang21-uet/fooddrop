// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_spin.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaSpinCWProxy {
  GachaSpin spinId(String spinId);

  GachaSpin caseType(GachaSpinCaseTypeEnum caseType);

  GachaSpin createdAt(DateTime createdAt);

  GachaSpin result(GachaSpinResult result);

  GachaSpin reel(List<GachaSpinResult> reel);

  GachaSpin winningIndex(int winningIndex);

  GachaSpin offsetJitter(num offsetJitter);

  GachaSpin poolSize(int poolSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpin(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpin(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpin call({
    String spinId,
    GachaSpinCaseTypeEnum caseType,
    DateTime createdAt,
    GachaSpinResult result,
    List<GachaSpinResult> reel,
    int winningIndex,
    num offsetJitter,
    int poolSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaSpin.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaSpin.copyWith.fieldName(...)`
class _$GachaSpinCWProxyImpl implements _$GachaSpinCWProxy {
  const _$GachaSpinCWProxyImpl(this._value);

  final GachaSpin _value;

  @override
  GachaSpin spinId(String spinId) => this(spinId: spinId);

  @override
  GachaSpin caseType(GachaSpinCaseTypeEnum caseType) =>
      this(caseType: caseType);

  @override
  GachaSpin createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  GachaSpin result(GachaSpinResult result) => this(result: result);

  @override
  GachaSpin reel(List<GachaSpinResult> reel) => this(reel: reel);

  @override
  GachaSpin winningIndex(int winningIndex) => this(winningIndex: winningIndex);

  @override
  GachaSpin offsetJitter(num offsetJitter) => this(offsetJitter: offsetJitter);

  @override
  GachaSpin poolSize(int poolSize) => this(poolSize: poolSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpin(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpin(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpin call({
    Object? spinId = const $CopyWithPlaceholder(),
    Object? caseType = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
    Object? reel = const $CopyWithPlaceholder(),
    Object? winningIndex = const $CopyWithPlaceholder(),
    Object? offsetJitter = const $CopyWithPlaceholder(),
    Object? poolSize = const $CopyWithPlaceholder(),
  }) {
    return GachaSpin(
      spinId: spinId == const $CopyWithPlaceholder()
          ? _value.spinId
          // ignore: cast_nullable_to_non_nullable
          : spinId as String,
      caseType: caseType == const $CopyWithPlaceholder()
          ? _value.caseType
          // ignore: cast_nullable_to_non_nullable
          : caseType as GachaSpinCaseTypeEnum,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      result: result == const $CopyWithPlaceholder()
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as GachaSpinResult,
      reel: reel == const $CopyWithPlaceholder()
          ? _value.reel
          // ignore: cast_nullable_to_non_nullable
          : reel as List<GachaSpinResult>,
      winningIndex: winningIndex == const $CopyWithPlaceholder()
          ? _value.winningIndex
          // ignore: cast_nullable_to_non_nullable
          : winningIndex as int,
      offsetJitter: offsetJitter == const $CopyWithPlaceholder()
          ? _value.offsetJitter
          // ignore: cast_nullable_to_non_nullable
          : offsetJitter as num,
      poolSize: poolSize == const $CopyWithPlaceholder()
          ? _value.poolSize
          // ignore: cast_nullable_to_non_nullable
          : poolSize as int,
    );
  }
}

extension $GachaSpinCopyWith on GachaSpin {
  /// Returns a callable class that can be used as follows: `instanceOfGachaSpin.copyWith(...)` or like so:`instanceOfGachaSpin.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaSpinCWProxy get copyWith => _$GachaSpinCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaSpin _$GachaSpinFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GachaSpin', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'spinId',
      'caseType',
      'createdAt',
      'result',
      'reel',
      'winningIndex',
      'offsetJitter',
      'poolSize',
    ],
  );
  final val = GachaSpin(
    spinId: $checkedConvert('spinId', (v) => v as String),
    caseType: $checkedConvert(
      'caseType',
      (v) => $enumDecode(_$GachaSpinCaseTypeEnumEnumMap, v),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    result: $checkedConvert(
      'result',
      (v) => GachaSpinResult.fromJson(v as Map<String, dynamic>),
    ),
    reel: $checkedConvert(
      'reel',
      (v) => (v as List<dynamic>)
          .map((e) => GachaSpinResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    winningIndex: $checkedConvert('winningIndex', (v) => (v as num).toInt()),
    offsetJitter: $checkedConvert('offsetJitter', (v) => v as num),
    poolSize: $checkedConvert('poolSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$GachaSpinToJson(GachaSpin instance) => <String, dynamic>{
  'spinId': instance.spinId,
  'caseType': _$GachaSpinCaseTypeEnumEnumMap[instance.caseType]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'result': instance.result.toJson(),
  'reel': instance.reel.map((e) => e.toJson()).toList(),
  'winningIndex': instance.winningIndex,
  'offsetJitter': instance.offsetJitter,
  'poolSize': instance.poolSize,
};

const _$GachaSpinCaseTypeEnumEnumMap = {GachaSpinCaseTypeEnum.cook: 'cook'};
