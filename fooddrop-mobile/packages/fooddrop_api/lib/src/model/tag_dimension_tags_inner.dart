//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_dimension_tags_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TagDimensionTagsInner {
  /// Returns a new [TagDimensionTagsInner] instance.
  TagDimensionTagsInner({

    required  this.id,

    required  this.slug,

    required  this.label,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is TagDimensionTagsInner &&
      other.id == id &&
      other.slug == slug &&
      other.label == label;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        label.hashCode;

  factory TagDimensionTagsInner.fromJson(Map<String, dynamic> json) => _$TagDimensionTagsInnerFromJson(json);

  Map<String, dynamic> toJson() => _$TagDimensionTagsInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

