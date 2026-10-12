import 'package:flutter/material.dart';

import '../../../parser/data/photo_picker.dart';

/// Asks whether to take a photo or pick from the library; null when dismissed.
Future<PhotoSource?> showPhotoSourceSheet(BuildContext context, {String galleryLabel = 'Chọn từ thư viện'}) =>
    showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Chụp ảnh'),
              onTap: () => Navigator.of(sheet).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(galleryLabel),
              onTap: () => Navigator.of(sheet).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
