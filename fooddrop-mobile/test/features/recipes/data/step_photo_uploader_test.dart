import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/media/media_uploader.dart';
import 'package:fooddrop/features/parser/data/photo_picker.dart';
import 'package:fooddrop/features/recipes/data/step_photo_uploader.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../support/fake_recipe_remote.dart';

/// Finishes uploads in reverse order, so a test can tell "all at once" from "one after another".
class _ReversingUploader implements MediaUploader {
  _ReversingUploader({this.failFor = const {}});

  final Set<int> failFor;
  final started = <int>[];
  final _gates = <int, Completer<void>>{};

  @override
  Future<String> upload(Uint8List bytes, api.CreateUploadContentTypeEnum contentType, api.CreateUploadPurposeEnum purpose) async {
    final id = bytes.length;
    started.add(id);
    await (_gates[id] = Completer<void>()).future;
    if (failFor.contains(id)) throw DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError);
    return 'recipes/u1/$id.jpg';
  }

  void finish(int id) => _gates[id]!.complete();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PickedPhoto _photo(int size, {String? path}) => PickedPhoto(Uint8List(size), api.CreateUploadContentTypeEnum.imageSlashJpeg, path: path);

void main() {
  test('uploads every photo at once and returns them in the order they were picked', () async {
    final uploader = _ReversingUploader();
    final future = uploadStepPhotos([_photo(1, path: '/cache/a.jpg'), _photo(2), _photo(3)], uploader);
    await Future<void>.delayed(Duration.zero);

    expect(uploader.started, [1, 2, 3], reason: 'none waited for another to finish');
    uploader.finish(3);
    uploader.finish(2);
    uploader.finish(1);
    final result = await future;

    expect(result.images.map((image) => image.key), ['recipes/u1/1.jpg', 'recipes/u1/2.jpg', 'recipes/u1/3.jpg']);
    expect(result.images.first.url, Uri.file('/cache/a.jpg').toString());
    expect(result.images.last.url, isNull);
    expect(result.error, isNull);
  });

  test('a failed upload drops only that photo and reports why', () async {
    final uploader = _ReversingUploader(failFor: {2});
    final future = uploadStepPhotos([_photo(1), _photo(2)], uploader);
    await Future<void>.delayed(Duration.zero);
    uploader.finish(1);
    uploader.finish(2);
    final result = await future;

    expect(result.images.map((image) => image.key), ['recipes/u1/1.jpg']);
    expect(result.error, 'Cần kết nối mạng để thêm ảnh.');
  });

  test('describePhotoUploadError tells a missing storage config from a dropped connection', () {
    DioException http(int status) => DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: RequestOptions(), statusCode: status),
        );
    expect(describePhotoUploadError(http(503)), 'Máy chủ chưa bật tính năng tải ảnh.');
    expect(describePhotoUploadError(http(502)), 'Cần kết nối mạng để thêm ảnh.');
    expect(describePhotoUploadError(http(400)), 'Không tải được ảnh. Thử lại nhé.');
    expect(describePhotoUploadError(dioError(DioExceptionType.connectionError)), 'Cần kết nối mạng để thêm ảnh.');
  });
}
