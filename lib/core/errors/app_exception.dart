sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode, this.details});

  final String message;
  final int? statusCode;
  final Object? details;

  @override
  String toString() => message;
}

final class ApiException extends AppException {
  const ApiException(super.message, {super.statusCode, super.details});
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Không thể kết nối đến máy chủ.']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Phiên đăng nhập đã hết hạn.'])
    : super(statusCode: 401);
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.details})
    : super(statusCode: 422);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'Đã xảy ra lỗi không mong muốn.']);
}
