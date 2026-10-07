//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/tag_dimension_tags_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_dimension.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TagDimension {
  /// Returns a new [TagDimension] instance.
  TagDimension({

    required  this.id,

    required  this.slug,

    required  this.label,

    required  this.tags,
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
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  )


  final List<TagDimensionTagsInner> tags;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TagDimension &&
      other.id == id &&
      other.slug == slug &&
      other.label == label &&
      other.tags == tags;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        label.hashCode +
        tags.hashCode;

  factory TagDimension.fromJson(Map<String, dynamic> json) => _$TagDimensionFromJson(json);

  Map<String, dynamic> toJson() => _$TagDimensionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

