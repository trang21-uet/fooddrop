import 'package:fooddrop_api/src/model/create_gacha_spin.dart';
import 'package:fooddrop_api/src/model/create_ingredient.dart';
import 'package:fooddrop_api/src/model/create_parse_job.dart';
import 'package:fooddrop_api/src/model/create_upload.dart';
import 'package:fooddrop_api/src/model/gacha_cases.dart';
import 'package:fooddrop_api/src/model/gacha_cases_items_inner.dart';
import 'package:fooddrop_api/src/model/gacha_cases_items_inner_rarity_counts.dart';
import 'package:fooddrop_api/src/model/gacha_error.dart';
import 'package:fooddrop_api/src/model/gacha_spin.dart';
import 'package:fooddrop_api/src/model/gacha_spin_history.dart';
import 'package:fooddrop_api/src/model/gacha_spin_history_items_inner.dart';
import 'package:fooddrop_api/src/model/gacha_spin_history_items_inner_result.dart';
import 'package:fooddrop_api/src/model/gacha_spin_result.dart';
import 'package:fooddrop_api/src/model/health_checks_dto.dart';
import 'package:fooddrop_api/src/model/health_response_dto.dart';
import 'package:fooddrop_api/src/model/ingredient.dart';
import 'package:fooddrop_api/src/model/list_gacha_spins_query.dart';
import 'package:fooddrop_api/src/model/list_recipes_query.dart';
import 'package:fooddrop_api/src/model/parse_job.dart';
import 'package:fooddrop_api/src/model/parse_job_result.dart';
import 'package:fooddrop_api/src/model/parse_job_result_ingredients_inner.dart';
import 'package:fooddrop_api/src/model/parse_job_result_steps_inner.dart';
import 'package:fooddrop_api/src/model/parse_job_result_steps_inner_images_inner.dart';
import 'package:fooddrop_api/src/model/parse_rate_limit_error.dart';
import 'package:fooddrop_api/src/model/recipe_detail.dart';
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner.dart';
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_base.dart';
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_ingredient.dart';
import 'package:fooddrop_api/src/model/recipe_detail_ingredients_inner_unit.dart';
import 'package:fooddrop_api/src/model/recipe_detail_steps_inner.dart';
import 'package:fooddrop_api/src/model/recipe_detail_tags_inner.dart';
import 'package:fooddrop_api/src/model/recipe_input.dart';
import 'package:fooddrop_api/src/model/recipe_input_ingredients_inner.dart';
import 'package:fooddrop_api/src/model/recipe_input_steps_inner.dart';
import 'package:fooddrop_api/src/model/recipe_list.dart';
import 'package:fooddrop_api/src/model/recipe_list_items_inner.dart';
import 'package:fooddrop_api/src/model/search_ingredients_query.dart';
import 'package:fooddrop_api/src/model/tag_dimension.dart';
import 'package:fooddrop_api/src/model/tag_dimension_tags_inner.dart';
import 'package:fooddrop_api/src/model/unit.dart';
import 'package:fooddrop_api/src/model/upload_target.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'CreateGachaSpin':
          return CreateGachaSpin.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateIngredient':
          return CreateIngredient.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateParseJob':
          return CreateParseJob.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateUpload':
          return CreateUpload.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaCases':
          return GachaCases.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaCasesItemsInner':
          return GachaCasesItemsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaCasesItemsInnerRarityCounts':
          return GachaCasesItemsInnerRarityCounts.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaError':
          return GachaError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaSpin':
          return GachaSpin.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaSpinHistory':
          return GachaSpinHistory.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaSpinHistoryItemsInner':
          return GachaSpinHistoryItemsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaSpinHistoryItemsInnerResult':
          return GachaSpinHistoryItemsInnerResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GachaSpinResult':
          return GachaSpinResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthChecksDto':
          return HealthChecksDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthResponseDto':
          return HealthResponseDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Ingredient':
          return Ingredient.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ListGachaSpinsQuery':
          return ListGachaSpinsQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ListRecipesQuery':
          return ListRecipesQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ParseJob':
          return ParseJob.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ParseJobResult':
          return ParseJobResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ParseJobResultIngredientsInner':
          return ParseJobResultIngredientsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ParseJobResultStepsInner':
          return ParseJobResultStepsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ParseJobResultStepsInnerImagesInner':
          return ParseJobResultStepsInnerImagesInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ParseRateLimitError':
          return ParseRateLimitError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetail':
          return RecipeDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetailIngredientsInner':
          return RecipeDetailIngredientsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetailIngredientsInnerBase':
          return RecipeDetailIngredientsInnerBase.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetailIngredientsInnerIngredient':
          return RecipeDetailIngredientsInnerIngredient.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetailIngredientsInnerUnit':
          return RecipeDetailIngredientsInnerUnit.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetailStepsInner':
          return RecipeDetailStepsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeDetailTagsInner':
          return RecipeDetailTagsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeInput':
          return RecipeInput.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeInputIngredientsInner':
          return RecipeInputIngredientsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeInputStepsInner':
          return RecipeInputStepsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeList':
          return RecipeList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecipeListItemsInner':
          return RecipeListItemsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SearchIngredientsQuery':
          return SearchIngredientsQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TagDimension':
          return TagDimension.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TagDimensionTagsInner':
          return TagDimensionTagsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Unit':
          return Unit.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadTarget':
          return UploadTarget.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }