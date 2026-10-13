// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_spin_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GachaSpinResultCWProxy {
  GachaSpinResult id(String id);

  GachaSpinResult title(String title);

  GachaSpinResult imageUrl(String? imageUrl);

  GachaSpinResult rarity(GachaSpinResultRarityEnum rarity);

  GachaSpinResult totalMinutes(int totalMinutes);

  GachaSpinResult difficulty(int difficulty);

  GachaSpinResult baseServings(int baseServings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinResult(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinResult call({
    String id,
    String title,
    String? imageUrl,
    GachaSpinResultRarityEnum rarity,
    int totalMinutes,
    int difficulty,
    int baseServings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGachaSpinResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGachaSpinResult.copyWith.fieldName(...)`
class _$GachaSpinResultCWProxyImpl implements _$GachaSpinResultCWProxy {
  const _$GachaSpinResultCWProxyImpl(this._value);

  final GachaSpinResult _value;

  @override
  GachaSpinResult id(String id) => this(id: id);

  @override
  GachaSpinResult title(String title) => this(title: title);

  @override
  GachaSpinResult imageUrl(String? imageUrl) => this(imageUrl: imageUrl);

  @override
  GachaSpinResult rarity(GachaSpinResultRarityEnum rarity) =>
      this(rarity: rarity);

  @override
  GachaSpinResult totalMinutes(int totalMinutes) =>
      this(totalMinutes: totalMinutes);

  @override
  GachaSpinResult difficulty(int difficulty) => this(difficulty: difficulty);

  @override
  GachaSpinResult baseServings(int baseServings) =>
      this(baseServings: baseServings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GachaSpinResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GachaSpinResult(...).copyWith(id: 12, name: "My name")
  /// ````
  GachaSpinResult call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? rarity = const $CopyWithPlaceholder(),
    Object? totalMinutes = const $CopyWithPlaceholder(),
    Object? difficulty = const $CopyWithPlaceholder(),
    Object? baseServings = const $CopyWithPlaceholder(),
  }) {
    return GachaSpinResult(
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
          : rarity as GachaSpinResultRarityEnum,
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

extension $GachaSpinResultCopyWith on GachaSpinResult {
  /// Returns a callable class that can be used as follows: `instanceOfGachaSpinResult.copyWith(...)` or like so:`instanceOfGachaSpinResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GachaSpinResultCWProxy get copyWith => _$GachaSpinResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaSpinResult _$GachaSpinResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GachaSpinResult', json, ($checkedConvert) {
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
  final val = GachaSpinResult(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    rarity: $checkedConvert(
      'rarity',
      (v) => $enumDecode(_$GachaSpinResultRarityEnumEnumMap, v),
    ),
    totalMinutes: $checkedConvert('totalMinutes', (v) => (v as num).toInt()),
    difficulty: $checkedConvert('difficulty', (v) => (v as num).toInt()),
    baseServings: $checkedConvert('baseServings', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$GachaSpinResultToJson(GachaSpinResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'rarity': _$GachaSpinResultRarityEnumEnumMap[instance.rarity]!,
      'totalMinutes': instance.totalMinutes,
      'difficulty': instance.difficulty,
      'baseServings': instance.baseServings,
    };

const _$GachaSpinResultRarityEnumEnumMap = {
  GachaSpinResultRarityEnum.white: 'white',
  GachaSpinResultRarityEnum.blue: 'blue',
  GachaSpinResultRarityEnum.purple: 'purple',
  GachaSpinResultRarityEnum.pink: 'pink',
  GachaSpinResultRarityEnum.red: 'red',
};
