import 'package:dio/dio.dart';
import 'package:fooddrop_api/fooddrop_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_controller.dart';

part 'api_client_provider.g.dart';

/// Override with `--dart-define=API_BASE_URL=...` (Android emulator: http://10.0.2.2:4000).
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:4000',
);

/// Name of the bearer scheme in the OpenAPI document.
const bearerSchemeName = 'bearer';

@Riverpod(keepAlive: true)
FooddropApi apiClient(Ref ref) {
  final api = FooddropApi(
    dio: Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    ),
  );
  // An expired or revoked session: drop it locally so the router sends the user back to login.
  api.dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        final isAuthCall = error.requestOptions.path.startsWith('/api/auth/');
        if (error.response?.statusCode == 401 && !isAuthCall) {
          ref.read(authControllerProvider.notifier).expireSession();
        }
        handler.next(error);
      },
    ),
  );
  return api;
}
