import 'package:dio/dio.dart';

import '../api/api_error.dart';
import 'session_storage.dart';

/// Thrown with a message that is safe to show directly to the user.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

const _messages = {
  'INVALID_EMAIL_OR_PASSWORD': 'Email hoặc mật khẩu không đúng.',
  'INVALID_EMAIL': 'Email không hợp lệ.',
  'USER_ALREADY_EXISTS': 'Email này đã được dùng. Hãy đăng nhập hoặc dùng email khác.',
  'USER_ALREADY_EXISTS_USE_ANOTHER_EMAIL': 'Email này đã được dùng. Hãy đăng nhập hoặc dùng email khác.',
  'PASSWORD_TOO_SHORT': 'Mật khẩu cần ít nhất 8 ký tự.',
  'PASSWORD_TOO_LONG': 'Mật khẩu quá dài.',
};

/// better-auth returns English messages; map its stable error `code` to Vietnamese.
String authErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    final code = data is Map ? data['code'] : null;
    if (code is String && _messages.containsKey(code)) return _messages[code]!;
  }
  return describeApiError(error);
}

/// Better Auth endpoints (`/api/auth/*`) are not part of the OpenAPI document, so they use the
/// shared Dio directly. The bearer plugin returns the signed session token in `set-auth-token`.
class AuthRemote {
  const AuthRemote(this._dio);

  final Dio _dio;

  Future<AuthSession> signIn({required String email, required String password}) =>
      _authenticate('/api/auth/sign-in/email', {'email': email, 'password': password});

  Future<AuthSession> signUp({required String name, required String email, required String password}) =>
      _authenticate('/api/auth/sign-up/email', {'name': name, 'email': email, 'password': password});

  Future<void> signOut(String token) async {
    await _dio.post<void>(
      '/api/auth/sign-out',
      data: const <String, dynamic>{},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<AuthSession> _authenticate(String path, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      final token = response.headers.value('set-auth-token');
      final user = response.data?['user'];
      if (token == null || user is! Map) {
        throw const AuthException('Đã có lỗi xảy ra. Thử lại nhé.');
      }
      return AuthSession(
        token: token,
        name: (user['name'] as String?) ?? '',
        email: (user['email'] as String?) ?? '',
      );
    } on DioException catch (error) {
      throw AuthException(authErrorMessage(error));
    }
  }
}
