import 'dart:typed_data';

import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/media/media_uploader.dart';

/// Thin wrapper over the generated client for recipe import jobs and photo uploads.
class ParserRemote {
  ParserRemote(this._api, {MediaUploader? media}) : _media = media ?? MediaUploader(_api);

  final api.FooddropApi _api;
  final MediaUploader _media;

  Future<String> startUrl(String url) async {
    final job = (await _api.getParserApi().parserControllerCreate(createParseJob: api.CreateParseJob(url: url))).data!;
    return job.id;
  }

  /// Uploads the photo, then queues the parse job.
  Future<String> startImage(Uint8List bytes, api.CreateUploadContentTypeEnum contentType) async {
    final key = await _media.upload(bytes, contentType, api.CreateUploadPurposeEnum.parser);
    final job = (await _api.getParserApi().parserControllerCreate(createParseJob: api.CreateParseJob(imageKey: key))).data!;
    return job.id;
  }

  Future<api.ParseJob> getJob(String id) async => (await _api.getParserApi().parserControllerGet(id: id)).data!;
}
