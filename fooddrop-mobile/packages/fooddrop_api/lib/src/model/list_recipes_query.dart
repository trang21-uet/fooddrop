//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_recipes_query.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ListRecipesQuery {
  /// Returns a new [ListRecipesQuery] instance.
  ListRecipesQuery({

     this.tags,

     this.rarity,

     this.maxMinutes,

     this.q,

     this.cursor,

     this.limit = 20,
  });

  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false,
  )


  final String? tags;



  @JsonKey(
    
    name: r'rarity',
    required: false,
    includeIfNull: false,
  )


  final String? rarity;



          // minimum: 0
          // maximum: 10080
  @JsonKey(
    
    name: r'maxMinutes',
    required: false,
    includeIfNull: false,
  )


  final int? maxMinutes;



  @JsonKey(
    
    name: r'q',
    required: false,
    includeIfNull: false,
  )


  final String? q;



  @JsonKey(
    
    name: r'cursor',
    required: false,
    includeIfNull: false,
  )


  final String? cursor;



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
    bool operator ==(Object other) => identical(this, other) || other is ListRecipesQuery &&
      other.tags == tags &&
      other.rarity == rarity &&
      other.maxMinutes == maxMinutes &&
      other.q == q &&
      other.cursor == cursor &&
      other.limit == limit;

    @override
    int get hashCode =>
        tags.hashCode +
        rarity.hashCode +
        maxMinutes.hashCode +
        q.hashCode +
        cursor.hashCode +
        limit.hashCode;

  factory ListRecipesQuery.fromJson(Map<String, dynamic> json) => _$ListRecipesQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ListRecipesQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

