import 'package:dio/dio.dart';

/// True when the failure means "no usable connection" rather than a rejected request, so
/// callers keep local changes queued and retry later.
bool isOffline(Object error) {
  if (error is! DioException) return false;
  return switch (error.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
      true,
    _ => (error.response?.statusCode ?? 0) >= 500,
  };
}

/// True for a 4xx the server will keep rejecting (validation, not found), as opposed to
/// auth expiry or throttling which are worth retrying.
bool isPermanentRejection(Object error) {
  if (error is! DioException) return false;
  final status = error.response?.statusCode ?? 0;
  return status >= 400 && status < 500 && status != 401 && status != 408 && status != 429;
}

/// Vietnamese, user-facing message for a failed request.
String describeApiError(Object error) {
  if (isOffline(error)) return 'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.';
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] is String) return data['message'] as String;
    if (data is Map && data['message'] is List) return (data['message'] as List).join(', ');
  }
  return 'Đã có lỗi xảy ra. Thử lại nhé.';
}
