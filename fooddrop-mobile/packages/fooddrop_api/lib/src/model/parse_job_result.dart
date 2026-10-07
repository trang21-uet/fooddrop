//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fooddrop_api/src/model/parse_job_result_ingredients_inner.dart';
import 'package:fooddrop_api/src/model/parse_job_result_steps_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parse_job_result.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ParseJobResult {
  /// Returns a new [ParseJobResult] instance.
  ParseJobResult({

    required  this.source_,

    required  this.title,

    required  this.description,

    required  this.imageUrl,

    required  this.sourceUrl,

    required  this.baseServings,

    required  this.totalMinutes,

    required  this.difficulty,

    required  this.ingredients,

    required  this.steps,

    required  this.suggestedTagIds,
  });

  @JsonKey(
    
    name: r'source',
    required: true,
    includeIfNull: false,
  )


  final ParseJobResultSource_Enum source_;



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



  @JsonKey(
    
    name: r'sourceUrl',
    required: true,
    includeIfNull: true,
  )


  final String? sourceUrl;



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
    includeIfNull: true,
  )


  final int? totalMinutes;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'difficulty',
    required: true,
    includeIfNull: false,
  )


  final int difficulty;



  @JsonKey(
    
    name: r'ingredients',
    required: true,
    includeIfNull: false,
  )


  final List<ParseJobResultIngredientsInner> ingredients;



  @JsonKey(
    
    name: r'steps',
    required: true,
    includeIfNull: false,
  )


  final List<ParseJobResultStepsInner> steps;



  @JsonKey(
    
    name: r'suggestedTagIds',
    required: true,
    includeIfNull: false,
  )


  final List<int> suggestedTagIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ParseJobResult &&
      other.source_ == source_ &&
      other.title == title &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.sourceUrl == sourceUrl &&
      other.baseServings == baseServings &&
      other.totalMinutes == totalMinutes &&
      other.difficulty == difficulty &&
      other.ingredients == ingredients &&
      other.steps == steps &&
      other.suggestedTagIds == suggestedTagIds;

    @override
    int get hashCode =>
        source_.hashCode +
        title.hashCode +
        (description == null ? 0 : description.hashCode) +
        (imageUrl == null ? 0 : imageUrl.hashCode) +
        (sourceUrl == null ? 0 : sourceUrl.hashCode) +
        baseServings.hashCode +
        (totalMinutes == null ? 0 : totalMinutes.hashCode) +
        difficulty.hashCode +
        ingredients.hashCode +
        steps.hashCode +
        suggestedTagIds.hashCode;

  factory ParseJobResult.fromJson(Map<String, dynamic> json) => _$ParseJobResultFromJson(json);

  Map<String, dynamic> toJson() => _$ParseJobResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ParseJobResultSource_Enum {
@JsonValue(r'json-ld')
jsonLd(r'json-ld'),
@JsonValue(r'llm-text')
llmText(r'llm-text'),
@JsonValue(r'llm-vision')
llmVision(r'llm-vision');

const ParseJobResultSource_Enum(this.value);

final String value;

@override
String toString() => value;
}


