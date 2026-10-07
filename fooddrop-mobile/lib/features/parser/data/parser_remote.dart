import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

/// Thin wrapper over the generated client for recipe import jobs and photo uploads.
class ParserRemote {
  ParserRemote(this._api, {Dio? uploader}) : _uploader = uploader ?? Dio();

  final api.FooddropApi _api;

  /// Plain Dio for the signed storage URL: no base URL and, crucially, no bearer interceptor.
  final Dio _uploader;

  Future<String> startUrl(String url) async {
    final job = (await _api.getParserApi().parserControllerCreate(createParseJob: api.CreateParseJob(url: url))).data!;
    return job.id;
  }

  /// Uploads straight to object storage with a signed URL, then queues the parse job.
  Future<String> startImage(Uint8List bytes, api.CreateUploadContentTypeEnum contentType) async {
    final target = (await _api.getMediaApi().mediaControllerCreateUpload(
      createUpload: api.CreateUpload(contentType: contentType, sizeBytes: bytes.length),
    ))
        .data!;
    // The signature covers these exact headers (content type and length).
    await _uploader.put<void>(
      target.uploadUrl,
      data: bytes,
      options: Options(headers: {...target.headers, Headers.contentLengthHeader: bytes.length}),
    );
    final job = (await _api.getParserApi().parserControllerCreate(createParseJob: api.CreateParseJob(imageKey: target.key))).data!;
    return job.id;
  }

  Future<api.ParseJob> getJob(String id) async => (await _api.getParserApi().parserControllerGet(id: id)).data!;
}
