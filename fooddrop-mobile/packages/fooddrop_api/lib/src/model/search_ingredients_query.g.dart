// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_ingredients_query.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SearchIngredientsQueryCWProxy {
  SearchIngredientsQuery q(String? q);

  SearchIngredientsQuery limit(int? limit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchIngredientsQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchIngredientsQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchIngredientsQuery call({String? q, int? limit});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSearchIngredientsQuery.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSearchIngredientsQuery.copyWith.fieldName(...)`
class _$SearchIngredientsQueryCWProxyImpl
    implements _$SearchIngredientsQueryCWProxy {
  const _$SearchIngredientsQueryCWProxyImpl(this._value);

  final SearchIngredientsQuery _value;

  @override
  SearchIngredientsQuery q(String? q) => this(q: q);

  @override
  SearchIngredientsQuery limit(int? limit) => this(limit: limit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchIngredientsQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchIngredientsQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchIngredientsQuery call({
    Object? q = const $CopyWithPlaceholder(),
    Object? limit = const $CopyWithPlaceholder(),
  }) {
    return SearchIngredientsQuery(
      q: q == const $CopyWithPlaceholder()
          ? _value.q
          // ignore: cast_nullable_to_non_nullable
          : q as String?,
      limit: limit == const $CopyWithPlaceholder()
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int?,
    );
  }
}

extension $SearchIngredientsQueryCopyWith on SearchIngredientsQuery {
  /// Returns a callable class that can be used as follows: `instanceOfSearchIngredientsQuery.copyWith(...)` or like so:`instanceOfSearchIngredientsQuery.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SearchIngredientsQueryCWProxy get copyWith =>
      _$SearchIngredientsQueryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchIngredientsQuery _$SearchIngredientsQueryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SearchIngredientsQuery', json, ($checkedConvert) {
  final val = SearchIngredientsQuery(
    q: $checkedConvert('q', (v) => v as String?),
    limit: $checkedConvert('limit', (v) => (v as num?)?.toInt() ?? 20),
  );
  return val;
});

Map<String, dynamic> _$SearchIngredientsQueryToJson(
  SearchIngredientsQuery instance,
) => <String, dynamic>{'q': ?instance.q, 'limit': ?instance.limit};
