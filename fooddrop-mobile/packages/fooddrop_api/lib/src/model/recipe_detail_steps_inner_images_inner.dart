//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail_steps_inner_images_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecipeDetailStepsInnerImagesInner {
  /// Returns a new [RecipeDetailStepsInnerImagesInner] instance.
  RecipeDetailStepsInnerImagesInner({

    required  this.key,

    required  this.url,
  });

  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;



  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: true,
  )


  final String? url;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecipeDetailStepsInnerImagesInner &&
      other.key == key &&
      other.url == url;

    @override
    int get hashCode =>
        key.hashCode +
        (url == null ? 0 : url.hashCode);

  factory RecipeDetailStepsInnerImagesInner.fromJson(Map<String, dynamic> json) => _$RecipeDetailStepsInnerImagesInnerFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailStepsInnerImagesInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

