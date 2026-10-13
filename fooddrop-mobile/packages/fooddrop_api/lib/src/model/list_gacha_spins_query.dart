//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_gacha_spins_query.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ListGachaSpinsQuery {
  /// Returns a new [ListGachaSpinsQuery] instance.
  ListGachaSpinsQuery({

     this.limit = 20,
  });

          // minimum: 1
          // maximum: 50
  @JsonKey(
    defaultValue: 20,
    name: r'limit',
    required: false,
    includeIfNull: false,
  )


  final int? limit;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ListGachaSpinsQuery &&
      other.limit == limit;

    @override
    int get hashCode =>
        limit.hashCode;

  factory ListGachaSpinsQuery.fromJson(Map<String, dynamic> json) => _$ListGachaSpinsQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ListGachaSpinsQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

