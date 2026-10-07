import 'package:dio/dio.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/api/api_error.dart';

String describeParseFailure(api.ParseJobErrorCodeEnum? code) => switch (code) {
      api.ParseJobErrorCodeEnum.urlBlocked =>
        'Liên kết này không hợp lệ hoặc không được phép truy cập. Hãy dùng đường dẫn công khai bắt đầu bằng http(s).',
      api.ParseJobErrorCodeEnum.fetchFailed =>
        'Không tải được trang này (có thể trang chặn truy cập tự động). Hãy thử chụp ảnh công thức hoặc nhập tay.',
      api.ParseJobErrorCodeEnum.notARecipe => 'Không tìm thấy công thức nấu ăn trong nội dung này.',
      api.ParseJobErrorCodeEnum.imageUnreadable => 'Không đọc được ảnh. Hãy chụp rõ hơn, đủ sáng và thử lại.',
      api.ParseJobErrorCodeEnum.parserUnavailable => 'Dịch vụ đọc công thức đang bận hoặc chưa sẵn sàng. Vui lòng thử lại sau.',
      _ => 'Có lỗi khi đọc công thức. Vui lòng thử lại.',
    };

/// Errors thrown while starting a job, before any job exists.
String describeImportStartError(Object error) {
  if (error is DioException) {
    final status = error.response?.statusCode;
    if (status == 429) return 'Bạn đã nhập quá nhiều công thức. Hãy thử lại sau.';
    if (status == 503) return 'Tính năng nhập công thức tạm thời không khả dụng.';
    // Raw English server messages are not shown; connectivity problems get their own line.
    if (isOffline(error) && status == null) return describeApiError(error);
    return 'Không bắt đầu được việc nhập công thức.';
  }
  return 'Không bắt đầu được việc nhập công thức.';
}
