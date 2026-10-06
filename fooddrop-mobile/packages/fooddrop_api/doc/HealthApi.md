# fooddrop_api.api.HealthApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthControllerGetHealth**](HealthApi.md#healthcontrollergethealth) | **GET** /health | 


# **healthControllerGetHealth**
> HealthResponseDto healthControllerGetHealth()



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getHealthApi();

try {
    final response = api.healthControllerGetHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->healthControllerGetHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthResponseDto**](HealthResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

