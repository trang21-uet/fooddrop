import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fooddrop_api/fooddrop_api.dart';

/// Override with `--dart-define=API_BASE_URL=...` (Android emulator: http://10.0.2.2:4000).
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:4000',
);

final apiClientProvider = Provider<FooddropApi>(
  (ref) => FooddropApi(basePathOverride: apiBaseUrl),
);
