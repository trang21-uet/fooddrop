// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_spin_history_items_inner_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaSpinHistoryItemsInnerResultCWProxy {
  GachaSpinHistoryItemsInnerResult id(String id);

  GachaSpinHistoryItemsInnerResult title(String title);

  GachaSpinHistoryItemsInnerResult imageUrl(String? imageUrl);

  GachaSpinHistoryItemsInnerResult rarity(
    GachaSpinHistoryItemsInnerResultRarityEnum rarity,
  );

  GachaSpinHistoryItemsInnerResult totalMinutes(int totalMinutes);

  GachaSpinHistoryItemsInnerResult difficulty(int difficulty);

  GachaSpinHistoryItemsInnerResult baseServings(int baseServings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinHistoryItemsInnerResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinHistoryItemsInnerResult(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinHistoryItemsInnerResult call({
    String id,
    String title,
    String? imageUrl,
    GachaSpinHistoryItemsInnerResultRarityEnum rarity,
    int totalMinutes,
    int difficulty,
    int baseServings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaSpinHistoryItemsInnerResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaSpinHistoryItemsInnerResult.copyWith.fieldName(...)`
class _$GachaSpinHistoryItemsInnerResultCWProxyImpl
    implements _$GachaSpinHistoryItemsInnerResultCWProxy {
  const _$GachaSpinHistoryItemsInnerResultCWProxyImpl(this._value);

  final GachaSpinHistoryItemsInnerResult _value;

  @override
  GachaSpinHistoryItemsInnerResult id(String id) => this(id: id);

  @override
  GachaSpinHistoryItemsInnerResult title(String title) => this(title: title);

  @override
  GachaSpinHistoryItemsInnerResult imageUrl(String? imageUrl) =>
      this(imageUrl: imageUrl);

  @override
  GachaSpinHistoryItemsInnerResult rarity(
    GachaSpinHistoryItemsInnerResultRarityEnum rarity,
  ) => this(rarity: rarity);

  @override
  GachaSpinHistoryItemsInnerResult totalMinutes(int totalMinutes) =>
      this(totalMinutes: totalMinutes);

  @override
  GachaSpinHistoryItemsInnerResult difficulty(int difficulty) =>
      this(difficulty: difficulty);

  @override
  GachaSpinHistoryItemsInnerResult baseServings(int baseServings) =>
      this(baseServings: baseServings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinHistoryItemsInnerResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinHistoryItemsInnerResult(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinHistoryItemsInnerResult call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? rarity = const $CopyWithPlaceholder(),
    Object? totalMinutes = const $CopyWithPlaceholder(),
    Object? difficulty = const $CopyWithPlaceholder(),
    Object? baseServings = const $CopyWithPlaceholder(),
  }) {
    return GachaSpinHistoryItemsInnerResult(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      imageUrl: imageUrl == const $CopyWithPlaceholder()
          ? _value.imageUrl
          // ignore: cast_nullable_to_non_nullable
          : imageUrl as String?,
      rarity: rarity == const $CopyWithPlaceholder()
          ? _value.rarity
          // ignore: cast_nullable_to_non_nullable
          : rarity as GachaSpinHistoryItemsInnerResultRarityEnum,
      totalMinutes: totalMinutes == const $CopyWithPlaceholder()
          ? _value.totalMinutes
          // ignore: cast_nullable_to_non_nullable
          : totalMinutes as int,
      difficulty: difficulty == const $CopyWithPlaceholder()
          ? _value.difficulty
          // ignore: cast_nullable_to_non_nullable
          : difficulty as int,
      baseServings: baseServings == const $CopyWithPlaceholder()
          ? _value.baseServings
          // ignore: cast_nullable_to_non_nullable
          : baseServings as int,
    );
  }
}

extension $GachaSpinHistoryItemsInnerResultCopyWith
    on GachaSpinHistoryItemsInnerResult {
  /// Returns a callable class that can be used as follows: `instanceOfGachaSpinHistoryItemsInnerResult.copyWith(...)` or like so:`instanceOfGachaSpinHistoryItemsInnerResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaSpinHistoryItemsInnerResultCWProxy get copyWith =>
      _$GachaSpinHistoryItemsInnerResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaSpinHistoryItemsInnerResult _$GachaSpinHistoryItemsInnerResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GachaSpinHistoryItemsInnerResult', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'title',
      'imageUrl',
      'rarity',
      'totalMinutes',
      'difficulty',
      'baseServings',
    ],
  );
  final val = GachaSpinHistoryItemsInnerResult(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    rarity: $checkedConvert(
      'rarity',
      (v) =>
          $enumDecode(_$GachaSpinHistoryItemsInnerResultRarityEnumEnumMap, v),
    ),
    totalMinutes: $checkedConvert('totalMinutes', (v) => (v as num).toInt()),
    difficulty: $checkedConvert('difficulty', (v) => (v as num).toInt()),
    baseServings: $checkedConvert('baseServings', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$GachaSpinHistoryItemsInnerResultToJson(
  GachaSpinHistoryItemsInnerResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'imageUrl': instance.imageUrl,
  'rarity':
      _$GachaSpinHistoryItemsInnerResultRarityEnumEnumMap[instance.rarity]!,
  'totalMinutes': instance.totalMinutes,
  'difficulty': instance.difficulty,
  'baseServings': instance.baseServings,
};

const _$GachaSpinHistoryItemsInnerResultRarityEnumEnumMap = {
  GachaSpinHistoryItemsInnerResultRarityEnum.white: 'white',
  GachaSpinHistoryItemsInnerResultRarityEnum.blue: 'blue',
  GachaSpinHistoryItemsInnerResultRarityEnum.purple: 'purple',
  GachaSpinHistoryItemsInnerResultRarityEnum.pink: 'pink',
  GachaSpinHistoryItemsInnerResultRarityEnum.red: 'red',
};
