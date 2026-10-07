# fooddrop_api.api.MediaApi

## Load the API package
```dart
import 'package:fooddrop_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mediaControllerCreateUpload**](MediaApi.md#mediacontrollercreateupload) | **POST** /media/uploads | 


# **mediaControllerCreateUpload**
> UploadTarget mediaControllerCreateUpload(createUpload)



### Example
```dart
import 'package:fooddrop_api/api.dart';

final api = FooddropApi().getMediaApi();
final CreateUpload createUpload = ; // CreateUpload | 

try {
    final response = api.mediaControllerCreateUpload(createUpload);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->mediaControllerCreateUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUpload** | [**CreateUpload**](CreateUpload.md)|  | 

### Return type

[**UploadTarget**](UploadTarget.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

