import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mtbs_app/core/config/app_config.dart';
import 'package:mtbs_app/core/errors/app_exception.dart';
import 'package:mtbs_app/core/errors/error_mapper.dart';
import 'package:mtbs_app/core/network/auth_interceptor.dart';
import 'package:mtbs_app/core/network/refresh_token_interceptor.dart';
import 'package:mtbs_app/core/storage/session_store.dart';

class DioClient {
  DioClient(SessionStore sessionStore, {required VoidCallback onUnauthorized})
    : _dio = Dio(_baseOptions()),
      _refreshDio = Dio(_baseOptions()) {
    _dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(sessionStore),
      RefreshTokenInterceptor(
        dio: _dio,
        refreshDio: _refreshDio,
        sessionStore: sessionStore,
        onUnauthorized: onUnauthorized,
      ),
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (value) => debugPrint(value.toString()),
        ),
    ]);
  }

  final Dio _dio;
  final Dio _refreshDio;

  Dio get raw => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _guard(() => _dio.get<T>(path, queryParameters: queryParameters));

  Future<Response<T>> post<T>(String path, {Object? data}) =>
      _guard(() => _dio.post<T>(path, data: data));

  Future<Response<T>> patch<T>(String path, {Object? data}) =>
      _guard(() => _dio.patch<T>(path, data: data));

  Future<Response<T>> delete<T>(String path, {Object? data}) =>
      _guard(() => _dio.delete<T>(path, data: data));

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw ErrorMapper.fromDio(error);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UnknownException(error.toString()), stackTrace);
    }
  }

  static BaseOptions _baseOptions() => BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    headers: const <String, Object>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
}
