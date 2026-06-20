import 'package:dio/dio.dart';
import 'package:mtbs_app/core/errors/app_exception.dart';

abstract final class ErrorMapper {
  static AppException fromDio(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkException();
    }

    final statusCode = error.response?.statusCode;
    final body = error.response?.data;
    final message = body is Map<String, dynamic> && body['message'] is String
        ? body['message']! as String
        : 'Yêu cầu không thể hoàn tất.';
    final details = body is Map<String, dynamic> ? body['errors'] : null;

    return switch (statusCode) {
      401 => UnauthorizedException(message),
      400 || 409 || 422 => ValidationException(message, details: details),
      _ => ApiException(message, statusCode: statusCode, details: details),
    };
  }
}
