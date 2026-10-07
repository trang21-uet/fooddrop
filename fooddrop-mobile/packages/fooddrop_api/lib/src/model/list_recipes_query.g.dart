// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_recipes_query.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ListRecipesQueryCWProxy {
  ListRecipesQuery tags(String? tags);

  ListRecipesQuery rarity(String? rarity);

  ListRecipesQuery maxMinutes(int? maxMinutes);

  ListRecipesQuery q(String? q);

  ListRecipesQuery cursor(String? cursor);

  ListRecipesQuery limit(int? limit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ListRecipesQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ListRecipesQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  ListRecipesQuery call({
    String? tags,
    String? rarity,
    int? maxMinutes,
    String? q,
    String? cursor,
    int? limit,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfListRecipesQuery.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfListRecipesQuery.copyWith.fieldName(...)`
class _$ListRecipesQueryCWProxyImpl implements _$ListRecipesQueryCWProxy {
  const _$ListRecipesQueryCWProxyImpl(this._value);

  final ListRecipesQuery _value;

  @override
  ListRecipesQuery tags(String? tags) => this(tags: tags);

  @override
  ListRecipesQuery rarity(String? rarity) => this(rarity: rarity);

  @override
  ListRecipesQuery maxMinutes(int? maxMinutes) => this(maxMinutes: maxMinutes);

  @override
  ListRecipesQuery q(String? q) => this(q: q);

  @override
  ListRecipesQuery cursor(String? cursor) => this(cursor: cursor);

  @override
  ListRecipesQuery limit(int? limit) => this(limit: limit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ListRecipesQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ListRecipesQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  ListRecipesQuery call({
    Object? tags = const $CopyWithPlaceholder(),
    Object? rarity = const $CopyWithPlaceholder(),
    Object? maxMinutes = const $CopyWithPlaceholder(),
    Object? q = const $CopyWithPlaceholder(),
    Object? cursor = const $CopyWithPlaceholder(),
    Object? limit = const $CopyWithPlaceholder(),
  }) {
    return ListRecipesQuery(
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as String?,
      rarity: rarity == const $CopyWithPlaceholder()
          ? _value.rarity
          // ignore: cast_nullable_to_non_nullable
          : rarity as String?,
      maxMinutes: maxMinutes == const $CopyWithPlaceholder()
          ? _value.maxMinutes
          // ignore: cast_nullable_to_non_nullable
          : maxMinutes as int?,
      q: q == const $CopyWithPlaceholder()
          ? _value.q
          // ignore: cast_nullable_to_non_nullable
          : q as String?,
      cursor: cursor == const $CopyWithPlaceholder()
          ? _value.cursor
          // ignore: cast_nullable_to_non_nullable
          : cursor as String?,
      limit: limit == const $CopyWithPlaceholder()
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int?,
    );
  }
}

extension $ListRecipesQueryCopyWith on ListRecipesQuery {
  /// Returns a callable class that can be used as follows: `instanceOfListRecipesQuery.copyWith(...)` or like so:`instanceOfListRecipesQuery.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ListRecipesQueryCWProxy get copyWith => _$ListRecipesQueryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRecipesQuery _$ListRecipesQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ListRecipesQuery', json, ($checkedConvert) {
      final val = ListRecipesQuery(
        tags: $checkedConvert('tags', (v) => v as String?),
        rarity: $checkedConvert('rarity', (v) => v as String?),
        maxMinutes: $checkedConvert('maxMinutes', (v) => (v as num?)?.toInt()),
        q: $checkedConvert('q', (v) => v as String?),
        cursor: $checkedConvert('cursor', (v) => v as String?),
        limit: $checkedConvert('limit', (v) => (v as num?)?.toInt() ?? 20),
      );
      return val;
    });

Map<String, dynamic> _$ListRecipesQueryToJson(ListRecipesQuery instance) =>
    <String, dynamic>{
      'tags': ?instance.tags,
      'rarity': ?instance.rarity,
      'maxMinutes': ?instance.maxMinutes,
      'q': ?instance.q,
      'cursor': ?instance.cursor,
      'limit': ?instance.limit,
    };
