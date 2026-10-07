//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/recipe_detail_tags_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_list_items_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeListItemsInner {
  /// Returns a new [RecipeListItemsInner] instance.
  RecipeListItemsInner({

    required  this.id,

    required  this.title,

    required  this.description,

    required  this.imageUrl,

    required  this.baseServings,

    required  this.totalMinutes,

    required  this.difficulty,

    required  this.rarity,

    required  this.tags,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: true,
  )


  final String? description;



  @JsonKey(
    
    name: r'imageUrl',
    required: true,
    includeIfNull: true,
  )


  final String? imageUrl;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'baseServings',
    required: true,
    includeIfNull: false,
  )


  final int baseServings;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'totalMinutes',
    required: true,
    includeIfNull: false,
  )


  final int totalMinutes;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'difficulty',
    required: true,
    includeIfNull: false,
  )


  final int difficulty;



  @JsonKey(
    
    name: r'rarity',
    required: true,
    includeIfNull: false,
  )


  final RecipeListItemsInnerRarityEnum rarity;



  @JsonKey(
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  )


  final List<RecipeDetailTagsInner> tags;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeListItemsInner &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.baseServings == baseServings &&
      other.totalMinutes == totalMinutes &&
      other.difficulty == difficulty &&
      other.rarity == rarity &&
      other.tags == tags &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        title.hashCode +
        (description == null ? 0 : description.hashCode) +
        (imageUrl == null ? 0 : imageUrl.hashCode) +
        baseServings.hashCode +
        totalMinutes.hashCode +
        difficulty.hashCode +
        rarity.hashCode +
        tags.hashCode +
        createdAt.hashCode;

  factory RecipeListItemsInner.fromJson(Map<String, dynamic> json) => _$RecipeListItemsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeListItemsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RecipeListItemsInnerRarityEnum {
@JsonValue(r'white')
white(r'white'),
@JsonValue(r'blue')
blue(r'blue'),
@JsonValue(r'purple')
purple(r'purple'),
@JsonValue(r'pink')
pink(r'pink'),
@JsonValue(r'red')
red(r'red');

const RecipeListItemsInnerRarityEnum(this.value);

final String value;

@override
String toString() => value;
}


