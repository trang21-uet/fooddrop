import 'dart:io';

import 'package:flutter/material.dart';

/// A photo from a server or external URL, or from a `file:` URI for an upload that has not synced
/// yet. Shows [placeholder] while loading and when it does not load (offline).
class PhotoUrlView extends StatelessWidget {
  const PhotoUrlView({super.key, required this.url, required this.placeholder, this.fit = BoxFit.cover, this.cacheWidth});

  final String url;
  final Widget placeholder;
  final BoxFit fit;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.scheme == 'file') {
      return Image.file(
        File.fromUri(uri),
        fit: fit,
        cacheWidth: cacheWidth,
        excludeFromSemantics: true,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }
    return Image.network(
      url,
      fit: fit,
      cacheWidth: cacheWidth,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) => placeholder,
      loadingBuilder: (context, child, progress) => progress == null ? child : placeholder,
    );
  }
}
