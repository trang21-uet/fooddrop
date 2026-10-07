# fooddrop_api.api.RecipesApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**recipesControllerCreate**](RecipesApi.md#recipescontrollercreate) | **POST** /recipes | 
[**recipesControllerGet**](RecipesApi.md#recipescontrollerget) | **GET** /recipes/{id} | 
[**recipesControllerList**](RecipesApi.md#recipescontrollerlist) | **GET** /recipes | 
[**recipesControllerRemove**](RecipesApi.md#recipescontrollerremove) | **DELETE** /recipes/{id} | 
[**recipesControllerUpdate**](RecipesApi.md#recipescontrollerupdate) | **PUT** /recipes/{id} | 


# **recipesControllerCreate**
> RecipeDetail recipesControllerCreate(recipeInput)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getRecipesApi();
final RecipeInput recipeInput = ; // RecipeInput | 

try {
    final response = api.recipesControllerCreate(recipeInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RecipesApi->recipesControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recipeInput** | [**RecipeInput**](RecipeInput.md)|  | 

### Return type

[**RecipeDetail**](RecipeDetail.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recipesControllerGet**
> RecipeDetail recipesControllerGet(id)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getRecipesApi();
final String id = id_example; // String | 

try {
    final response = api.recipesControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RecipesApi->recipesControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RecipeDetail**](RecipeDetail.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recipesControllerList**
> RecipeList recipesControllerList(tags, rarity, maxMinutes, q, cursor, limit)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getRecipesApi();
final String tags = tags_example; // String | 
final String rarity = rarity_example; // String | 
final int maxMinutes = 56; // int | 
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.recipesControllerList(tags, rarity, maxMinutes, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RecipesApi->recipesControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tags** | **String**|  | [optional] 
 **rarity** | **String**|  | [optional] 
 **maxMinutes** | **int**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**RecipeList**](RecipeList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recipesControllerRemove**
> recipesControllerRemove(id)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getRecipesApi();
final String id = id_example; // String | 

try {
    api.recipesControllerRemove(id);
} on DioException catch (e) {
    print('Exception when calling RecipesApi->recipesControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recipesControllerUpdate**
> RecipeDetail recipesControllerUpdate(id, recipeInput)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getRecipesApi();
final String id = id_example; // String | 
final RecipeInput recipeInput = ; // RecipeInput | 

try {
    final response = api.recipesControllerUpdate(id, recipeInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RecipesApi->recipesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **recipeInput** | [**RecipeInput**](RecipeInput.md)|  | 

### Return type

[**RecipeDetail**](RecipeDetail.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

