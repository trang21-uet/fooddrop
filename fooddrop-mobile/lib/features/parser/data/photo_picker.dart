import 'dart:typed_data';

import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

class PickedPhoto {
  const PickedPhoto(this.bytes, this.contentType, {this.path});

  final Uint8List bytes;
  final api.CreateUploadContentTypeEnum contentType;

  /// Where the plugin left the file, for a local preview before the upload has synced.
  final String? path;
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
    return file == null ? null : _read(file);
  }

  /// Several photos from the gallery at once (at most [limit]); the camera takes one at a time.
  Future<List<PickedPhoto>> pickMany(PhotoSource source, {required int limit}) async {
    if (source == PhotoSource.camera) {
      final photo = await pick(source);
      return photo == null ? const [] : [photo];
    }
    final files = await ImagePicker().pickMultiImage(maxWidth: 2000, maxHeight: 2000, imageQuality: 85, limit: limit);
    return [for (final file in files.take(limit)) await _read(file)];
  }

  Future<PickedPhoto> _read(XFile file) async =>
      PickedPhoto(await file.readAsBytes(), contentTypeFor(file.mimeType ?? file.name), path: file.path);
}

/// Accepts a MIME type or file name; anything unrecognised is treated as JPEG (camera default).
api.CreateUploadContentTypeEnum contentTypeFor(String mimeOrName) {
  final value = mimeOrName.toLowerCase();
  if (value.contains('png')) return api.CreateUploadContentTypeEnum.imageSlashPng;
  if (value.contains('webp')) return api.CreateUploadContentTypeEnum.imageSlashWebp;
  return api.CreateUploadContentTypeEnum.imageSlashJpeg;
}
