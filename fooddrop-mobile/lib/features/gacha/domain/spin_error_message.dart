import 'package:dio/dio.dart';

import '../../../core/api/api_error.dart';

/// Vietnamese copy for a failed spin; the server's messages are English.
String spinErrorMessage(Object error) {
  if (isOffline(error)) return 'Cần kết nối mạng để quay món. Kiểm tra mạng rồi thử lại.';
  if (error is DioException) {
    final response = error.response;
    if (response?.statusCode == 422) return 'Hòm này chưa có món nào. Chọn hòm khác hoặc thêm công thức nhé.';
    if (response?.statusCode == 429) {
      final data = response?.data;
      final seconds = data is Map && data['retryAfterSeconds'] is int ? data['retryAfterSeconds'] as int : null;
      return 'Bạn quay nhanh quá, thử lại ${seconds == null ? 'sau ít phút' : 'sau $seconds giây'}.';
    }
  }
  return 'Không quay được lúc này. Thử lại sau nhé.';
}
