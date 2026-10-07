# fooddrop_api.api.ParserApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**parserControllerCreate**](ParserApi.md#parsercontrollercreate) | **POST** /parser/jobs | 
[**parserControllerGet**](ParserApi.md#parsercontrollerget) | **GET** /parser/jobs/{id} | 


# **parserControllerCreate**
> ParseJob parserControllerCreate(createParseJob)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getParserApi();
final CreateParseJob createParseJob = ; // CreateParseJob | 

try {
    final response = api.parserControllerCreate(createParseJob);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ParserApi->parserControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createParseJob** | [**CreateParseJob**](CreateParseJob.md)|  | 

### Return type

[**ParseJob**](ParseJob.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **parserControllerGet**
> ParseJob parserControllerGet(id)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getParserApi();
final String id = id_example; // String | 

try {
    final response = api.parserControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ParserApi->parserControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ParseJob**](ParseJob.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

