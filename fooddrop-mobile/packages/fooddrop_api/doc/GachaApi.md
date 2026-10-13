# fooddrop_api.api.GachaApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**gachaControllerCases**](GachaApi.md#gachacontrollercases) | **GET** /gacha/cases | 
[**gachaControllerHistory**](GachaApi.md#gachacontrollerhistory) | **GET** /gacha/spins | 
[**gachaControllerSpin**](GachaApi.md#gachacontrollerspin) | **POST** /gacha/spins | 


# **gachaControllerCases**
> GachaCases gachaControllerCases()



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getGachaApi();

try {
    final response = api.gachaControllerCases();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GachaApi->gachaControllerCases: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GachaCases**](GachaCases.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **gachaControllerHistory**
> GachaSpinHistory gachaControllerHistory(limit)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getGachaApi();
final int limit = 56; // int | 

try {
    final response = api.gachaControllerHistory(limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GachaApi->gachaControllerHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**GachaSpinHistory**](GachaSpinHistory.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **gachaControllerSpin**
> GachaSpin gachaControllerSpin(createGachaSpin)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getGachaApi();
final CreateGachaSpin createGachaSpin = ; // CreateGachaSpin | 

try {
    final response = api.gachaControllerSpin(createGachaSpin);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GachaApi->gachaControllerSpin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createGachaSpin** | [**CreateGachaSpin**](CreateGachaSpin.md)|  | 

### Return type

[**GachaSpin**](GachaSpin.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

