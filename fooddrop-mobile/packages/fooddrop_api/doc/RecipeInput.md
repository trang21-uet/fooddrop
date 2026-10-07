# fooddrop_api.model.RecipeInput

## Load the model package
```dart
import 'package:fooddrop_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** |  | 
**description** | **String** |  | [optional] 
**imageUrl** | **String** |  | [optional] 
**sourceUrl** | **String** |  | [optional] 
**baseServings** | **int** |  | [optional] [default to 2]
**totalMinutes** | **int** |  | 
**difficulty** | **int** |  | 
**steps** | [**List&lt;RecipeInputStepsInner&gt;**](RecipeInputStepsInner.md) |  | 
**ingredients** | [**List&lt;RecipeInputIngredientsInner&gt;**](RecipeInputIngredientsInner.md) |  | [optional] 
**tagIds** | **List&lt;int&gt;** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


