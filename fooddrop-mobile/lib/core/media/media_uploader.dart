import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

/// Uploads a photo straight to object storage with a signed URL and returns its storage key.
class MediaUploader {
  MediaUploader(this._api, {Dio? uploader}) : _uploader = uploader ?? Dio();

  final api.FooddropApi _api;

  /// Plain Dio for the signed storage URL: no base URL and, crucially, no bearer interceptor.
  final Dio _uploader;

  Future<String> upload(
    Uint8List bytes,
    api.CreateUploadContentTypeEnum contentType,
    api.CreateUploadPurposeEnum purpose,
  ) async {
    final target = (await _api.getMediaApi().mediaControllerCreateUpload(
      createUpload: api.CreateUpload(purpose: purpose, contentType: contentType, sizeBytes: bytes.length),
    ))
        .data!;
    // The signature covers these exact headers (content type and length).
    await _uploader.put<void>(
      target.uploadUrl,
      data: bytes,
      options: Options(headers: {...target.headers, Headers.contentLengthHeader: bytes.length}),
    );
    return target.key;
  }
}
