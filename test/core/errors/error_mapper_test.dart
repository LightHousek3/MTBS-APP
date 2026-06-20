import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtbs_app/core/errors/app_exception.dart';
import 'package:mtbs_app/core/errors/error_mapper.dart';

void main() {
  test('maps 401 responses to UnauthorizedException', () {
    final request = RequestOptions(path: '/protected');
    final error = DioException(
      requestOptions: request,
      response: Response<Map<String, dynamic>>(
        requestOptions: request,
        statusCode: 401,
        data: const <String, dynamic>{'message': 'Access token expired'},
      ),
    );

    expect(ErrorMapper.fromDio(error), isA<UnauthorizedException>());
  });

  test('maps connection failures to NetworkException', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/movies'),
      type: DioExceptionType.connectionError,
    );

    expect(ErrorMapper.fromDio(error), isA<NetworkException>());
  });
}
