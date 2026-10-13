// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_gacha_spins_query.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ListGachaSpinsQueryCWProxy {
  ListGachaSpinsQuery limit(int? limit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ListGachaSpinsQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ListGachaSpinsQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  ListGachaSpinsQuery call({int? limit});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfListGachaSpinsQuery.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfListGachaSpinsQuery.copyWith.fieldName(...)`
class _$ListGachaSpinsQueryCWProxyImpl implements _$ListGachaSpinsQueryCWProxy {
  const _$ListGachaSpinsQueryCWProxyImpl(this._value);

  final ListGachaSpinsQuery _value;

  @override
  ListGachaSpinsQuery limit(int? limit) => this(limit: limit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ListGachaSpinsQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ListGachaSpinsQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  ListGachaSpinsQuery call({Object? limit = const $CopyWithPlaceholder()}) {
    return ListGachaSpinsQuery(
      limit: limit == const $CopyWithPlaceholder()
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int?,
    );
  }
}

extension $ListGachaSpinsQueryCopyWith on ListGachaSpinsQuery {
  /// Returns a callable class that can be used as follows: `instanceOfListGachaSpinsQuery.copyWith(...)` or like so:`instanceOfListGachaSpinsQuery.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ListGachaSpinsQueryCWProxy get copyWith =>
      _$ListGachaSpinsQueryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListGachaSpinsQuery _$ListGachaSpinsQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ListGachaSpinsQuery', json, ($checkedConvert) {
      final val = ListGachaSpinsQuery(
        limit: $checkedConvert('limit', (v) => (v as num?)?.toInt() ?? 20),
      );
      return val;
    });

Map<String, dynamic> _$ListGachaSpinsQueryToJson(
  ListGachaSpinsQuery instance,
) => <String, dynamic>{'limit': ?instance.limit};
