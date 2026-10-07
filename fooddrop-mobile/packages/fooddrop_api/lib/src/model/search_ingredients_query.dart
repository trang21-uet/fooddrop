//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_ingredients_query.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SearchIngredientsQuery {
  /// Returns a new [SearchIngredientsQuery] instance.
  SearchIngredientsQuery({

     this.q,

     this.limit = 20,
  });

  @JsonKey(
    
    name: r'q',
    required: false,
    includeIfNull: false,
  )


  final String? q;



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
    bool operator ==(Object other) => identical(this, other) || other is SearchIngredientsQuery &&
      other.q == q &&
      other.limit == limit;

    @override
    int get hashCode =>
        q.hashCode +
        limit.hashCode;

  factory SearchIngredientsQuery.fromJson(Map<String, dynamic> json) => _$SearchIngredientsQueryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchIngredientsQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

