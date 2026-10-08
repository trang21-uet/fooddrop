# fooddrop_api.api.UnitsApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**unitsControllerList**](UnitsApi.md#unitscontrollerlist) | **GET** /units | 


# **unitsControllerList**
> List<Unit> unitsControllerList()



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getUnitsApi();

try {
    final response = api.unitsControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UnitsApi->unitsControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;Unit&gt;**](Unit.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

