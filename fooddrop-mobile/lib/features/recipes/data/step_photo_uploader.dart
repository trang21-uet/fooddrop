import 'package:dio/dio.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/api/api_error.dart';
import '../../../core/media/media_uploader.dart';
import '../../parser/data/photo_picker.dart';
import '../domain/recipe.dart';

/// Same cap as the server and web.
const maxStepImages = 10;

/// Why a step photo could not be uploaded. 503 is the API saying object storage is not configured,
/// which [isOffline] would otherwise report as a dropped connection.
String describePhotoUploadError(Object error) {
  if (error is DioException && error.response?.statusCode == 503) return 'Máy chủ chưa bật tính năng tải ảnh.';
  return isOffline(error) ? 'Cần kết nối mạng để thêm ảnh.' : 'Không tải được ảnh. Thử lại nhé.';
}

class StepPhotoUpload {
  const StepPhotoUpload({required this.images, this.error});

  /// The photos that uploaded, in the order they were picked.
  final List<RecipeStepImage> images;

  /// Why some photo did not (the last failure), or null when all went through.
  final String? error;
}

/// Uploads picked photos straight to object storage, all at once. A failure drops only that photo.
Future<StepPhotoUpload> uploadStepPhotos(List<PickedPhoto> photos, MediaUploader uploader) async {
  String? error;
  final uploads = await Future.wait([
    for (final photo in photos)
      () async {
        if (photo.bytes.length > maxPhotoBytes) {
          error = 'Ảnh quá lớn (tối đa 5 MB). Hãy chọn ảnh khác.';
          return null;
        }
        try {
          final key = await uploader.upload(photo.bytes, photo.contentType, api.CreateUploadPurposeEnum.recipeStep);
          // The picked file stays on disk, so the photo can be shown before the next sync brings the server URL.
          return RecipeStepImage(key: key, url: photo.path == null ? null : Uri.file(photo.path!).toString());
        } catch (e) {
          error = describePhotoUploadError(e);
          return null;
        }
      }(),
  ]);
  return StepPhotoUpload(images: uploads.whereType<RecipeStepImage>().toList(), error: error);
}
