# fooddrop_api.api.TagsApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tagsControllerList**](TagsApi.md#tagscontrollerlist) | **GET** /tags | 


# **tagsControllerList**
> List<TagDimension> tagsControllerList()



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getTagsApi();

try {
    final response = api.tagsControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling TagsApi->tagsControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;TagDimension&gt;**](TagDimension.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

