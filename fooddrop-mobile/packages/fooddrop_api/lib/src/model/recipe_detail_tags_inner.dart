//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_tags_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailTagsInner {
  /// Returns a new [RecipeDetailTagsInner] instance.
  RecipeDetailTagsInner({

    required  this.id,

    required  this.slug,

    required  this.label,

    required  this.dimension,
  });

          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'slug',
    required: true,
    includeIfNull: false,
  )


  final String slug;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'dimension',
    required: true,
    includeIfNull: false,
  )


  final String dimension;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailTagsInner &&
      other.id == id &&
      other.slug == slug &&
      other.label == label &&
      other.dimension == dimension;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        label.hashCode +
        dimension.hashCode;

  factory RecipeDetailTagsInner.fromJson(Map<String, dynamic> json) => _$RecipeDetailTagsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailTagsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

