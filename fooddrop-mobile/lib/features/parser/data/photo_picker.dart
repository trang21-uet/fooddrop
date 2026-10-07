import 'dart:typed_data';

import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

class PickedPhoto {
  const PickedPhoto(this.bytes, this.contentType);

  final Uint8List bytes;
  final api.CreateUploadContentTypeEnum contentType;
}

/// The server rejects uploads above 5 MB (the model's own image limit).
const maxPhotoBytes = 5 * 1024 * 1024;

/// Camera / gallery access behind a small seam so screens and tests do not touch the plugin.
class PhotoPicker {
  const PhotoPicker();

  /// Null when the user cancels. Photos are downscaled and re-compressed by the plugin; 2000 px is
  /// plenty for the model to read printed text and keeps uploads small on mobile data.
  Future<PickedPhoto?> pick(PhotoSource source) async {
    final file = await ImagePicker().pickImage(
      source: source == PhotoSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
    );
    if (file == null) return null;
    return PickedPhoto(await file.readAsBytes(), contentTypeFor(file.mimeType ?? file.name));
  }
}

/// Accepts a MIME type or file name; anything unrecognised is treated as JPEG (camera default).
api.CreateUploadContentTypeEnum contentTypeFor(String mimeOrName) {
  final value = mimeOrName.toLowerCase();
  if (value.contains('png')) return api.CreateUploadContentTypeEnum.imageSlashPng;
  if (value.contains('webp')) return api.CreateUploadContentTypeEnum.imageSlashWebp;
  return api.CreateUploadContentTypeEnum.imageSlashJpeg;
}
