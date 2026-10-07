# fooddrop_api.api.IngredientsApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ingredientsControllerCreate**](IngredientsApi.md#ingredientscontrollercreate) | **POST** /ingredients | 
[**ingredientsControllerSearch**](IngredientsApi.md#ingredientscontrollersearch) | **GET** /ingredients | 


# **ingredientsControllerCreate**
> Ingredient ingredientsControllerCreate(createIngredient)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getIngredientsApi();
final CreateIngredient createIngredient = ; // CreateIngredient | 

try {
    final response = api.ingredientsControllerCreate(createIngredient);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->ingredientsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createIngredient** | [**CreateIngredient**](CreateIngredient.md)|  | 

### Return type

[**Ingredient**](Ingredient.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ingredientsControllerSearch**
> List<Ingredient> ingredientsControllerSearch(q, limit)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getIngredientsApi();
final String q = q_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.ingredientsControllerSearch(q, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IngredientsApi->ingredientsControllerSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**List&lt;Ingredient&gt;**](Ingredient.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

