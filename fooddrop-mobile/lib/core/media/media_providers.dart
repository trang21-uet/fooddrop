import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';
import 'media_uploader.dart';

part 'media_providers.g.dart';

@Riverpod(keepAlive: true)
MediaUploader mediaUploader(Ref ref) => MediaUploader(ref.watch(apiClientProvider));
